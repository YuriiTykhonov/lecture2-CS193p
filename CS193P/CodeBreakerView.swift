//
//  CodeBreakerView.swift
//  CS193P
//
//  Created by MacBook on 21/10/2026.
//

import SwiftUI

//struct CodeBreakerView: View {
//    @State var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black])
    
//    var body: some View {
//        VStack {
//            view(for: game.masterCode)
//            ScrollView {
//                view(for: game.guess)
//                ForEach(game.attempts.indices.reversed(), id: \.self) {index in
//                    view(for: game.attempts[index])
//                }
//            }
//        }
//        .padding()
//    }
struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black], numberOfPegs: 6)
// Тут ми просто вказуємо, що зараз тестуємо гру з шістьма фішками.

    var body: some View {
        VStack {
            Button("Restart Game") {
                withAnimation {
                    game = CodeBreaker(pegChoices: game.pegChoices,
                                       numberOfPegs: Int.random(in: 3...6))
                }
//Тепер Restart Game зберігатиме поточну кількість фішок.
//	У цьому завданні потрібно змінити Restart Game так, щоб нова гра випадково отримувала кількість фішок від 3 до 6. Тож ми реалізуємо це через Int.random
            }
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) {index in
                    view(for: game.attempts[index])
                }
            }
        }
        .padding()
    }
/* Створюємо кнопку restart game, з with animation виконуємо заміну стану з анімацією,
 game = CodeBreaker(pegChoices: game.pegChoices) - створюємо абсолютно нову гру, передаємо цій частині ті самі доступні кольори, які були у попередній грі, з game = зберегаємо  .brown, .yellow, .orange, .black.
 Тобто: коли користувач натискає Restart Game, Створюється новий CodeBreaker
 Виконується init та генерується новий masterCode*/
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                }
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
 
