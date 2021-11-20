//
//  Card.swift
//  Concentration
//
//  Created by Macbook on 01.11.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation

struct Card {
    var isMatched = false
    var isFaceUp = false
    var identifier: Int
    
    static var identifierFactory = 0
    static func getUiniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUiniqueIdentifier()
    }
}
