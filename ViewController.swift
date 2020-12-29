//
//  ViewController.swift
//  MatchApp
//
//  Created by Vijayanand Chinnakannan on 2020-12-25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    //Total duration for the game - set to 45 seconds
    var milliSeconds:Int = 45 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        //Set the view controller as delegate and data source of the collection view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Initialize timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    //MARK: Timer methods
    
    @objc func timerFired() {
        
        //Decrement the timer
        milliSeconds -= 1
        
        //Update the label
        let seconds:Double = Double(milliSeconds)/1000.0
        timerLabel.text = String(format: "Time Remaining %.2f", seconds)
        
        //Stop the timer if it reaches zero
        if milliSeconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //TODO: Check if the user has matched all the cards
            checkForGameEnd()
        }
        
    }
    
    // MARK: - Collection view delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //return a cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Configure the state of the cell based on the property
        let cardCell = cell as? CardCollectionViewCell
        
        //Get the card from the card Array
        let card = cardsArray[indexPath.row]
        
        //Finish configuring the cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check for time remaining and stop user interaction if Timer has reached Zero!
        if milliSeconds <= 0 {
            return
        }
        
        //Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //Check the flip status of the card
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            //Flip the card up
            cell?.flipUP()
            
            //Play flip sound
            soundPlayer.playSound(effect: .flip)
            
            //Check for first flipped card
            if firstFlippedCardIndex == nil {
                
                //This is the first flipped card
                firstFlippedCardIndex = indexPath
            }
            else {
                //Second card that is flipped
                
                //Compare the two flipped cards
                checkForMatch(indexPath )
            }
            
        }
        //Code to let user flip the card down manually
        //else {
            //Flip the card down
        //    cell?.flipDown()
        //}
    }
    //MARK: Game logic method
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        //Get the indices for the two flipped cards and see if they are a match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //Get the collection view cells representing Card 1 & 2
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
        //It's a match
            
            //Play match sound
            soundPlayer.playSound(effect: .match)
        
        //set the status and remove the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Was that the last pair of card matched
            checkForGameEnd()
            
        }
        else {
            //The flipped cards are not a match
            //Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //Flip the cards down
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        //Reset the first flipped card Index property
        firstFlippedCardIndex = nil
    }
    func checkForGameEnd() {
        //Check if any card is unmatched
        //Assume the user has won, loop through all the cards to see if all are matched
        
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                //Unmatched card found
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            //User has won, show an alert to the user
            showAlert(title: "Congratulations!", message: "Welcome to Jumanji!")
        }
        else {
            //User hasn't won check if there is any time left
            if milliSeconds <= 0 {
                showAlert(title: "Time's Up!", message: "Jumanji needs you, Try again!")
            }
        }
        
    }
    
    func showAlert(title:String, message:String) {
        
        //Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //Add button for the user to dismiss the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        //Show the alert to the user
        present(alert, animated: true, completion: nil)
        
    }
    
}
