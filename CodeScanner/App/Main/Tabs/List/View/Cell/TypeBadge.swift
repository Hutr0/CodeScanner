//
//  TypeBadge.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct TypeBadge: View {
    
    let type: String
    
    var body: some View {
        Text(type.uppercased())
            .lineLimit(1)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(.ultraThinMaterial, in: .capsule)
            .overlay(Capsule().stroke(Color.primary.opacity(0.08), lineWidth: 1))
    }
}

#Preview {
    TypeBadge(type: "QR")
}
