//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentExpandableTextSection: View {
    
    let title: String
    let text: String

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(expanded ? nil : 4)
            Button(expanded ? "Свернуть" : "Показать больше") {
                withAnimation(.snappy) { expanded.toggle() }
            }
            .font(.caption)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    ScanDetailContentExpandableTextSection(title: "title", text: "text")
}
