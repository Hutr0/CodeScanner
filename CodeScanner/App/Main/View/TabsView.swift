//
//  TabBar.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
internal import CoreData

struct TabsView: View {
    
    var body: some View {
        TabView {
            Tab() {
                ListView()
            } label: {
                Image(systemName: "list.bullet")
            }
            Tab(role: .search) {
                ScanView()
            } label: {
                Image(systemName: "qrcode.viewfinder")
            }

        }
    }
}

#Preview {
    TabsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
