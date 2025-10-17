//
//  ScanDetailKPI.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailKPICards: View {
    
    let scan: ScanDTO
    let product: OFFProductDTO

    var body: some View {
        let kcal100 = product.nutriments?.kcal100g
        let kcalServ = product.nutriments?.kcalServing

        HStack(spacing: 12) {
            ScanDetailKPI(title: "ккал / 100 г", value: kcal100?.asKcal)
            ScanDetailKPI(title: "ккал / порция", value: kcalServ?.asKcal)
            ScanDetailKPI(title: "Штрих-код", value: scan.code)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ScanDetailKPICards(scan: .getPreview(), product: .getPreview())
}
