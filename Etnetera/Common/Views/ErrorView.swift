//
//  ErrorView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let action: (() -> Void)

    var body: some View {
        VStack(spacing: 40) {
            Text(error.localizedDescription)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            CustomButton(title: "Retry", action: action)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ErrorView(error: NSError(domain: "50", code: 0), action: {})
}
