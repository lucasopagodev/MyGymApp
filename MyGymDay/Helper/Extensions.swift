//
//  Extensions.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 29/01/25.
//

import SwiftUI

// Extensão para ocultar o teclado ao tocar fora
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
