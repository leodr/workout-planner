//
//  workout_plannerApp.swift
//  Shared
//
//  Created by Leo Driesch on 09.05.22.
//

import SwiftUI

@main
struct workout_plannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
