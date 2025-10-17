//
//  ScanCell.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScanCell: View {
    
    let dto: ScanDTO
    
    var onRename: ((ScanDTO) -> Void)?
    var onShare: ((ScanDTO) -> Void)?
    var onDelete: ((ScanDTO) -> Void)?
    
    var body: some View {
        if dto.isLoading {
            ScanCellSkeleton()
        } else {
            HStack(alignment: .top, spacing: 12) {
                ScanCellIcon(dto: dto)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(primaryTitle)
                        .font(.headline)
                        .lineLimit(2)
                    
                    if let secondary = secondaryLine, !secondary.isEmpty {
                        Text(secondary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        TypeBadge(type: dto.type)
                            .layoutPriority(1000)
                        Text(dto.date.formattedRelative())
                            .layoutPriority(999)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer(minLength: 8)
                
                VStack(alignment: .trailing, spacing: 6) {
                    if let s = dto.product?.nutriScore {
                        NutriScorePill(score: s)
                    }
                    if let n = dto.product?.novaGroup {
                        NovaPill(group: n)
                    }
                }
            }
            .contextMenu {
                Button("Переименовать", systemImage: "pencil") {
                    onRename?(dto)
                }
                Button("Копировать код", systemImage: "doc.on.doc") {
                    UIPasteboard.general.string = dto.code
                }
                Button("Поделиться", systemImage: "square.and.arrow.up") {
                    onShare?(dto)
                }
                if onDelete != nil {
                    Divider()
                    Button(role: .destructive) {
                        onDelete?(dto)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityText)
        }
    }
    
    private var primaryTitle: String {
        if let name = dto.product?.name, !name.isEmpty { return name }
        if !dto.title.isEmpty { return dto.title }
        return dto.code
    }
    
    private var secondaryLine: String? {
        if let brand = dto.product?.brand, !brand.isEmpty { return brand }
        if dto.product == nil { return dto.code }
        return nil
    }
    
    private var accessibilityText: String {
        var parts: [String] = [primaryTitle]
        if let secondary = secondaryLine { parts.append(secondary) }
        parts.append(dto.type == "QR" ? "QR-код" : "Штрихкод")
        parts.append(dto.date.formatted(date: .abbreviated, time: .shortened))
        if let s = dto.product?.nutriScore { parts.append("Nutri-Score \(s)") }
        if let n = dto.product?.novaGroup { parts.append("NOVA \(n)") }
        return parts.joined(separator: ", ")
    }

}


// MARK: - Preview

#Preview("Barcode + Product") {
    NavigationStack {
        List {
            NavigationLink(value: "1") {
                ScanCell(dto: .init(
                    code: "4601234567890",
                    type: "Barcode",
                    title: "Шоколад молочный",
                    isProduct: true,
                    product: OFFProductDTO(
                        code: "4601234567890",
                        name: "Шоколад молочный",
                        brand: "GoodBrand",
                        quantity: "90 г",
                        countries: nil,
                        categories: [],
                        nutriScore: "D",
                        novaGroup: "4",
                        nutriments: nil,
                        allergens: nil,
                        traces: nil,
                        ingredientsText: nil,
                        imageThumb: URL(string: "https://images.openfoodfacts.org/images/products/389/483/305/front_ru.5.400.jpg"),
                        imageFront: nil,
                        imageIngredients: nil,
                        imageNutrition: nil,
                        lastModified: .now
                    ),
                    isLoading: false
                ))
            }
            NavigationLink(value: "1") {
                ScanCell(dto: .init(
                    code: "4601234567890",
                    type: "Barcode",
                    title: "Шоколад молочный",
                    isProduct: true,
                    product: OFFProductDTO(
                        code: "4601234567890",
                        name: "Шоколад молочный",
                        brand: "GoodBrand",
                        quantity: "90 г",
                        countries: nil,
                        categories: [],
                        nutriScore: "DВВВВ",
                        novaGroup: "41фывф",
                        nutriments: nil,
                        allergens: nil,
                        traces: nil,
                        ingredientsText: nil,
                        imageThumb: URL(string: "https://images.openfoodfacts.org/images/products/389/483/305/front_ru.5.400.jpg"),
                        imageFront: nil,
                        imageIngredients: nil,
                        imageNutrition: nil,
                        lastModified: .now
                    ),
                    isLoading: false
                ))
            }
            NavigationLink(value: "2") {
                ScanCell(dto: .init(
                    code: "https://openai.com",
                    type: "QR",
                    title: "Ссылка",
                    isProduct: false,
                    product: nil,
                    isLoading: false
                ))
            }
            NavigationLink(value: "3") {
                ScanCell(dto: .init(
                    code: "123",
                    type: "Barcode",
                    title: "Новый скан",
                    isProduct: false,
                    product: nil,
                    isLoading: true
                ))
            }
        }
    }
}
