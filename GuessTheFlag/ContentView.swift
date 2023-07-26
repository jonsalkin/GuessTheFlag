//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jon Salkin on 7/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score: Int = 0
    @State private var wrongFlag = ""
    @State private var questionCount: Int = 1
    
    @State private var showingEndGameAlert = false
    @State private var endGameAlertTitle = ""
    @State private var showingGameRestartAlert = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.75, green: 0.15, blue: 0.26), location: 0.3),],
                           center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
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
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(endGameAlertTitle, isPresented: $showingEndGameAlert) {
            Button("Play Again?", action: startOver)
//            Button("End", action: endGame)
        } message: {
            Text("Game Over")
                .bold()
                .font(.system(size: 15))
        }
//        .alert("Game Over", isPresented: $showingGameRestartAlert) {
//            Button("Play Again", action: playAgain)
//            Button("End", action: endGame)
//        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            wrongFlag = countries[number]
            scoreTitle = "Wrong!\n That's the flag of \(wrongFlag)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if questionCount < 8 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            showingScore = true
            questionCount += 1
        } else {
            endGameAlertTitle = "Your score is \(score)."
            showingEndGameAlert = true
        }
    }
    
    func startOver() {
        score = 0
        questionCount = 1
        showingEndGameAlert = false
    }
    
    func playAgain() {
        startOver()
    }
    
    func endGame() {
        showingEndGameAlert = false
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
