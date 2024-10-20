//
//  ActivityData.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import Foundation

class ActivityData: Codable, Identifiable {
    let id: String
    let activityName: String
    let activityPlace: String
    let activityDuration: String
    
    init(id: String, activityName: String, activityPlace: String, activityDuration: String) {
        self.id = id
        self.activityName = activityName
        self.activityPlace = activityPlace
        self.activityDuration = activityDuration
    }

    func toCategorized(category: DatabaseLocation) -> CategorizedActivityData {
        CategorizedActivityData(
            id: self.id,
            activityName: self.activityName,
            activityPlace: self.activityPlace,
            activityDuration: self.activityDuration,
            databaseLocation: category
        )
    }
}

class CategorizedActivityData: ActivityData {
    let databaseLocation: DatabaseLocation
    
    init(id: String, activityName: String, activityPlace: String, activityDuration: String, databaseLocation: DatabaseLocation) {
        self.databaseLocation = databaseLocation

        super.init(id: id, activityName: activityName, activityPlace: activityPlace, activityDuration: activityDuration)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        databaseLocation = try container.decode(DatabaseLocation.self, forKey: .databaseLocation)

        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
         case databaseLocation
     }
}

enum DatabaseLocation: Decodable {
    case local
    case remote
}
