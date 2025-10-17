//
//  OFFProductDTO.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

struct OFFProductDTO: Decodable {
    
    
    // MARK: Init
    
    init(code: String, isLoading: Bool = true) {
        self.code = code
        self.name = nil
        self.brand = nil
        self.quantity = nil
        self.countries = nil
        self.categories = []
        self.nutriScore = nil
        self.novaGroup = nil
        self.nutriments = nil
        self.allergens = nil
        self.traces = nil
        self.ingredientsText = nil
        self.imageThumb = nil
        self.imageFront = nil
        self.imageIngredients = nil
        self.imageNutrition = nil
        self.lastModified = nil
        
        self.isLoading = isLoading
    }
    
    init(
        code: String,
        name: String?,
        brand: String?,
        quantity: String?,
        countries: String?,
        categories: [String],
        nutriScore: String?,
        novaGroup: String?,
        nutriments: NutrimentsDTO?,
        allergens: String?,
        traces: String?,
        ingredientsText: String?,
        imageThumb: URL?,
        imageFront: URL?,
        imageIngredients: URL?,
        imageNutrition: URL?,
        lastModified: Date?,
        isLoading: Bool = false
    ) {
        self.code = code
        self.name = name
        self.brand = brand
        self.quantity = quantity
        self.countries = countries
        self.categories = categories
        self.nutriScore = nutriScore
        self.novaGroup = novaGroup
        self.nutriments = nutriments
        self.allergens = allergens
        self.traces = traces
        self.ingredientsText = ingredientsText
        self.imageThumb = imageThumb
        self.imageFront = imageFront
        self.imageIngredients = imageIngredients
        self.imageNutrition = imageNutrition
        self.lastModified = lastModified
        
        self.isLoading = isLoading
    }
    
    init(from product: Product) {
        self.code = product.code ?? "without_code"
        self.name = product.name
        self.brand = product.brand
        self.quantity = product.quantity
        self.countries = product.countries
        self.categories = product.categories?.components(separatedBy: ", ") ?? []
        self.nutriScore = product.nutriScore
        self.novaGroup = product.novaGroup
        self.nutriments = product.nutriments != nil ? NutrimentsDTO(from: product.nutriments!) : nil
        self.allergens = product.allergens
        self.traces = product.traces
        self.ingredientsText = product.ingredientsText
        self.imageThumb = product.imageThumb != nil ? URL(string: product.imageThumb!) : nil
        self.imageFront = product.imageFront != nil ? URL(string: product.imageFront!) : nil
        self.imageIngredients = product.imageIngredients != nil ? URL(string: product.imageIngredients!) : nil
        self.imageNutrition = product.imageNutrition != nil ? URL(string: product.imageNutrition!) : nil
        self.lastModified = product.lastModified
        
        self.isLoading = false
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.brand = try container.decodeIfPresent(String.self, forKey: .brand)
        self.quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
        self.countries = try container.decodeIfPresent(String.self, forKey: .countries)
        self.categories = try container.decode([String].self, forKey: .categories)
        self.nutriScore = try container.decodeIfPresent(String.self, forKey: .nutriScore)
        self.novaGroup = try container.decodeIfPresent(String.self, forKey: .novaGroup)
        self.nutriments = try container.decodeIfPresent(NutrimentsDTO.self, forKey: .nutriments)
        self.allergens = try container.decodeIfPresent(String.self, forKey: .allergens)
        self.traces = try container.decodeIfPresent(String.self, forKey: .traces)
        self.ingredientsText = try container.decodeIfPresent(String.self, forKey: .ingredientsText)
        self.imageThumb = try container.decodeIfPresent(URL.self, forKey: .imageThumb)
        self.imageFront = try container.decodeIfPresent(URL.self, forKey: .imageFront)
        self.imageIngredients = try container.decodeIfPresent(URL.self, forKey: .imageIngredients)
        self.imageNutrition = try container.decodeIfPresent(URL.self, forKey: .imageNutrition)
        self.lastModified = try container.decodeIfPresent(Date.self, forKey: .lastModified)
        
        self.isLoading = false
    }
    
    
    // MARK: CodingKeys
    
    enum CodingKeys: CodingKey {
        case code
        case name
        case brand
        case quantity
        case countries
        case categories
        case nutriScore
        case novaGroup
        case nutriments
        case allergens
        case traces
        case ingredientsText
        case imageThumb
        case imageFront
        case imageIngredients
        case imageNutrition
        case lastModified
    }
    
    
    // MARK: Parameters
    
    let code: String
    let name: String?
    let brand: String?
    let quantity: String?
    let countries: String?
    let categories: [String]
    let nutriScore: String?
    let novaGroup: String?
    let nutriments: NutrimentsDTO?
    let allergens: String?
    let traces: String?
    let ingredientsText: String?
    let imageThumb: URL?
    let imageFront: URL?
    let imageIngredients: URL?
    let imageNutrition: URL?
    let lastModified: Date?
    
    let isLoading: Bool
    
    
    // MARK: Preview
    
    static func getPreview(isLoading: Bool = false) -> OFFProductDTO {
        OFFProductDTO(
            code: "123",
            name: "Имя",
            brand: "Бренд",
            quantity: nil,
            countries: nil,
            categories: [],
            nutriScore: "123",
            novaGroup: nil,
            nutriments: nil,
            allergens: nil,
            traces: nil,
            ingredientsText: nil,
            imageThumb: nil,
            imageFront: nil,
            imageIngredients: nil,
            imageNutrition: nil,
            lastModified: nil,
            isLoading: isLoading
        )
    }
    
}

