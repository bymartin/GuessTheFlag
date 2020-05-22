//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Barry Martin on 5/11/20.
//  Copyright © 2020 Barry Martin. All rights reserved.
//

import SwiftUI

// MARK: Day 24 Challenge # 3
// Challenge: create a FlagImage() view that renders one flag
// using teh same set of modifiers
struct FlagImage: View {
    let image: String
    
    var body: some View {
            Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var flagRotateAngle = [0.0, 0.0, 0.0]
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    
    @State private var animationAmount: [CGFloat] = [1, 1, 1]
    

    
    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                        }
                    }) {
                        FlagImage(image: self.countries[number])
                            
                    }
                    .rotation3DEffect(.degrees(self.flagRotateAngle[number]), axis: (x:1, y:0, z:0))
                    .opacity(self.flagOpacity[number])
                    .scaleEffect(self.animationAmount[number])
                }
                Spacer()
                Text("Score: \(score)")
                    .font(.largeTitle)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score = score + 1
            flagRotateAngle[number] = 360.0
            
            // make the other 2 flags fade to 25% opacity
            for (index, _) in flagOpacity.enumerated() {
                if index == number {
                    flagOpacity[index] = 1.0
                } else {
                    flagOpacity[index] = 0.25
                }
            }

        } else {
            scoreTitle = "Wrong. That's the flag of \(countries[number])."
            score = 0
            animationAmount[number] = 1.6
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagRotateAngle = [0.0, 0.0, 0.0]
        flagOpacity = [1.0, 1.0, 1.0]
        animationAmount = [1, 1, 1]
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
