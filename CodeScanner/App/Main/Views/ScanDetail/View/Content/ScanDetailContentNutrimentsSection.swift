//
//  ScanDetailContent.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI

struct ScanDetailContentNutrimentsSection: View {
    
    let nutr: NutrimentsDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Пищевая ценность").font(.headline)
                Spacer()
                Text("на 100 г / на порцию").font(.caption).foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                NutrientRow(name: "Энергия, ккал", v100: nutr.kcal100g?.asKcal, vServ: nutr.kcalServing?.asKcal)
                Divider()
                NutrientRow(name: "Белки, г", v100: nutr.proteins100g?.asGrams, vServ: nutr.proteinsServing?.asGrams)
                Divider()
                NutrientRow(name: "Жиры, г", v100: nutr.fat100g?.asGrams, vServ: nutr.fatServing?.asGrams)
                Divider()
                NutrientRow(name: "в т.ч. насыщенные, г", v100: nutr.saturatedFat100g?.asGrams, vServ: nutr.saturatedFatServing?.asGrams)
                Divider()
                NutrientRow(name: "Углеводы, г", v100: nutr.carbohydrates100g?.asGrams, vServ: nutr.carbohydratesServing?.asGrams)
                Divider()
                NutrientRow(name: "в т.ч. сахара, г", v100: nutr.sugars100g?.asGrams, vServ: nutr.sugarsServing?.asGrams)
                Divider()
                NutrientRow(name: "Соль, г", v100: nutr.salt100g?.asGrams, vServ: nutr.saltServing?.asGrams)
            }
            .padding(12)
            .background(.thinMaterial, in: .rect(cornerRadius: 12))
        }
    }
}

private struct NutrientRow: View {
    let name: String
    let v100: String?
    let vServ: String?

    var body: some View {
        HStack {
            Text(name).font(.subheadline)
            Spacer(minLength: 12)
            Text(v100 ?? "—").font(.subheadline.weight(.medium))
                .frame(width: 86, alignment: .trailing)
                .accessibilityLabel("\(name) на 100 грамм")
            Text(vServ ?? "—").font(.subheadline.weight(.medium))
                .frame(width: 86, alignment: .trailing)
                .accessibilityLabel("\(name) на порцию")
        }
        .foregroundStyle(.primary)
    }
}
