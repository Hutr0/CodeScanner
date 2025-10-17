//
//  OFFError.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

enum OFFError: LocalizedError {
    case badURL
    case http(_ statusCode: Int)
    case notFound(_ code: String)
    case malformedResponse
}
