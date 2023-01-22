//
//  ContentView.swift
//  TicTacSwiftUI
//
//  Created by user226229 on 16.12.2022.
//

import SwiftUI



struct ContentView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()),]
    var isHuman : Bool
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    @State var counter = 0
    
    
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0..<9){ i in
                        ZStack{
                            RoundedRectangle(cornerRadius: 20, style: .continuous).foregroundColor(.purple)
                                .frame(width: geometry.size.width/3 - 15,height: geometry.size.width/3 - 15)
                            PlayerIndicator(systemImageName: moves[i]?.indicator ?? "")
                            
      
                        }
                        .onTapGesture {
                            if(isHuman == false){
                                player1Move(for: i)
                                
                            }else{
                                if(counter%2 == 0){
                                    player2Move(for: i, fplayer: .human)
                                }else{
                                    player2Move(for: i, fplayer: .human2)
                                }
                            }
                            if(counter>=9){counter = 0} else{counter = counter + 1}
                           
                        }
                    }
                }
                Spacer()
                            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    resetGame()
                    counter = 0
                }))
            }        }
        
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    
    func player1Move(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position){return}
        moves[position] = Move(player: .human, boardIndex: position)
        isGameboardDisabled = true
        
        //Check for win
        
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.playerWin
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let computerPosition = determineComputerPositin(in: moves)
            moves[computerPosition] = Move(player: .cpu, boardIndex: computerPosition)
            
            isGameboardDisabled = false
            
            if checkWinCondition(for: .cpu, in: moves){
                alertItem = AlertContext.opponentWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
            
        }
    }
    
    
    func player2Move(for position: Int, fplayer: Player){
        
        if isSquareOccupied(in: moves, forIndex: position){return}
        moves[position] = Move(player: fplayer, boardIndex: position)
        
        if checkWinCondition(for: fplayer, in: moves){
            alertItem = AlertContext.pvpWin
            return
        }
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
        }
        
        
    }
    
    
    func determineComputerPositin(in moves: [Move?]) -> Int {
        
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        
        
        //Check if can win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .cpu }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable{return winPositions.first!}
            }
        }
        //Check if player winning, block
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(playerPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable{return winPositions.first!}
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
            return true
        }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
        isGameboardDisabled = false
        
    }
    
}

enum Player{
    case human, human2, cpu
}
struct Move{
    let player: Player
    let boardIndex : Int
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct PlayerIndicator : View {
    var systemImageName : String
    var body: some View{
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40,height: 40)
            .foregroundColor(.teal)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isHuman: false)
    }
}
