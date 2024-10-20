//
//  EtneteraApp.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct EtneteraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var databaseService = DatabaseService()

    var body: some Scene {
        WindowGroup {
            ActivityListView()
                .environmentObject(databaseService)
        }
    }
}
