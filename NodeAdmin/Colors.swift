//
//  Colors.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation
import SwiftUI

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
}
    
extension ShapeStyle where Self == Color {
    static var brightBlueHOPR: Color { Color(hex: 0x0000b4) }
    static var skyBlueHOPR: Color { Color(hex: 0xb4f0ff) }
    static var steelBlueHOPR: Color { Color(hex: 0x3c64a5) }
    static var darkBlueHOPR: Color { Color(hex: 0x000050) }
    static var yellowHOPR: Color { Color(hex: 0xffffa0) }
}
