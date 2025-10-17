//
//  ScanDetailSkeleton.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailSkeleton: View {
    
    let code: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16).fill(.quaternary).frame(height: 220)
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 6).fill(.quaternary).frame(height: 20)
                    HStack {
                        RoundedRectangle(cornerRadius: 6).fill(.quaternary).frame(width: 100, height: 14)
                        Spacer()
                        Capsule().fill(.quaternary).frame(width: 90, height: 20)
                        Capsule().fill(.quaternary).frame(width: 70, height: 20)
                    }
                }
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 6).fill(.quaternary).frame(width: 60, height: 20)
                            RoundedRectangle(cornerRadius: 6).fill(.quaternary).frame(width: 80, height: 10)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial, in: .rect(cornerRadius: 12))
                    }
                }
                .redacted(reason: .placeholder)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Загрузка…")
        .navigationBarTitleDisplayMode(.inline)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    ScanDetailSkeleton(code: "Code 123")
}
