//
//  Nutriments.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

struct NutrimentsDTO: Decodable {
    
    
    // MARK: Init
    
    init(
        energy100g: Double?,
        energyServing: Double?,
        energyUnit: String?,
        proteins100g: Double?,
        proteinsServing: Double?,
        fat100g: Double?,
        fatServing: Double?,
        saturatedFat100g: Double?,
        saturatedFatServing: Double?,
        carbohydrates100g: Double?,
        carbohydratesServing: Double?,
        sugars100g: Double?,
        sugarsServing: Double?,
        salt100g: Double?,
        saltServing: Double?
    ) {
        self.energy100g = energy100g
        self.energyServing = energyServing
        self.energyUnit = energyUnit
        self.proteins100g = proteins100g
        self.proteinsServing = proteinsServing
        self.fat100g = fat100g
        self.fatServing = fatServing
        self.saturatedFat100g = saturatedFat100g
        self.saturatedFatServing = saturatedFatServing
        self.carbohydrates100g = carbohydrates100g
        self.carbohydratesServing = carbohydratesServing
        self.sugars100g = sugars100g
        self.sugarsServing = sugarsServing
        self.salt100g = salt100g
        self.saltServing = saltServing
    }
    
    init(from nutriments: Nutriments) {
        self.energy100g = nutriments.energy100g == 0 ? nil : nutriments.energy100g
        self.energyServing = nutriments.energyServing == 0 ? nil : nutriments.energyServing
        self.energyUnit = nutriments.energyUnit
        self.proteins100g = nutriments.proteins100g == 0 ? nil : nutriments.proteins100g
        self.proteinsServing = nutriments.proteinsServing == 0 ? nil : nutriments.proteinsServing
        self.fat100g = nutriments.fat100g == 0 ? nil : nutriments.fat100g
        self.fatServing = nutriments.fatServing == 0 ? nil : nutriments.fatServing
        self.saturatedFat100g = nutriments.saturatedFat100g == 0 ? nil : nutriments.saturatedFat100g
        self.saturatedFatServing = nutriments.saturatedFatServing == 0 ? nil : nutriments.saturatedFatServing
        self.carbohydrates100g = nutriments.carbohydrates100g == 0 ? nil : nutriments.carbohydrates100g
        self.carbohydratesServing = nutriments.carbohydratesServing == 0 ? nil : nutriments.carbohydratesServing
        self.sugars100g = nutriments.sugars100g == 0 ? nil : nutriments.sugars100g
        self.sugarsServing = nutriments.sugarsServing == 0 ? nil : nutriments.sugarsServing
        self.salt100g = nutriments.salt100g == 0 ? nil : nutriments.salt100g
        self.saltServing = nutriments.saltServing == 0 ? nil : nutriments.saltServing
    }
    
    
    // MARK: Parameters
    
    let energy100g: Double?
    let energyServing: Double?
    let energyUnit: String?
    let proteins100g: Double?
    let proteinsServing: Double?
    let fat100g: Double?
    let fatServing: Double?
    let saturatedFat100g: Double?
    let saturatedFatServing: Double?
    let carbohydrates100g: Double?
    let carbohydratesServing: Double?
    let sugars100g: Double?
    let sugarsServing: Double?
    let salt100g: Double?
    let saltServing: Double?
    
    
    // MARK: CodingKeys

    enum CodingKeys: String, CodingKey {
        case energy100g = "energy_100g"
        case energyServing = "energy_serving"
        case energyUnit = "energy_unit"
        case proteins100g = "proteins_100g"
        case proteinsServing = "proteins_serving"
        case fat100g = "fat_100g"
        case fatServing = "fat_serving"
        case saturatedFat100g = "saturated-fat_100g"
        case saturatedFatServing = "saturated-fat_serving"
        case carbohydrates100g = "carbohydrates_100g"
        case carbohydratesServing = "carbohydrates_serving"
        case sugars100g = "sugars_100g"
        case sugarsServing = "sugars_serving"
        case salt100g = "salt_100g"
        case saltServing = "salt_serving"
    }
    
    
    // MARK: Methods

    var kcal100g: Double? {
        guard let e = energy100g else { return nil }
        return energyUnit?.lowercased() == "kcal" ? e : e / 4.184
    }
    
    var kcalServing: Double? {
        guard let e = energyServing else { return nil }
        return energyUnit?.lowercased() == "kcal" ? e : e / 4.184
    }
    
}
