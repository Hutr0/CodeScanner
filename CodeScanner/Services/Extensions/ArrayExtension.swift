//
//  ArrayExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import Foundation

extension Array where Element: Hashable {
    
    func uniqued() -> [Element] {
        var s = Set<Element>()
        return filter { s.insert($0).inserted }
    }
    
}
