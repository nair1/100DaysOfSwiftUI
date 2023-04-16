//
//  ContentView.swift
//  RPS
//
//  Created by Sachin Nair on 4/16/23.
//

import SwiftUI

struct ShadedStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func shadedStackStyle() -> some View {
        modifier(ShadedStack())
    }
}

struct ContentView: View {
    let gameOptions = ["🪨", "📄", "✂️"]
    let playerOptions = ["WIN", "LOSE"]
    
    @State private var CPUselection = Int.random(in: 0...2)
    @State private var playerObjective = Int.random(in: 0...1)
    @State private var totalCorrect = 0
    @State private var totalGuesses = 0
    
    var isGameComplete: Bool { return totalGuesses == 10 }
    
    var totalCorrectPercentage: Double {
        if totalGuesses == 0 {
            return 0.0
        }
        
        return 100 * Double(totalCorrect) / Double(totalGuesses)
    }
    
    var totalCorrectPercentageStr: String {
        return String(format: "%.2f", totalCorrectPercentage) + "%"
    }
    
    var winningOption: Int {
        switch CPUselection {
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 0
        }
    }
    
    var losingOption: Int {
        switch CPUselection {
            case 0:
                return 2
            case 1:
                return 0
            default:
                return 1
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Rock Paper Scissors")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Group {
                    VStack(spacing: 15) {
                        Text("CPU Selects:")
                        
                        Text(gameOptions[CPUselection])
                            .font(.system(size: 50))
                    }
                    .shadedStackStyle()
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Your Objective:")
                            Text(playerOptions[playerObjective])
                                .font(.title).bold()
                        }
                    }
                    .shadedStackStyle()
                    
                    HStack(spacing: 55) {
                        ForEach(0..<3) { number in
                            Button {
                                optionTapped(number)
                            } label: {
                                Text(gameOptions[number])
                                    .font(.title)
                            }
                            .padding(10)
                            .background(Color(red: 0.1, green: 0.2, blue: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .shadedStackStyle()
                }
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalCorrect)/\(totalGuesses)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text(totalCorrectPercentageStr)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .alert("Game Complete 🔥", isPresented: .constant(isGameComplete)) {
            Button("Restart", action: resetEntireGame)
        } message: {
            Text("You scored \(totalCorrectPercentageStr)!")
        }
    }
    
    func optionTapped(_ number: Int) {
        var gameResult: String
        
        if number == winningOption {
            gameResult = "WIN"
        } else if number == losingOption {
            gameResult = "LOSE"
        } else {
            gameResult = "TIE"
        }
        
        if playerOptions[playerObjective] == gameResult {
            totalCorrect += 1
        }
        
        totalGuesses += 1
        resetIndividualGame()
    }
    
    func resetIndividualGame() {
        CPUselection = Int.random(in: 0...2)
        playerObjective = Int.random(in: 0...1)
    }
    
    func resetEntireGame() {
        totalGuesses = 0
        totalCorrect = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
