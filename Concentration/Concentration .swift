//
//  Concentration .swift
//  Concentration
//
//  Created by Macbook on 01.11.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private(set) var flipsCount = 0
    private(set) var score = 0
    private(set) var cycleCount = 0
    
    private var bonusForMath = 2
    private var bonusForMiss = -1
    
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipsCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    cycleCount += 1
                    score += bonusForMath
                } else if cards[matchIndex].isKnown, cards[index].isKnown {
                    score += bonusForMiss
                }
                cards[index].isFaceUp = true
              
                
            } else {
            indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isKnown = true
            print(cycleCount)
            
        }
    }
    
    func reloadCard(at index:Int)  {
        cards[index].isFaceUp = false
        cards[index].isMatched = false
        cards[index].isKnown = false
        flipsCount = 0
    }
    
    
    init(numberOfPairs: Int){
        for _ in 1...numberOfPairs {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
