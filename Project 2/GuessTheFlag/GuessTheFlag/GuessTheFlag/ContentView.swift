//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sachin Nair on 4/15/23.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

struct LargeBlueTitle: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        Text(text)
            .foregroundColor(.blue)
            .font(.largeTitle.bold())
    }
}

extension View {
    func largeBlueTitle(with text: String) -> some View {
        modifier(LargeBlueTitle(text: text))
    }
}

struct ContentView: View {
    @State private var totalCorrect = 0
    @State private var totalGuesses = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var wrongAnswerAlertVisible = false
    @State private var wrongAnswerCountry = ""
    
    var totalCorrectPercentage: Double {
        if (totalGuesses == 0) {
            return 0.0
        }
        
        return 100 * Double(totalCorrect) / Double(totalGuesses)
    }
    
    var totalCorrectPercentageStr: String {
        return String(format: "%.2f", totalCorrectPercentage) + "%"
    }
    
    var isGameComplete: Bool { return totalGuesses == 10 }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
//            LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                
                Spacer()
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
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
        .alert("Wrong 👎", isPresented: $wrongAnswerAlertVisible) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("You clicked \(wrongAnswerCountry)!")
        }
        .alert("Game Complete 🔥", isPresented: .constant(isGameComplete)) {
            Button("Restart", action: resetGame)
        } message: {
            Text("You scored \(totalCorrectPercentageStr)!")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            totalCorrect += 1
            askQuestion()
        } else {
            wrongAnswerAlertVisible = true
            wrongAnswerCountry = countries[number]
        }
        
        totalGuesses += 1
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        totalCorrect = 0
        totalGuesses = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
