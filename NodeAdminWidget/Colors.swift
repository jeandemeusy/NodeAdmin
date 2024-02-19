//
//  Colors.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/18/24.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(.sRGB, red: Double(red)/255.0, green: Double(green)/255.0, blue: Double(blue)/255.0)
    }
    
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    init(light: Color, dark: Color) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return light

            case .dark:
                return dark

            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
                return light
            }
        }))
    }
}
    
extension ShapeStyle where Self == Color {
    static var _darkBlueHOPR: Color { Color(hex: 0x000050) }
    static var _brightBlueHOPR: Color { Color(hex: 0x0000b4) }
    static var _skyBlueHOPR: Color { Color(hex: 0xb4f0ff) }
    static var _steelBlueHOPR: Color { Color(hex: 0x3c64a5) }
    static var _yellowHOPR: Color { Color(hex: 0xffffa0) }
    static var _darkgray: Color { Color(white: 0.2) }
    static var _lightgray: Color { Color(white: 0.9) }

    
    static var pannelBackgroundDM: Color { Color(light: Color(white:0.95), dark: Color(white:0.1)) }
    static var darkForegroundDM: Color { Color(light: ._darkBlueHOPR, dark: Color(white: 0.95)) }
    static var darkForegroundSecondaryDM: Color { Color(light: Color(white:0.3),dark: Color(white:0.9)) }
    static var lightForegroundDM: Color { Color(light: Color(white: 0.95), dark: ._darkBlueHOPR) }
    static var lightForegroundSecondaryDM: Color { Color(light: ._darkBlueHOPR, dark: Color(white: 0.2)) }
    static var sheetBackgroundDM: Color { Color(light: ._yellowHOPR, dark: Color(white: 0.05))}
    
    static var grey: Color { Color(light: ._darkgray, dark: ._lightgray)}
    static var buttonBackground: Color { Color(light: Color(white:0.9), dark: Color(white:0.8)) }
}
