//
//  InputView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 19/10/2024.
//

import SwiftUI

struct InputView: View {
    @Binding var inputValue: String
    let title: String
    let placeholder: String
    let keyboardType: UIKeyboardType

    init(inputValue: Binding<String>, title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self._inputValue = inputValue
        self.title = title
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
            TextField(
                "",
                text: $inputValue,
                prompt: Text(placeholder)
                    .foregroundStyle(.black.opacity(0.5))
            )
            .foregroundStyle(.black)
            .padding(5)
            .background(.white)
            .clipShape(.buttonBorder)
            .keyboardType(keyboardType)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.buttonBorder)
    }
}

#Preview {
    InputView(
        inputValue: .constant("4"),
        title: "Preview",
        placeholder: "Preview placeholder"
    )
}
