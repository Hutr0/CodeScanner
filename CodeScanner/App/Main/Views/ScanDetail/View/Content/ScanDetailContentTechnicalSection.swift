//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentTechnicalSection: View {
    
    let scan: ScanDTO
    let product: OFFProductDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Техническая информация").font(.headline)
            LabeledContent("Код", value: scan.code)
            if let date = product.lastModified {
                LabeledContent("Изменён", value: date.formatted(date: .abbreviated, time: .shortened))
            }
            if let u = product.imageFront ?? product.imageThumb {
                LabeledContent("Фото", value: u.absoluteString).lineLimit(1)
            }
        }
        .padding(12)
        .background(.thinMaterial, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    ScanDetailContentTechnicalSection(scan: .getPreview(), product: .getPreview())
}
