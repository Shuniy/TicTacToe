//
//  ContentView.swift
//  TicTacToe
//
//  Created by Shubham Kumar on 25/01/22.
//

import SwiftUI

struct ContentView: View {
    //MARK: PROPERTIES
    var cellSize: CGFloat {
        return (UIScreen.main.bounds.width - 60) / 3
    }
    
    @State var moves:[String] = Array(repeating: "", count: 9)
    @State var currentUser = false
    @State var message = ""
    @State var gameOver = false
    
    //Check the moves
    func checkMoves(player:String) -> Bool {
        //Horizontal Check
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player {
                return true
            }
        }
        
        //Vertical Check
        for i in stride(from: 0, to: 3, by: 1) {
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player {
                return true
            }
        }
        
        //Diagonal Check
        if moves[0] == player && moves[4] == player && moves[8] == player {
            return true
        }
        
        if moves[2] == player && moves[4] == player && moves[6] == player {
            return true
        }
        
        return false
    }
    
    // Decide winner
    func decideWinner() {
        if checkMoves(player: "X") {
            message = "player X won the game !"
            self.gameOver.toggle()
        }
        else if checkMoves(player: "O") {
            message = "player O won the game !"
            self.gameOver.toggle()
        } else {
            let status = moves.contains {
                (value) -> Bool in
                return value == ""
            }
            
            if !status {
                message = "Game is Tie"
                gameOver.toggle()
            }
        }
    }
    
    //MARK: BODY
    var body: some View {
        
        NavigationView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing:15), count: 3), spacing: 15, content: {
                ForEach(0..<9){
                    index in
                    
                    ZStack {
                        Color.blue
                        Color.white
                            .opacity(moves[index] != "" ? 1 : 0)
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(moves[index] == "" ? .white : .black)
                    }//:ZStack
                    .cornerRadius(15)
                    .rotation3DEffect(.init(degrees: moves[index] != "" ? 180 : 0), axis: (x:0.0, y:1.0, z:0.0), anchor: .center, anchorZ: 0.0, perspective: 1.0)//:rotation3DEffect
                    .frame(width: cellSize, height: cellSize)
                    .onTapGesture {
                        withAnimation(Animation.easeIn(duration: 0.20)) {
                            moves[index] = currentUser ? "X" : "O"
                            self.currentUser.toggle()
                        }//:withAnimation
                    }//:onTapGesture
                }//:ForEach
            })
            //:LazyVGrid
                .padding()
                .preferredColorScheme(.dark)
                .navigationTitle("Tic Tac Toe")
                .onChange(of: moves, perform: {
                    value in decideWinner()
                })//:onChange
                .alert(isPresented: $gameOver, content: {
                    Alert(title: Text("Winner!"), message:Text(message), dismissButton:.destructive(Text("Play Again!"), action: {
                        withAnimation(Animation.easeIn(duration: 0.45)) {
                            moves.removeAll()
                            moves = Array(repeating:"", count: 9)
                            currentUser = false
                        }//:withAnimation
                    }))//:Alert
                })//:alert
        }//:NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }//:Body
}

//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
