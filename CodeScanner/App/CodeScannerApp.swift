//
//  CodeScannerApp.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
internal import CoreData

@main
struct CodeScannerApp: App {

    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
