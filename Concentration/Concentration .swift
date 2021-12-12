//
//  Concentration .swift
//  Concentration
//
//  Created by Macbook on 01.11.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var cards = [Card]()
    
    private(set) var flipsCount = 0
    private(set) var score = 0
    private(set) var cycleCount = 0
    
    private var bonusForMath = 2
    private var bonusForMiss = -1
    
    private var clickDate: Date?
    private var firstClickDate: Date?
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func gameTimer() -> Int {
        guard let time = firstClickDate?.sinceNow else {return 0}
        return time
    }
    
    mutating func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if flipsCount == 0 {
                firstClickDate = Date()
            }
            flipsCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    cycleCount += 1
                    score += bonusForMath * missBonusMultiplierCounter(for: clickDate)
                } else if cards[matchIndex].isKnown, cards[index].isKnown {
                    score += bonusForMiss * missBonusMultiplierCounter(for: clickDate)
                }
                cards[index].isFaceUp = true
                
                
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isKnown = true
            clickDate = Date()
        }
    }
    
    func missBonusMultiplierCounter(for date: Date?) -> Int   {
        if let interval = date?.sinceNow{
            switch interval {
            case 0..<5:
                return 3
            case 5..<10:
                return 2
            case 10..<100:
                return 1
            default:
                return 1
            }
            
        } else {
            return 1
        }
    }
    
    mutating func reloadCard(at index:Int)  {
        cards[index].isFaceUp = false
        cards[index].isMatched = false
        cards[index].isKnown = false
        flipsCount = 0
        score = 0
    }
    
    
    init(numberOfPairs: Int){
        for _ in 1...numberOfPairs {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Date {
    var sinceNow: Int {
        return -Int(self.timeIntervalSinceNow)
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
