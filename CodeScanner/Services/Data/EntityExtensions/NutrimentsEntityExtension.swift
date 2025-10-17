//
//  NutrimentsEntityExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

internal import CoreData

extension Nutriments {
    
    var kcal100gComputed: Double? {
        guard energy100g != 0 else { return nil }
        return (energyUnit?.lowercased() == "kcal") ? energy100g : energy100g / 4.184
    }

    var kcalServingComputed: Double? {
        guard energyServing != 0 else { return nil }
        return (energyUnit?.lowercased() == "kcal") ? energyServing : energyServing / 4.184
    }
}
