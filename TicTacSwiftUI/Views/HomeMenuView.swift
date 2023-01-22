//
//  HomeMenuView.swift
//  TicTacSwiftUI
//
//  Created by user226229 on 21.01.2023.
//

import SwiftUI



struct HomeMenuView: View {
    
    let letters = Array("X O X O")

    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing:0){
                HStack(spacing: 0){
                    ForEach(0..<letters.count, id: \.self){
                        num in
                        
                        Text(String(self.letters[num]))
                            .padding(5)
                            .font(.system(size: 50))
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                            .background(self.enabled ? Color.cyan : Color.purple)
                            .offset(self.dragAmount)
                            .animation(Animation.default.delay(Double(num)/20).repeatCount(3), value: enabled)
                        
                    }
                }
                .onAppear(){
        
                    self.dragAmount = CGSize(width: 0, height: 225)
                    self.enabled.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now()+5){
                        self.dragAmount = .zero
                        self.enabled.toggle()
                    }
                }
                Text("Tic Tac Toe")
                    .font(.largeTitle)
                    .bold()
                    .fontDesign(.rounded)
                
                    .padding()
                
                HStack{
                    
                        NavigationLink{
                            ContentView(isHuman: false)
                        } label: {
                            Text("vs CPU")
                                .foregroundColor(.teal)
                                .font(.title3)
                                .bold()
                                .fontDesign(.monospaced)
                                .padding()
                                .background(.purple.opacity(0.2))
                                .clipShape(Capsule())
                                .shadow(radius: 6, x:0,y:0)
                            
                        }
                    
                        NavigationLink{
                            ContentView(isHuman: true)
                        } label: {
                            
                            Text("vs Player")
                                .foregroundColor(.purple)
                                .font(.title3)
                                .bold()
                                .fontDesign(.monospaced)
                                .padding()
                                .background(.teal.opacity(0.2))
                                .clipShape(Capsule())
                                .shadow(radius: 6, x:0,y:0)
                                
                            
                        }
                    }
                
                
     
                        }
            
            
       
                
                    }
                }
            }
        
    

struct HomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuView()
        ContentView(isHuman: false)
    }
}
