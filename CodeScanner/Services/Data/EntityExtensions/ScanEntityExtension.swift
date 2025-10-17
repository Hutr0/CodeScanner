//
//  ScanEntityExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation
internal import CoreData

extension Scan {
    
    @discardableResult
    static func upsert(from dto: ScanDTO, in ctx: NSManagedObjectContext) throws -> Scan {
        let req: NSFetchRequest<Scan> = Scan.fetchRequest()
        req.predicate = NSPredicate(format: "code == %@", dto.code)
        req.fetchLimit = 1

        let obj = try ctx.fetch(req).first ?? Scan(context: ctx)

        // Обязательные/ключевые
        obj.code = dto.code

        // Простые поля
        
        obj.type = dto.type
        obj.title = dto.title
        obj.date = dto.date
        obj.isProduct = dto.isProduct
        
        if let pdto = dto.product {
            let p = obj.product ?? Product(context: ctx)
            obj.product = try? Product.upsert(from: pdto, to: p, in: ctx)
        } else {
            obj.product = nil
        }

        return obj
    }
    
}
