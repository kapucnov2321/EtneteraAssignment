//
//  Decodable+Extension.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import Foundation

enum EncodingError: LocalizedError {
    case cantEncodeString
    
    var errorDescription: String? {
        switch self {
        case .cantEncodeString:
            "Failed to create String from data"
        }
    }
}
extension Encodable {

    func encode() throws -> String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(self)
        guard let encodedString = String(data: data, encoding: .utf8) else {
            throw EncodingError.cantEncodeString
        }
        
        return encodedString
    }
}
