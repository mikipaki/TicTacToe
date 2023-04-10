//
//  GameView.swift
//  TicTacToe
//
//  Created by Milos Ilic on 26.2.23..
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        VStack {
            
            
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy { $0 == false} {
                Text("Select a player to start")
                    .padding(.top, 20)
            }
            HStack {
                Button(game.player1.name) {
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(game.player1.isCurrent ? Color(red: 0/255, green: 204/255, blue: 136/255) : Color.gray)
                )
                .foregroundColor(.white)
                Button(game.player2.name) {
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        Task {
                            await game.deviceMove()
                        }
                    }
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player2.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(game.player2.isCurrent ? Color(red: 0/255, green: 204/255, blue: 136/255) : Color.gray)
                )
                .foregroundColor(.white)
            }
            .disabled(game.gameStarted)
            
            
            VStack {
                
                HStack {
                    ForEach(0...2, id: \.self) { index in
                        
                        SquareView(index: index)
                    }
                }
                
                HStack {
                    ForEach(3...5, id: \.self) { index in
                        
                        SquareView(index: index)
                    }
                }
                
                HStack {
                    ForEach(6...8, id: \.self) { index in
                        
                        SquareView(index: index)
                    }
                }
                
            }
            .overlay {
                if game.isThinking {
                    
                    VStack {
                        Text(" Thinking... ")
                            .foregroundColor(Color(.systemBackground))
                            .background(RoundedRectangle(cornerRadius: 4).fill(Color(red: 0/255, green: 204/255, blue: 136/255)))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled ||
                      game.gameType == .peer &&
                      connectionManager.myPeerId.displayName != game.currentPlayer.name)
            .padding(.top, 30)
            
            VStack {
                if game.gameOver {
                    Text("Game Over!")
                    if game.possibleMoves.isEmpty {
                        Text("There is no winner this time.")
                    }
                    else {
                        Text("\(game.currentPlayer.name) wins!" )
                    }
                    Button("New Game") {
                        game.reset()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.title)
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Game") {
                    dismiss()
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .end, playerName: nil, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Tic Tac Toe")
        .onAppear {
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Milos"))
        
    }
}

