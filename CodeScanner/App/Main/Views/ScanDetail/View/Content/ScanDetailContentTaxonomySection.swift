//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentTaxonomySection: View {
    
    let categories: [String]
    let countries: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !categories.isEmpty {
                Text("Категории").font(.headline)
                TagCloud(tags: categories)
                    .padding(12)
                    .background(.thinMaterial, in: .rect(cornerRadius: 12))
            }
            if let c = countries, !c.isEmpty {
                Text("Страны").font(.headline)
                TagCloud(tags: c.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
                    .padding(12)
                    .background(.thinMaterial, in: .rect(cornerRadius: 12))
            }
        }
    }
}

private struct TagCloud: View {
    let tags: [String]
    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(tags.uniqued(), id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial, in: .capsule)
            }
        }
    }
}

#Preview {
    ScanDetailContentTaxonomySection(categories: [], countries: "1,2,3")
}
