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
            Color.sheetBackgroundDM.ignoresSafeArea(.all)
            VStack {
                Text(title)
                    .font(.headline)
                
                Divider()

                content
                
                if dismissAction != nil || confirmAction != nil || footer != nil{
                    Spacer()
                }
                
                if dismissAction != nil || confirmAction != nil {
                    HStack {
                        if let action = dismissAction{
                            Button {
                                action()
                            } label: {
                                Text("Cancel")
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
                }
                if let footer = footer {
                    Text(footer)
                        .multilineTextAlignment(.center)
                        .font(.custom("note", size: 10, relativeTo: .footnote))
                }
            }
            .foregroundStyle(.darkForegroundDM)
            .padding([.top, .horizontal])
            .monospaced()
        }
    }
}
