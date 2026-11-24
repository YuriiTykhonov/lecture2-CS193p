//
//  CodeBreakerView.swift
//  CS193P
//
//  Created by MacBook on 21/10/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: ["😀", "🐱", "🚗", "⚽"],numberOfPegs: 4)
    // Тут ми просто вказуємо, що зараз тестуємо гру з шістьма фішками.
    let emojiChoices = [
        ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻"],
        ["🍎", "🍕", "🍔", "🍩", "🍓", "🍉"],
        ["🚗", "🚕", "🚌", "🚲", "✈️", "🚀"]
    ]
    /* emojiChoices — масив наборів Emoji.
     Кожен внутрішній масив — окрема тема.
     У кожному наборі по 6 Emoji, тому він підходить для гри з 3–6 фішками.*/
    
    let colorChoices = ["red", "green", "blue", "yellow"]
    
    var body: some View {
        VStack {
            Button("Restart Game") {
                withAnimation {
                    let isEmojiGame = Bool.random()
                    let randomPegChoices = isEmojiGame ? emojiChoices.randomElement() ?? emojiChoices[0] : colorChoices
                    
                    game  = CodeBreaker(pegChoices: randomPegChoices, numberOfPegs: CodeBreaker.randomNumberOfPegs())
                    //Тепер Restart Game зберігатиме поточну кількість фішок.
                    //	У цьому завданні потрібно змінити Restart Game так, щоб нова гра випадково отримувала кількість фішок від 3 до 6. Тож ми реалізуємо це через Int.random
                   /* 1. Випадково вибираємо набір:emojiChoices — наш масив із трьома наборами.
                    randomElement() — вибирає один випадковий набір.?? emojiChoices[0] — запасний варіант, якщо випадковий вибір поверне  il.
                    2. Створюємо нову гру randomEmojiSet — обраний набір Emoji.Int.random(in: 3...6) — випадкову кількість фішок.
                    3. Перевіряємо Запусти гру та натисни Restart Game кілька разів.
                    Має змінюватися:Hабір Emoji,кількість фішок від 3 до 6.*/
                    /*1. Випадково вибираємо набір:
                     
                     emojiChoices — наш масив із трьома наборами.
                     randomElement() — вибирає один випадковий набір.
                     ?? emojiChoices[0] — запасний варіант, якщо випадковий вибір поверне nil.
                     2. Створюємо нову гру
                     randomEmojiSet — обраний набір Emoji.
                     Int.random(in: 3...6) — випадкову кількість фішок.
                     3. Перевіряємо
                     Запусти гру та натисни Restart Game кілька разів.
                     Має змінюватися:
                     набір Emoji, кількість фішок від 3 до 6.*/
                }
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
                    .fill(color(for: code.pegs[index]) ?? .clear)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        } else if color(for: code.pegs[index]) == nil {
                            Text(code.pegs[index])
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                                .foregroundStyle(.primary)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
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
    /* Цю функцію ми замінимо його так, щоб: якщо це назва кольору — показувати кольорову фішку,
     якщо це Emoji — показувати текст із Emoji,
     якщо фішка порожня — показувати порожню фішку з сірою рамкою.
     Тут робимо 3 перевірки:
     Якщо рядок порожній — малюємо сіру рамку.
     Якщо функція не знайшла відповідний колір, значить це не одна з наших кольорових фішок.
     Тут ?? означає: якщо функція повернула nil, використай .clear.
     Тобто кольорові фішки отримають відповідний колір, а Emoji матимуть прозорий фон і відображатимуться як текст поверх фішки.*/
    
    func color(for peg: Peg) -> Color? {
        switch peg {
        case "red" : return.red
        case "green": return.green
        case "blue": return.blue
        case "yellow": return.yellow
        case "brown": return.brown
        case "orange" : return.orange
        case "black" : return.black
        default : return nil
        }
    }
/*нам потрібно створити невелику функцію, яка перетворюватиме назву кольору на справжній Color.
for peg: Peg — передаємо назву фішки.
Color? — функція може повернути колір або nil.switch перевіряє переданий рядок, а як що повернути emoji то функція поверне nil*/
}

#Preview {
    CodeBreakerView()
}

