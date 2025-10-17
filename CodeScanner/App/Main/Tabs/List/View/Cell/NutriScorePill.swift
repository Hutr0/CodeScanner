//
//  NutriScorePill.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct NutriScorePill: View {
    
    let score: String
    
    private var normalized: String { score.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
    
    private var color: Color {
        switch normalized {
        case "A": return .green
        case "B": return .green.opacity(0.7)
        case "C": return .yellow
        case "D": return .orange
        case "E": return .red
        default:  return .secondary
        }
    }
    
    var body: some View {
        if normalized.count > 0 && normalized.count <= 2 {
            Text(normalized)
                .font(.caption.weight(.bold))
                .padding(.horizontal, 6).padding(.vertical, 3)
                .background(color.opacity(0.18), in: .capsule)
                .overlay(Capsule().stroke(color.opacity(0.35), lineWidth: 1))
                .accessibilityLabel("Nutri-Score \(normalized)")
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NutriScorePill(score: "D")
}
