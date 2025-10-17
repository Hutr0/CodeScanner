//
//  ProductEntityExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

internal import CoreData

extension Product {
    
    @discardableResult
    static func upsert(from dto: OFFProductDTO, to obj: Product, in ctx: NSManagedObjectContext) throws -> Product {

        // Обязательные/ключевые
        obj.code = dto.code

        // Простые поля
        obj.name = dto.name
        obj.brand = dto.brand
        obj.quantity = dto.quantity
        obj.countries = dto.countries
        obj.nutriScore = dto.nutriScore
        obj.novaGroup = dto.novaGroup
        obj.allergens = dto.allergens
        obj.traces = dto.traces
        obj.ingredientsText = dto.ingredientsText
        obj.lastModified = dto.lastModified

        // Категории: сохраняем строкой
        obj.categories = dto.categories.isEmpty ? nil : dto.categories.joined(separator: ", ")

        // Картинки: URL? → String?
        obj.imageThumb = dto.imageThumb?.absoluteString
        obj.imageFront = dto.imageFront?.absoluteString
        obj.imageIngredients = dto.imageIngredients?.absoluteString
        obj.imageNutrition = dto.imageNutrition?.absoluteString

        // createdAt — если обязательный
        if obj.createdAt == nil { obj.createdAt = Date() }

        // Nutriments
        if let ndto = dto.nutriments {
            let n = obj.nutriments ?? Nutriments(context: ctx)
            n.energy100g = ndto.energy100g ?? 0
            n.energyServing = ndto.energyServing ?? 0
            n.energyUnit = ndto.energyUnit
            n.proteins100g = ndto.proteins100g ?? 0
            n.proteinsServing = ndto.proteinsServing ?? 0
            n.fat100g = ndto.fat100g ?? 0
            n.fatServing = ndto.fatServing ?? 0
            n.saturatedFat100g = ndto.saturatedFat100g ?? 0
            n.saturatedFatServing = ndto.saturatedFatServing ?? 0
            n.carbohydrates100g = ndto.carbohydrates100g ?? 0
            n.carbohydratesServing = ndto.carbohydratesServing ?? 0
            n.sugars100g = ndto.sugars100g ?? 0
            n.sugarsServing = ndto.sugarsServing ?? 0
            n.salt100g = ndto.salt100g ?? 0
            n.saltServing = ndto.saltServing ?? 0
            n.product = obj
            obj.nutriments = n
        } else {
            obj.nutriments = nil
        }

        return obj
    }
}
