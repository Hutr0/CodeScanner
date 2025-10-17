//
//  ScanDetailMinimal.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct MinimalScanContent: View {
    
    let scan: ScanDTO

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    VStack(spacing: 10) {
                        Image(systemName: scan.isQR ? "qrcode" : "barcode.viewfinder")
                            .font(.system(size: 48, weight: .regular))
                        if !scan.title.isEmpty {
                            Text(scan.title).font(.title3.weight(.semibold))
                                .lineLimit(2)
                        } else {
                            Text(scan.isQR ? "QR-код" : "Скан")
                                .font(.title3.weight(.semibold))
                        }
                        TypeBadge(type: scan.type)
                    }
                    .padding(24)
                }
                .frame(height: 220)

                VStack(spacing: 12) {
                    ScanDetailKPI(title: "Код", value: scan.code)
                    if !scan.isQR {
                        // Под QR «ккал/порция» и пр. не показываем
                        ScanDetailKPI(title: "Тип", value: scan.type)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !scan.isQR {
                    ScanDetailSimpleTextSection(
                        title: "Товар не найден",
                        text: "Мы не смогли подгрузить карточку товара по этому коду. Попробуй отсканировать ещё раз — или добавь заметку в названии."
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle((scan.title.isEmpty == false) ? scan.title : (scan.codeText))
        .navigationBarTitleDisplayMode(.inline)
    }
}
