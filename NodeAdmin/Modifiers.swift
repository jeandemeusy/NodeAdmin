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
            .background(.pannelBackgroundDM)
            .clipShape(.rect(cornerRadius: CGFloat(10)))
            .foregroundStyle(.grey)
            .monospaced()
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.darkForegroundDM.opacity(0.1), lineWidth: 1)
//            )
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
                .foregroundStyle(isEnabled ? .lightForegroundSecondaryDM:.gray)
                .background(.buttonBackground.gradient.opacity(isEnabled ? 1:0))
                .clipShape(
                    .capsule(style: .continuous)
                )
                .overlay {
                    Capsule()
                        .stroke(.gray, lineWidth: 1)
                        .opacity(isEnabled ? 0:1)
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .opacity(configuration.isPressed ? 0.6 : 1.0)
                .animation(.easeInOut, value: isPressed)
        }
        
        var isPressed: Bool {
            configuration.isPressed
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
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .opacity(configuration.isPressed ? 0.6 : 1.0)
                .animation(.easeInOut, value: isPressed)
        }
        
        var isPressed: Bool {
            configuration.isPressed
        }
    }
}

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}

extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.NodeAdmin")
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
