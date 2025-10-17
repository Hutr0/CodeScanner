//
//  OpenFoodFactsNetworkManager.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

final class OFFNetworkManager: AnyObject {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .useDefaultKeys
    }
    
    func requestInfo(by code: String, preferredLang: String = Locale.current.language.languageCode?.identifier ?? "ru") async throws -> OFFProductDTO {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(code).json") else {
            throw OFFError.badURL
        }
        
        var req = URLRequest(url: url)
        req.timeoutInterval = 15
        req.cachePolicy = .reloadIgnoringLocalCacheData
        
        let (data, response) = try await session.data(for: req)
        
        guard let http = response as? HTTPURLResponse else { throw OFFError.malformedResponse }
        guard (200..<300).contains(http.statusCode) else { throw OFFError.http(http.statusCode) }
        
        let api = try decoder.decode(OFFAPIResponse.self, from: data)
        guard api.status == 1, let raw = api.product else { throw OFFError.notFound(code) }
        
        return map(raw, preferredLang: preferredLang)
    }
    
}


// MARK: - Mapping & Raw models

private extension OFFNetworkManager {

    struct OFFAPIResponse: Decodable {
        let status: Int
        let status_verbose: String?
        let code: String
        let product: OFFRawProduct?
    }

    struct OFFRawProduct: Decodable {
        let code: String?
        // имена (локали + дефолт)
        let product_name: String?
        let product_name_ru: String?
        let product_name_en: String?
        // бренды/страны/кол-во
        let brands: String?
        let quantity: String?
        let countries: String?
        // категории (теги)
        let categories_tags: [String]?
        // нутри-аггрегаты
        let nutrition_grades: String?
        let nova_groups: String?
        let nutriments: NutrimentsDTO?
        // аллергены/следы
        let allergens: String?
        let traces: String?
        // ингредиенты (локали + дефолт)
        let ingredients_text: String?
        let ingredients_text_ru: String?
        let ingredients_text_en: String?
        // изображения (прямые урлы)
        let image_thumb_url: URL?
        let image_front_url: URL?
        let image_ingredients_url: URL?
        let image_nutrition_url: URL?
        // selected_images для выбора по языку
        let selected_images: SelectedImages?
        // время
        let last_modified_t: TimeInterval?

        struct SelectedImages: Decodable {
            let front: LangImages?
            let ingredients: LangImages?
            let nutrition: LangImages?
            struct LangImages: Decodable {
                let display: [String:String]? // "fr": "https://..."
                let thumb:   [String:String]?
                let small:   [String:String]?
            }
        }
    }

    func map(_ raw: OFFRawProduct, preferredLang: String) -> OFFProductDTO {
        let prio = [preferredLang.lowercased(), "en", "fr", ""] // порядок фолбэков

        func pickName() -> String? {
            for lang in prio {
                switch lang {
                case "ru": if let s = raw.product_name_ru, !s.isEmpty { return s }
                case "en": if let s = raw.product_name_en, !s.isEmpty { return s }
                default: break
                }
            }
            return raw.product_name
        }

        func pickIngredients() -> String? {
            for lang in prio {
                switch lang {
                case "ru": if let s = raw.ingredients_text_ru, !s.isEmpty { return s }
                case "en": if let s = raw.ingredients_text_en, !s.isEmpty { return s }
                default: break
                }
            }
            return raw.ingredients_text
        }

        func pickFrontImage() -> URL? {
            if let dict = raw.selected_images?.front?.display {
                for lang in prio {
                    if let s = dict[lang], let url = URL(string: s) { return url }
                }
            }
            return raw.image_front_url
        }

        func pickThumbImage() -> URL? {
            if let dict = raw.selected_images?.front?.thumb {
                for lang in prio {
                    if let s = dict[lang], let url = URL(string: s) { return url }
                }
            }
            return raw.image_thumb_url
        }

        let lastMod: Date? = {
            guard let t = raw.last_modified_t, t > 0 else { return nil }
            return Date(timeIntervalSince1970: t)
        }()

        return OFFProductDTO(
            code: raw.code ?? "",
            name: pickName(),
            brand: (raw.brands?.isEmpty == false ? raw.brands : nil),
            quantity: raw.quantity,
            countries: raw.countries,
            categories: raw.categories_tags ?? [],
            nutriScore: raw.nutrition_grades,
            novaGroup: raw.nova_groups,
            nutriments: raw.nutriments,
            allergens: raw.allergens,
            traces: raw.traces,
            ingredientsText: pickIngredients(),
            imageThumb: pickThumbImage(),
            imageFront: pickFrontImage(),
            imageIngredients: raw.image_ingredients_url,
            imageNutrition: raw.image_nutrition_url,
            lastModified: lastMod
        )
    }
}
