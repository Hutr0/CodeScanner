//
//  CodeScannerApp.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
import CoreData

@main
struct CodeScannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
