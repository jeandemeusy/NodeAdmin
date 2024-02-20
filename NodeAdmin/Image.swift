//
//  Image.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import Foundation
import SwiftUI

extension Image {
    init(safeName: String) {
        if UIImage(systemName: safeName) != nil {
            self.init(systemName: safeName)
        } else {
            self.init(safeName)
        }
    }
}
