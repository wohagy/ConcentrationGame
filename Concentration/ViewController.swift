//
//  ViewController.swift
//  Concentration
//
//  Created by CS193p Instructor  on 09/25/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//
import UIKit 

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairs: numberOfPairs)
    
    var numberOfPairs: Int {
            return  (cardButtons.count+1)/2   
    }
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateModelFromView()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    
    @IBAction private func cardUpdater(_ sender: UIButton) {
        for index in cardButtons.indices {
            game.reloadCard(at: index)
            emoji[index] = nil
        }
        updateModelFromView()
        flipCount = 0
        emojiChoices = ["🎃", "👻", "👺", "😈", "👹", "😻"]
    }
    
    
    private func updateModelFromView(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                 button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.7264387012, blue: 0.2456656992, alpha: 1)
            }
        }
    }

    private var emojiChoices = ["🎃", "👻", "👺", "😈", "👹", "😻"]
    private var emoji = [Int:String]()
    
    private func emoji(for card:Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    
}

extension Int {
    var arc4random: Int {
        if self>0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self<0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
 
