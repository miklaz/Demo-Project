//
//  BackendError.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 24.10.2021.
//

import Foundation

enum BackendError: Error {
    case cityNotFound(message: String)
}

extension BackendError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .cityNotFound(message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
