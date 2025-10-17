//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentHeader: View {
    
    let scan: ScanDTO
    let product: OFFProductDTO

    private var images: [URL] {
        [product.imageFront, product.imageThumb, product.imageNutrition, product.imageIngredients]
            .compactMap { $0 }.uniqued()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScanDetailContentHeaderImageCarousel(images: images, isQR: scan.isQR)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name ?? (scan.title.isEmpty == false ? scan.title : "Без названия"))
                    .font(.title2.weight(.semibold))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if let brand = product.brand, !brand.isEmpty {
                        Label(brand, systemImage: "tag")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if let s = product.nutriScore { NutriScorePill(score: s) }
                    if let n = product.novaGroup { NovaPill(group: n) }
                }
            }
        }
    }
}
#Preview {
    ScanDetailContentHeader(scan: .getPreview(), product: .getPreview())
}
