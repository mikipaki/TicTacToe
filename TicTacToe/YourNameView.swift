//
//  YourNameView.swift
//  TicTacToe
//
//  Created by Milos Ilic on 6.3.23..
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    var body: some View {
        VStack {
            Text("This is the name that will be associated with this device.")
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            Button("Set") {
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            Image("tictactoe")
                .resizable()
                .scaledToFit()
            Spacer()
        }
        .padding()
        .navigationTitle("Tic tac toe")
        .inNavigationStack()
    }
}

struct YourNameView_Previews: PreviewProvider {
    static var previews: some View {
        YourNameView()
    }
}
