//
//  CardModel.swift
//  MatchApp
//
//  Created by Vijay C on 2020-12-25.
//

import Foundation
//Custom Card Model class
class CardModel {
    
    func getCards() -> [Card] {
        
        //Declare an empty arraty to store the random numbers generated already - for Dupe check
        var generatedNumbers = [Int]()
        
        //Declare an empty array to store cards
        var generatedCards = [Card]()
        
        //Randomly generate 8 pairs of cards
        
        while generatedNumbers.count < 8 {
            
            //Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                //Create two new card objects
                
                let cardOne = Card()
                let cardTwo = Card()
                
                //Set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                //Add the randomly generated cards (2) to array
                generatedCards += [cardOne, cardTwo]
                
                //print("First card \(cardOne.imageName)")
                //print("Second card \(cardTwo.imageName)")
                
                //Store the generated number to the Generated numbers array for Dupe check
                generatedNumbers.append(randomNumber)
                print(randomNumber)
            }
            
        }
        //Randomize the cards within the array
        generatedCards.shuffle()
        
        //Return the array
        return generatedCards
    }
}
