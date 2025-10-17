//
//  DateExtension.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

extension Date {
    
    func formattedRelative() -> String {
        let cal = Calendar.current
        if cal.isDateInToday(self) {
            return "сегодня, " + formatted(date: .omitted, time: .shortened)
        } else if cal.isDateInYesterday(self) {
            return "вчера, " + formatted(date: .omitted, time: .shortened)
        } else {
            return formatted(date: .abbreviated, time: .shortened)
        }
    }
    
}
