//
//  Collection+Extension.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
