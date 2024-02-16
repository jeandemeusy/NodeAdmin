//
//  SheetView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/17/24.
//

import SwiftUI

struct SheetView<Content: View>: View {
    let title: String
    var footer: String?
    @ViewBuilder let content: Content
    var dismissAction: (() -> Void)? = nil
    var confirmAction: (() -> Void)? = nil
    var disabledCondition: (() -> Bool)? = nil
    
    var body: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text(title)
                    .font(.headline)
                
                Divider()

                content
                
                Spacer()
                
                HStack {
                    if let action = dismissAction{
                        Button {
                            action()
                        } label: {
                            Text("Dismiss")
                        }
                        .buttonStyle(.dismiss)
                    }
                    
                    Spacer()
                    
                    if let action = confirmAction {
                        Button {
                            action()
                        } label: {
                            Text("Submit")
                        }
                        .buttonStyle(.hopr)
                        .disabled(disabledCondition == nil ? false:disabledCondition!())
                    }
                }
                .padding(.bottom)
                if let footer = footer {
                    Text(footer)
                        .multilineTextAlignment(.center)
                        .font(.custom("note", size: 10, relativeTo: .footnote))
                }
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding([.top, .horizontal])
            .monospaced()
        }
    }
}
