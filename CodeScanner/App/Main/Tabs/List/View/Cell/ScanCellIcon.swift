//
//  ScanCellIcon.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScanCellIcon: View {
    
    let dto: ScanDTO
    
    private var imageURL: URL? {
        dto.product?.imageFront ?? dto.product?.imageThumb
    }
    
    var body: some View {
        Group {
            if let url = imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .empty:
                        ZStack {
                            Color.secondary.opacity(0.1)
                            ProgressView()
                        }
                    case .failure(_):
                        PlaceholderIcon(type: dto.type)
                    @unknown default:
                        PlaceholderIcon(type: dto.type)
                    }
                }
            } else {
                PlaceholderIcon(type: dto.type)
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct PlaceholderIcon: View {
    
    let type: String
    
    var body: some View {
        ZStack {
            Image(systemName: type.uppercased() == "QR" ? "qrcode.viewfinder" : "barcode.viewfinder")
                .imageScale(.large)
                .foregroundStyle(.secondary)
        }
    }
}
