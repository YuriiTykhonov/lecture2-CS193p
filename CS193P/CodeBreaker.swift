//
//  CodeBreaker.swift
//  CodeBreakerApp
//
//  Created by MacBook on 09/11/2026.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
var masterCode: Code
var guess: Code
var attempts: [Code] = []
let pegChoices: [Peg]
let numberOfPegs: Int
//   Додали нову властивість:  numberOfPegs Тепер сама гра пам'ятає, скільки фішок у ній повинно бути.
    init(
        pegChoices: [Peg] = [.red, .green, .blue, .yellow],
        numberOfPegs: Int = 4
    ) {
        self.pegChoices = pegChoices
        self.numberOfPegs = numberOfPegs

        self.masterCode = Code(
            kind: .master,
            numberOfPegs: numberOfPegs
        )

        self.guess = Code(
            kind: .guess,
            numberOfPegs: numberOfPegs
        )

        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }

//struct CodeBreaker {
//    var masterCode: Code = Code(kind: .master)
//    var guess: Code = Code(kind: .guess)
//    var attempts: [Code] = []
//    let pegChoices: [Peg]
//    
//    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow]) {
//        self.pegChoices = pegChoices
//        masterCode.randomize(from: pegChoices)
//        print(masterCode)
//    }
    
//    mutating func attemptGuess() {
//        var attempt = guess
//        attempt.kind = .attempt(guess.match(against: masterCode))
//        attempts.append(attempt)
//    }
    
    
    mutating func attemptGuess() {
        guard !guess.pegs.allSatisfy({$0 == Code.missing}) else {
            return
        }
        guard !attempts.contains(where: {$0.pegs == guess.pegs}) else {
            return
        }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
/*   Тут ми використовуємо дві перевірки guard.
    Перша перевірка:
    1.allSatisfy перевіряє, чи всі фішки відповідають умові.
    2.$0 == Code.missing перевіряє, чи фішка порожня
    3.! означає заперечення.
    return припиняє виконання функції

    Тобто якщо всі фішки порожні,нічого не відбувається.
    Друга перевірка:
    Тут перевіряємо, чи існує така комбінація серед попередніх спроб.
    Якщо користувач уже вводив цю комбінацію — нова спроба не додається.*/
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

//struct Code {
//    var kind: Kind
//    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
//    
//    static let missing: Peg = .clear

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, numberOfPegs: Int = 4) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: numberOfPegs)
    }
//    init — це спеціальна функція, яка виконується, коли ми створюємо новий екземпляр структури.
//   Тут створюємо масив із тією кількістю фішок, яку ми передали.
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unkown
    }
    
//    mutating func randomize(from pegChoice: [Peg]) {
//        for index in pegChoice.indices {
//            pegs[index] = pegChoice.randomElement() ?? Code.missing
//        }
//    }
    
    mutating func randomize(from pegChoice: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoice.randomElement() ?? Code.missing
        }
    }
    
//    pegChoice — це масив доступних кольорів, а не масив фішок.Нам потрібно перебирати саме фішки!
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return[]
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}


