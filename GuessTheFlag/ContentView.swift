//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by David Ferreira on 27/10/24.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}

extension View {
    func contentCard() -> some View {
        modifier(Card())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria","Poland", "Spain", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showEndOfGame = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var counter = 0
    
    var body: some View {
        ZStack{
            RadialGradient(stops:[
                .init(color: .orange, location: 0.3),
                .init(color: .teal, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Gess the flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 30){
                    VStack{
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.heavy))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                                
                        }
                    }
                    
                }
                .contentCard()
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .foregroundStyle(.white)
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
        .alert(scoreTitle ,isPresented: $showEndOfGame) {
            Button("Reset",role: .cancel ,action: resetGame)
        } message: {
            Text("Your score was \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        let maxNumberOfQuestions = 3
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        counter += 1
        
        if (counter != maxNumberOfQuestions) {
            showingScore = true
        } else {
            scoreTitle = "End of game!"
            showEndOfGame = true
        }
        
        
    }
    
    func resetGame() {
        counter = 0
        score = 0
        askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
}

#Preview {
    ContentView()
}
