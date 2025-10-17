//
//  DoubleExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import Foundation

extension Double {
    
    var asKcal: String { Self.format(self, decimals: 0) }
    var asGrams: String { Self.format(self, decimals: self < 1 ? 2 : 1, suffix: " г") }

    static func format(_ value: Double, decimals: Int, suffix: String? = nil) -> String {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: "ru_RU")
        nf.minimumFractionDigits = decimals
        nf.maximumFractionDigits = decimals
        let s = nf.string(from: NSNumber(value: value)) ?? "\(value)"
        if let suffix { return "\(s) \(suffix)" } else { return s }
    }
}
