//
//  ViewController.swift
//  Concentration
//
//  Created by CS193p Instructor  on 09/25/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//
import UIKit 

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairs: (cardButtons.count+1)/2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateModelFromView()
            print(emoji)
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    
    @IBAction func cardUpdater(_ sender: UIButton) {
        for index in cardButtons.indices {
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            emoji[index] = nil
        }
        game.indexOfOneAndOnlyFaceUpCard = nil
        updateModelFromView()
        flipCount = 0
        emojiChoices = ["🎃", "👻", "👺", "😈", "👹", "😻"]
        print(emoji)
    }
    
    
    func updateModelFromView(){
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

    var emojiChoices = ["🎃", "👻", "👺", "😈", "👹", "😻"]
    var emoji = [Int:String]()
    
    func emoji(for card:Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
