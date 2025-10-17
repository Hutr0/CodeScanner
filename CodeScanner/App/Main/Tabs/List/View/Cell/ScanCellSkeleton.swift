//
//  ScanCellSkeleton.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScanCellSkeleton: View {
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 12).fill(.quaternary).frame(width: 56, height: 56)
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4).fill(.quaternary).frame(width: 160, height: 14)
                RoundedRectangle(cornerRadius: 4).fill(.quaternary).frame(width: 100, height: 12)
                HStack {
                    Capsule().fill(.quaternary).frame(width: 60, height: 18)
                    RoundedRectangle(cornerRadius: 4).fill(.quaternary).frame(width: 60, height: 12)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Capsule().fill(.quaternary).frame(width: 20, height: 18)
                Capsule().fill(.quaternary).frame(width: 28, height: 18)
            }
        }
        .padding(.vertical, 8)
        .redacted(reason: .placeholder)
    }
}
