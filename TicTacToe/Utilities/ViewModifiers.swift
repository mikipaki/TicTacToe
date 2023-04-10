//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by Milos Ilic on 26.2.23..
//

import SwiftUI

struct NavStackContainer: ViewModifier {
    
    func body(content: Content) -> some View {
        
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
        }
        else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension View {
    
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackContainer())
    }
}
