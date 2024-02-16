//
//  Modifiers.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import SwiftUI



extension View {
    var hcenter: some View {
        modifier(HCenterView())
    }
    
    var vcenter: some View {
        modifier(VCenterView())
    }
    
    var lightBluePanel: some View {
        modifier(LightBluePanelView())
    }
}

extension ButtonStyle where Self == HOPRButtonStyle {
    static var hopr: Self {
        return .init()
    }
}

extension ButtonStyle where Self == DismissButtonStyle {
    static var dismiss: Self {
        return .init()
    }
}


struct HCenterView: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}


struct VCenterView: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
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
            .foregroundStyle(.grey)
            .monospaced()
    }
}

struct HOPRButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration)
    }
    
    struct Button: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.footnote.weight(.semibold))
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxHeight: 50)
                .monospaced()
                .foregroundStyle(isEnabled ? .white:.gray)
                .background(.gradientHOPR.opacity(isEnabled ? 1:0))
                .clipShape(
                    .capsule(style: .continuous)
                )
                .overlay {
                    Capsule()
                        .stroke(.gray, lineWidth: 1)
                        .opacity(isEnabled ? 0:1)
                }
        }
    }
}

struct DismissButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration)
    }
    
    struct Button: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.footnote.weight(.semibold))
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxHeight: 50)
                .monospaced()
                .foregroundStyle(.red)
                .clipShape(
                    .capsule(style: .continuous)
                )
                .overlay {
                    Capsule()
                        .stroke(.red, lineWidth: 1)
                }
        }
    }
}

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}
