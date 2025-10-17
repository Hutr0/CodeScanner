//
//  ScanDetailSimpleTextSection.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailSimpleTextSection: View {
    
    let title: String
    let text: String
    var icon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                if let icon { Image(systemName: icon) }
                Text(title).font(.headline)
            }
            Text(text).font(.subheadline)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    ScanDetailSimpleTextSection(title: "title", text: "text", icon: "circle")
}
