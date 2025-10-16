//
//  ScannerError.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Foundation

enum ScannerError: LocalizedError {
    
    case cameraUnavailable
    case inputInitFailed
    case torchUnsupported
    case configurationFailed
    
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:    return "Камера недоступна."
        case .inputInitFailed:      return "Не удалось инициализировать вход камеры."
        case .torchUnsupported:     return "Фонарик не поддерживается."
        case .configurationFailed:  return "Не удалось сконфигурировать сессию."
        }
    }
}
