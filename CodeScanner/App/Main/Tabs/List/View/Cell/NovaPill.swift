//
//  NovaPill.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct NovaPill: View {
    
    let group: String
    
    private var color: Color {
        switch group {
        case "1": return .green
        case "2": return .yellow
        case "3": return .orange
        case "4": return .red
        default:  return .secondary
        }
    }
    
    var body: some View {
        if group.count > 0 && group.count <= 2 {
            Text("N\(group)")
                .font(.caption.weight(.bold))
                .padding(.horizontal, 6).padding(.vertical, 3)
                .background(color.opacity(0.18), in: .capsule)
                .overlay(Capsule().stroke(color.opacity(0.35), lineWidth: 1))
                .accessibilityLabel("NOVA \(group)")
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NovaPill(group: "4")
}
