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
    
//    var cycle: Int = 0 {
//        willSet{
//
//        }
//        didSet {
//            if oldValue > game.cycleCount {
//                updateModelFromView()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = concentrationsThemes.count.arc4random
        updateModelFromView()
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet weak var themeNameLabel: UILabel!
    
    @IBOutlet weak var ScoreCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            timerUpdate()
            updateModelFromView()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    
    @IBOutlet weak var cardUpdaterOutlet: UIButton!
    @IBAction private func cardUpdater(_ sender: UIButton) {
        for index in cardButtons.indices {
            game.reloadCard(at: index)
            emoji[index] = nil
        }
        timer.invalidate()
        indexTheme = concentrationsThemes.count.arc4random
        updateModelFromView()
        
    }
    
    var timer = Timer()
    var bestTimeResult: Int?
    
    private func timerUpdate() {
        if game.flipsCount == 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
                self.flipCountLabel.text = String(self.game.gameTimer()) + " sec"
            }
        } else if game.cycleCount == numberOfPairs {
            timer.invalidate()
            if let time = bestTimeResult {
                if time > game.gameTimer() {
                    bestTimeResult = time
                }
            } else {
                bestTimeResult = game.gameTimer()
            }
        }
    }
    
    private func updateFlipCountLabel(with count: Int) -> NSAttributedString  {
        let atributes : [NSAttributedString.Key:Any] = [
            .strokeColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            .strokeWidth : 5.0
            
        ]
        return NSAttributedString(string: "Flips: \(count)", attributes: atributes)
    }
    
    
    private func updateModelFromView(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                 button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : concentrationsThemes[indexTheme].cardColor
            }
        }
//        flipCountLabel.attributedText = updateFlipCountLabel(with: game.flipsCount)
        flipCountLabel.text = "0 sec"
        ScoreCountLabel.text = "Score: \(game.score)"
        
        
    }
    
    private var indexTheme = 0 {
        didSet {
            emoji = [Int:String]()
            themeNameLabel.text = concentrationsThemes[indexTheme].name
            emojiChoices = concentrationsThemes[indexTheme].emojis
            view.backgroundColor = concentrationsThemes[indexTheme].viewColor
            ScoreCountLabel.textColor = concentrationsThemes[indexTheme].cardColor
            themeNameLabel.textColor = concentrationsThemes[indexTheme].cardColor
            flipCountLabel.textColor = concentrationsThemes[indexTheme].cardColor
            cardUpdaterOutlet.backgroundColor = concentrationsThemes[indexTheme].cardColor
            cardUpdaterOutlet.setTitleColor(concentrationsThemes[indexTheme].viewColor, for: .normal) 
            
            
        }
    }
    private var emoji = [Int:String]()
    private var emojiChoices: String = ""
    
    
    private func emoji(for card:Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card.identifier] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private struct Theme {
        var name: String
        var emojis: String
        var viewColor: UIColor
        var cardColor: UIColor
        }
    
    private var concentrationsThemes: [Theme] = [
        Theme(name: "Halloween",
              emojis: "🎃👻👺😈👹💀☠️🧟‍♀️",
              viewColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
              cardColor: #colorLiteral(red: 0.9603708386, green: 0.7042585015, blue: 0.1982794106, alpha: 1)),
        Theme(name: "Fruits",
              emojis: "🌹🌺🌸🌻🌼💐🥀🌷",
              viewColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
              cardColor: #colorLiteral(red: 0.9469744563, green: 0.9561795592, blue: 0.2197425961, alpha: 1))
    ]
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
 
