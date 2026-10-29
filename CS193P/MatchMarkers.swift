//
//  MatchMarkers.swift
//  CS193P
//
//  Created by MacBook on 21/10/2026.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}
// if дає змогу показувати потрібну кількість маркерів — від 3 до 6.
struct MatchMarkers: View {
    var matches: [Match]
    var body: some View {
        HStack(spacing: -20){
            VStack {
                if matches.count > 0 {
                    matchMarker(peg: 0)
                }
                if matches.count > 1 {
                    matchMarker(peg: 1)
                }
            }
            .frame(width: 40, height: 40)
            VStack {
                if matches.count > 2 {
                    matchMarker(peg: 2)
                }
                if matches.count > 3 {
                    matchMarker(peg: 3)
                }
            }
            .frame(width: 40, height: 40)
            VStack {
                if matches.count > 4 {
                    matchMarker(peg: 4)
                }
                if matches.count > 5 {
                    matchMarker(peg: 5)
                }
            }
            .frame(width: 40, height: 40)
        }
    }
    //6 Color.primary підлаштовується під світлу й темну теми.
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count {$0 == .exact}
        let foundCount = matches.count {$0 != .nomatch}
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2).aspectRatio(1, contentMode: .fit)
    }
}
// 1. MatchMarkersPreview робимо для того щоб створити зручну демонстрацію з тестовими фішкамиНовий view компонент. Розташовує тестові фішки та маркери поруч.
//ForEach створює чотири фішки і як MatchMarkers отримує масив matches
//ForEach(0..<matches.count) створює стільки великих фішок, скільки елементів у matches.
struct MatchMarkersPreview: View {
    var matches: [Match]
    var body: some View {
        HStack(spacing: 5) {
            HStack(spacing: 5) {
                ForEach(0..<matches.count, id: \.self) { _ in
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 30, height: 30)
                }
            }
            MatchMarkers(matches: matches)
        }
//        .frame(height: 42)
    }
}
// Перевіряємо масиви з 3, 4, 5 і 6 елементів #preview
#Preview {
    
    VStack(alignment: .leading, spacing: 12) {
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch])
        MatchMarkersPreview(matches: [.exact, .nomatch, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .exact, .inexact])
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .exact, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .nomatch, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .nomatch, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .exact, .inexact, .exact])
        MatchMarkersPreview(matches: [.inexact, .nomatch, .exact, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .inexact, .exact, .nomatch])
    }
    .padding()
}

/*
 
 /* Enhance the #Preview of MatchMarkers to also show some “dummy pegs” next to the
 MatchMarkers so that the Preview Canvas is showing the MatchMarkers in more of it’s
 “native environment.” See the Screenshot below to get the general idea.
  
  hints
  
  A kind of ugly solution to Required Task 2 would be adding a lot of (repeated) lines
  of code to your #Preview, but consider instead creating your own “helicopter View”
  (maybe called something like MatchMarkersPreview?) which is used only by your
  #Preview and which shows the dummy pegs and the MatchMarkers together. Then
  your #Preview can consist only of uses of that “helicopter View” (inside a VStack or
  something). In other words “decompose” your #Preview. There’s no rule that says
  you can’t use whatever Views you want in your #Preview, even ones you create
  specifically for the purpose of making your #Preview better/cleaner.
  
  
  
  */

 
 3. Enhance the MatchMarkers View to work properly when given an Array of anywhere
 between 3 and 6 Match values (we only ever pass 4 during lecture).
 4. Update the #Preview of MatchMarkers you built above to exercise your code by trying
 out a bunch of different configurations of Array<Match> including Arrays of 3, 4, 5
 and 6 Match values and with a variety of Match (i.e. .exact, .inexact, .nomatch)
 values.
 5. To properly preview what the MatchMarkers will look like when there is something
 other than 4 things in the Array<Match>, the #Preview will need to show 3, 4, 5 or 6
 “dummy” pegs too (since each peg might be a Match, you’d never have, for example, 5
 match markers unless there were 5 pegs capable of being matched).
 6. Make sure your #Preview for MatchMarkers does something sensible in both Dark
 Mode and Light Mode.

 Hints

 1. We are only prototyping the components of our UI (specifically, MatchMarkers) this
 week. We’ll implement our actual CodeBreaker game play next week.
 2. A kind of ugly solution to Required Task 2 would be adding a lot of (repeated) lines
 of code to your #Preview, but consider instead creating your own “helicopter View”
 (maybe called something like MatchMarkersPreview?) which is used only by your
 #Preview and which shows the dummy pegs and the MatchMarkers together. Then
 your #Preview can consist only of uses of that “helicopter View” (inside a VStack or
 something). In other words “decompose” your #Preview. There’s no rule that says
 you can’t use whatever Views you want in your #Preview, even ones you create
 specifically for the purpose of making your #Preview better/cleaner.
 3. Remember that you are allowed to use an if statement inside a @ViewBuilder (e.g. in
 the var body of MatchMarkers). This is a Hint, not a Required Task.
 4. Required Task 3 can be accomplished in just a few lines of code. Very few.
 5. Required Task 5 should require only a couple of lines of code to be changed.
 Literally.
 6. If you do a good job on Required Tasks 2 and 5, Required Task 4 might take only 1
 line of code per configuration you want to preview.
 7. You’ll likely find that Required Task 6 “just works” without any work at all on your
 part. That’s one of the features of SwiftUI (i.e. that it adapts to the user’s chosen
 environment with little work on your part—but we still always want to be double-
 checking this as we develop our application).
 8. Assignment 2 will build directly on the work you are doing in this assignment. In
 other words, you will not be able to accomplish the Required Tasks in Assignment 2 if
 you have not successfully completed Assignment 1.
 9. For fun, try to get your code to run on a physical device (i.e. on an iPhone).
*/


