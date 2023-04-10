//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Milos Ilic on 26.2.23..
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            } else {
                StartView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
