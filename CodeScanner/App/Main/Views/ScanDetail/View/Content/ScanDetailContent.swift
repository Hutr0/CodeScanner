//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContent: View {
    
    let scan: ScanDTO
    let product: OFFProductDTO

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ScanDetailContentHeader(scan: scan, product: product)

                ScanDetailKPICards(scan: scan, product: product)

                if let nutr = product.nutriments {
                    ScanDetailContentNutrimentsSection(nutr: nutr)
                }

                if !(product.categories.isEmpty) || !(product.countries?.isEmpty ?? true) {
                    ScanDetailContentTaxonomySection(categories: product.categories, countries: product.countries)
                }

                if let ing = product.ingredientsText, !ing.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ScanDetailContentExpandableTextSection(title: "Ингредиенты", text: ing)
                }

                if let allergens = product.allergens, !allergens.isEmpty {
                    ScanDetailSimpleTextSection(title: "Аллергены", text: allergens, icon: "exclamationmark.octagon")
                }

                if let traces = product.traces, !traces.isEmpty {
                    ScanDetailSimpleTextSection(title: "Может содержать следы", text: traces, icon: "triangle")
                }

                ScanDetailContentTechnicalSection(scan: scan, product: product)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    ScanDetailContent(scan: .getPreview(), product: .getPreview())
}
