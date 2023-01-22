//
//  Alerts.swift
//  TicTacSwiftUI
//
//  Created by user226229 on 20.01.2023.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}


struct AlertContext {
    static let playerWin = AlertItem(title: Text("You Win"), message: Text("Continue?"), buttonTitle: Text("Start Again"))
    
    static let pvpWin = AlertItem(title: Text("Other player is beaten"), message: Text("Continue?"), buttonTitle: Text("Start Again"))
    
    static let opponentWin = AlertItem(title: Text("You Lost"), message: Text("Continue?"), buttonTitle: Text("Start Again"))
    
    static let draw = AlertItem(title: Text("Draw"), message: Text("Continue?"), buttonTitle: Text("Start Again"))
    
}
