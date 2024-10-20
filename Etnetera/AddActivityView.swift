//
//  AddActivityView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI

struct AddActivityView: View {
    @State private var activityName: String = ""
    @State private var activityPlace: String = ""
    @State private var activityDuration: String = ""
    @State private var databaseLocation: DatabaseLocation = .local
    @State private var isLoading: Bool = false
    @FocusState var isInputActive: Bool
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var databaseService: DatabaseService

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                InputView(
                    inputValue: $activityName,
                    title: "Name of activity",
                    placeholder: "Activity Name"
                )
                .focused($isInputActive)
                .shadow(radius: 2)

                InputView(
                    inputValue: $activityPlace,
                    title: "Place of activity",
                    placeholder: "Activity Place"
                )
                .focused($isInputActive)
                .shadow(radius: 2)

                InputView(
                    inputValue: $activityDuration,
                    title: "Duration of activity (in minutes)",
                    placeholder: "Activity Lenght",
                    keyboardType: .numberPad
                )
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
                .shadow(radius: 2)

                VStack(alignment: .leading) {
                    Text("Save location")
                    Picker(
                        "",
                        selection: $databaseLocation,
                        content: {
                            Text("Local").tag(DatabaseLocation.local)
                            Text("Remote").tag(DatabaseLocation.remote)
                        }
                    )
                    .shadow(radius: 2)
                    .pickerStyle(.segmented)
                }
                CustomButton(title: "Save") {
                    Task {
                        isLoading = true
                        await databaseService.saveToDatabase(
                            data: ActivityData(
                                id: UUID().uuidString,
                                activityName: activityName,
                                activityPlace: activityPlace,
                                activityDuration: activityDuration
                            ),
                            location: databaseLocation
                        )
                        navigationPath.removeLast()
                        isLoading = false
                    }
                }
            }
            .padding()
            .navigationTitle("Activity Data")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        navigationPath.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .modifier(LoadingModifier(isLoading: $isLoading))
    }
}

#Preview {
    AddActivityView(navigationPath: .constant(NavigationPath()))
}
