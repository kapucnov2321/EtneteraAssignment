//
//  DatabaseService.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI
import FirebaseDatabase
import Combine
import RealmSwift

enum DatabaseFetchResult {
    case initial
    case activityData([CategorizedActivityData])
    case error(Error)
}

enum DatabaseError: LocalizedError {
    case saveError
    case deleteError

    var errorDescription: String? {
        switch self {
        case .saveError:
            "Activity couldn't be saved. Check your internet connection"
        case .deleteError:
            "Activity couldn't be deleted. Check your internet connection"
        }
    }
}

@MainActor
class DatabaseService: ObservableObject {
    private let ref: DatabaseReference
    private let realm = try? Realm()
    private let firebaseActivityData = PassthroughSubject<[ActivityData], Never>()
    private let realmActivityData = PassthroughSubject<[ActivityData], Never>()
    private var cancellables = Set<AnyCancellable>()
    private var notificationToken: NotificationToken?

    @Published var databaseFetchResult: DatabaseFetchResult = .initial

    init() {
        ref = Database.database(url: "https://etneterazadanie-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        Publishers
            .CombineLatest(firebaseActivityData, realmActivityData)
            .map { firebaseData, localData in
                var combinedData: [CategorizedActivityData] = []
                combinedData.append(contentsOf: firebaseData.map { $0.toCategorized(category: .remote) })
                combinedData.append(contentsOf: localData.map { $0.toCategorized(category: .local) })
                return .activityData(combinedData)
            }
            .sink(receiveValue: { [weak self] activityData in
                self?.databaseFetchResult = activityData
            })
            .store(in: &cancellables)
    }
    
    func saveToDatabase(data: ActivityData, location: DatabaseLocation) async {
        do {
            switch location {
            case .local:
                let realmActivityData = RealmActivityData()
                realmActivityData.id = data.id
                realmActivityData.activityName = data.activityName
                realmActivityData.activityPlace = data.activityPlace
                realmActivityData.activityDuration = data.activityDuration
                
                try realm?.write {
                    realm?.add(realmActivityData)
                }
            case .remote:
                var activities = try await fetchFirebaseActivities()
                activities.append(data)
                
                let activitiesArrayString = try activities.encode()
                try await ref.child("activities").setValue(activitiesArrayString)
                
                firebaseActivityData.send(activities)
            }
        } catch {
            databaseFetchResult = .error(DatabaseError.saveError)
        }

    }
    
    func deleteFromDatabase(data: CategorizedActivityData) async {
        do {
            switch data.databaseLocation {
            case .local:
                guard let realmActivityData = realm?.objects(RealmActivityData.self).first(where: { $0.id == data.id }) else {
                    return
                }
                
                try realm?.write {
                    realm?.delete(realmActivityData)
                }
            case .remote:
                let activities = try await fetchFirebaseActivities().filter { $0.id != data.id }
                
                let activitiesArrayString = try activities.encode()
                try await ref.child("activities").setValue(activitiesArrayString)
                
                firebaseActivityData.send(activities)
            }
        } catch {
            databaseFetchResult = .error(DatabaseError.deleteError)
        }
    }
    
    func fetchDatabaseData() async {
        let firebaseActivities = (try? await fetchFirebaseActivities()) ?? []
        let realmActivities = realm?.objects(RealmActivityData.self)
        
        firebaseActivityData.send(firebaseActivities)
        
        notificationToken = realmActivities?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let realmActivityData):
                self?.realmActivityData.send(realmActivityData.compactMap { $0.toActivityData() })
            case .update(let realmActivityData, _, _, _):
                self?.realmActivityData.send(realmActivityData.compactMap { $0.toActivityData() })
            default:
                break
            }
        }
    }
    
    private func fetchFirebaseActivities() async throws -> [ActivityData] {
        let activityRef = ref.child("activities")
        let activityData = try await activityRef.getData()
        let activitiesString = activityData.value as? String ?? "[]"
        let activities = try activitiesString.decode(toClass: [ActivityData].self)
        
        return activities
    }
}
