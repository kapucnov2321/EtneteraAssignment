//
//  View+Extension.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
