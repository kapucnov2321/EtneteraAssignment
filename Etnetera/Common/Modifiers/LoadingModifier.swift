//
//  LoadingView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AddActivityView(navigationPath: .constant(NavigationPath()))
        .modifier(LoadingModifier(isLoading: .constant(true)))
}
