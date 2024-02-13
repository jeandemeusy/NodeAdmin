//
//  Modifiers.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import SwiftUI



extension View {
    var center: some View {
        modifier(CenterView())
    }
    
    var lightBluePanel: some View {
        modifier(LightBluePanelView())
    }
}

struct CenterView: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

struct LightBluePanelView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.skyBlueHOPR)
            .clipShape(.rect(cornerRadius: CGFloat(10)))
            .foregroundStyle(Color(white: 0.2))
            .monospaced()
    }
}

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}
