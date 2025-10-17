//
//  ScanDetailKPI.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailKPI: View {
    
    let title: String
    let value: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value ?? "—").font(.title3.weight(.semibold))
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: .rect(cornerRadius: 12))
        .contextMenu {
            if let value {
                Button("Скопировать") { UIPasteboard.general.string = value }
            }
        }
    }
}

#Preview {
    ScanDetailKPI(title: "Title", value: "value")
}
