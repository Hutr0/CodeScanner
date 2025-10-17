//
//  ScanDetailHeaderImageCarousel.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentHeaderImageCarousel: View {
    
    let images: [URL]
    let isQR: Bool
    
    @State private var index = 0

    var body: some View {
        if images.isEmpty {
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                VStack(spacing: 8) {
                    Image(systemName: isQR ? "qrcode" : "barcode.viewfinder")
                        .font(.largeTitle)
                    Text("Нет изображения")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding(24)
            }
            .frame(height: 220)
        } else {
            TabView(selection: $index) {
                ForEach(Array(images.enumerated()), id: \.offset) { i, url in
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        case .failure(_):
                            ZStack { Rectangle().fill(.ultraThinMaterial); Image(systemName: "exclamationmark.triangle") }
                        case .empty:
                            ZStack { Rectangle().fill(.ultraThinMaterial); ProgressView() }
                        @unknown default:
                            Color.secondary.opacity(0.2)
                        }
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 220)
        }
    }
}

#Preview {
    ScanDetailContentHeaderImageCarousel(images: [], isQR: false)
}
