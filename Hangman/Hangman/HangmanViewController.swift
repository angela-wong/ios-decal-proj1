//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    @IBOutlet weak var phraseProgress: UILabel!
    
    @IBOutlet weak var hangmanImage: UIImageView!
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    var phraseSoFar : String = ""
    var finalPhrase : String = ""
    var incorrectList = [String]()
    var numWrong = 0
    
    @IBAction func newGame(_ sender: UIButton) {
        phraseSoFar = ""
        finalPhrase = ""
        incorrectList = [String]()
        numWrong = 0
        
        incorrectGuesses.text = ""
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        print(phrase)
        finalPhrase = phrase
        for letter in phrase.characters {
            if letter == " " {
                phraseSoFar += "  "
            } else {
                phraseSoFar += "_ "
            }
        }
        phraseProgress.text = phraseSoFar
        hangmanImage.image = UIImage(named: "hangman1")
        for i in 1..<27 {
            let button = self.view.viewWithTag(i) as! UIButton
            button.isUserInteractionEnabled = true
            button.tintColor = UIColor(red:102/255, green:102/255, blue:255/255, alpha:1.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateImage() {
        if numWrong == 1 {
            hangmanImage.image = UIImage(named: "hangman2")
        } else if numWrong == 2 {
            hangmanImage.image = UIImage(named: "hangman3")
        } else if numWrong == 3 {
            hangmanImage.image = UIImage(named: "hangman4")
        } else if numWrong == 4 {
            hangmanImage.image = UIImage(named: "hangman5")
        } else if numWrong == 5 {
            hangmanImage.image = UIImage(named: "hangman6")
        } else {
            hangmanImage.image = UIImage(named: "hangman7")
            for i in 1..<27 {
                let button = self.view.viewWithTag(i) as! UIButton
                button.isUserInteractionEnabled = false
                button.tintColor = UIColor.gray
            }
            let alert = UIAlertController(title: "Sorry!", message: "You've lost the game. Play again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
    
    @IBOutlet weak var letterButtons: UIButton!
    
    @IBAction func letterWasPressed(_ sender: UIButton) {
        let tag = sender.tag
        if let letterVal = UnicodeScalar(96 + tag) {
            let guess = String(letterVal)
            var correct : Bool = false
            var chars = Array(phraseSoFar.characters)
            if chars.contains(Character(guess)) || incorrectList.contains(guess) {
                return
            }
            for i in 0..<finalPhrase.characters.count {
                if finalPhrase.substring(atIndex: i) == guess.uppercased() {
                    chars[2*i] = Character(finalPhrase.substring(atIndex: i))
                    correct = true
                }
            }
            let button = self.view.viewWithTag(tag) as! UIButton
            button.isUserInteractionEnabled = false
            button.tintColor = UIColor.gray
            if !correct {
                incorrectList.append(guess)
                incorrectGuesses.text = incorrectList.joined(separator: " ")
                numWrong += 1
                updateImage()

            } else {
                phraseSoFar = String(chars)
                phraseProgress.text = phraseSoFar
                if !chars.contains("_") {
                    for i in 1..<27 {
                        let button = self.view.viewWithTag(i) as! UIButton
                        button.isUserInteractionEnabled = false
                        button.tintColor = UIColor.gray
                    }
                    let alert = UIAlertController(title: "Congratulations!", message: "You've won the game!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

}
