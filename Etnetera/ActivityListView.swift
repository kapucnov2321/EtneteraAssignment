//
//  ContentView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI

enum ActivityFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case database = "Database"
    case firebase = "Firebase"
    
    var id: Int {
        switch self {
        case .all:
            0
        case .database:
            1
        case .firebase:
            2
        }
    }
}

enum NavigationDestination {
    case addActivity
}

struct ActivityListView: View {
    @EnvironmentObject var databaseService: DatabaseService
    @State private var isLoading: Bool = false
    @State private var selectedFilter: ActivityFilter = .all
    @State private var path = NavigationPath()
    @State private var wasFetched: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                HStack {
                    ForEach(ActivityFilter.allCases) { filter in
                        Text(filter.rawValue)
                            .padding(10)
                            .if(filter == selectedFilter) { view in
                                view.background(filter == .firebase ? .orange : .blue)
                                    .clipShape(.capsule)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                            .if(filter != selectedFilter) { view in
                                view.overlay(Capsule().stroke(.black, lineWidth: 1))
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedFilter = filter
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)

                handleFetchResult
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        path.append(NavigationDestination.addActivity)
                    }
                }
            }
            .navigationDestination(for: NavigationDestination.self, destination: { destination in
                switch destination {
                case .addActivity:
                    AddActivityView(navigationPath: $path)
                }
            })
            .navigationTitle("Activity List")
            .modifier(LoadingModifier(isLoading: $isLoading))
            .task {
                if !wasFetched {
                    isLoading = true
                    await databaseService.fetchDatabaseData()
                    isLoading = false
                    wasFetched = true
                }
            }
        }
    }
    
    @ViewBuilder
    var handleFetchResult: some View {
        switch databaseService.databaseFetchResult {
        case .initial:
            EmptyView()
        case .activityData(let array):
            let filteredData = getFilteredData(data: array)

            if filteredData.count == 0 {
                Text("No activities recorded. Use add button in top right corner")
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                List {
                    ForEach(filteredData) { activity in
                        ListItemView(activity: activity)
                            .listRowBackground(activity.databaseLocation == .remote ? Color.orange : Color.blue)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        isLoading = true
                                        await databaseService.deleteFromDatabase(data: activity)
                                        isLoading = false
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    isLoading = true
                    await databaseService.fetchDatabaseData()
                    isLoading = false
                }
            }
            .padding()
        }
    }
    
    private func getFilteredData(data: [CategorizedActivityData]) -> [CategorizedActivityData] {
        switch selectedFilter {
        case .all:
            return data
        case .database:
            return data.filter { $0.databaseLocation == .local }
        case .firebase:
            return data.filter { $0.databaseLocation == .remote }
        }
    }
}

#Preview {
    ActivityListView()
}
