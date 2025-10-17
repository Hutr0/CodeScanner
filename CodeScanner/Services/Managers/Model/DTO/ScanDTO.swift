//
//  ScanDTO.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

struct ScanDTO {
    
    
    // MARK: Init
    
    init(code: String, type: String, title: String, isProduct: Bool, product: OFFProductDTO?, isLoading: Bool = true) {
        self.code = code
        self.type = type
        self.title = title
        self.date = Date()
        self.isProduct = false
        self.product = product
        self.isLoading = isLoading
    }
    
    init(from scannerResult: ScannerResult) {
        self.code = scannerResult.code
        self.type = scannerResult.isQR ? "QR" : "Barcode"
        self.title = "Новый скан"
        self.date = Date()
        self.isProduct = false
        
        self.product = nil
        self.isLoading = true
    }
    
    init(from scan: Scan) {
        self.code = scan.code ?? "without_code"
        self.type = scan.type ?? "missed_type"
        self.title = scan.title ?? "Скан"
        self.date = scan.date ?? Date()
        self.isProduct = scan.isProduct
        self.product = scan.product != nil ? OFFProductDTO(from: scan.product!) : nil
        
        self.isLoading = false
    }
    
    
    // MARK: Parameters
    
    let code: String
    var type: String
    var title: String
    let date: Date
    var isProduct: Bool
    
    var product: OFFProductDTO?
    
    var isLoading: Bool
    
    
    // MARK: Computable parameters
    
    var isQR: Bool {
        type == "QR"
    }
    
    var codeText: String {
        isQR ? "QR-код" : "Скан"
    }
    
    var titleText: String {
        if isProduct, let p = product { return p.name ?? code }
        if !title.isEmpty { return title }
        return code
    }
    
    var shareText: String {
        if let product = product {
            let name = product.name ?? title
            let brand = product.brand ?? ""
            var text = "\(name)"
            if !brand.isEmpty { text += " — \(brand)" }
            text += "\n"
            if let nutri = product.nutriScore { text += "Nutri-Score: \(nutri)\n" }
            if let nova = product.novaGroup { text += "NOVA: \(nova)\n" }
            text += "Код: \(product.code)"
            return text
        } else {
            return type == "QR" ? code : "Штрихкод: \(code)"
        }
    }
    
    
    // MARK: Preview
    
    static func getPreview(isLoading: Bool = false) -> ScanDTO {
        ScanDTO(code: "Code 123", type: "Type 123", title: "Title 123", isProduct: true, product: nil, isLoading: isLoading)
    }
    
}

