//
//  CustomButton.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: (() -> Void)

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                Text(title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .background(.blue)
                    .clipShape(.buttonBorder)
                    .shadow(radius: 2)
            }
        )
    }
}

#Preview {
    CustomButton(title: "", action: {})
}
