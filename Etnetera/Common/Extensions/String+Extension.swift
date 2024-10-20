//
//  String+Extension.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import Foundation

extension String {

    func decode<T: Codable>(toClass: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: Data(self.utf8))
    }
}
