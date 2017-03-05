//
//  U2UInteraction.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import Parse
import Foundation

var Games : [Game] = [Game]();

func login(username: String, password: String){
    
    PFUser.logInWithUsernameInBackground(username, password:password) {
        
        (user: PFUser?, error: NSError?) -> Void in
        if user != nil {
            print("Sucessful Login")
            // Do stuff after successful login.
        } else {
            print("Failure");
            // The login failed. Check error to see why.
        }
    }
    
    
}


//CALL ONCE EVERY MINUTE OR SO, THIS WILL ADD ALL GAMES NOT STORED LOCALLY, AND WILL UPDATE ALL GAMES
func GameLogic(currentUser : PFUser){
    
    
    let GameIDs : [String] = currentUser["currentGames"] as! Array<String>
    
    for ID in GameIDs {
        
        
        for game in Games {
            if(game.gameID != ID){
                
                let query = PFQuery(className:"Game")
                query.getObjectInBackgroundWithId(ID) {
                    (game: PFObject?, error: NSError?) -> Void in
                    if error == nil && game != nil {
                        print("Adding new Game to Games")
                        
                        let board = game!["board"] as! String;
                        let firstplayerID = game!["firstplayerID"] as! String;
                        let secondplayerID = game!["secondplayerID"] as! String;
                        let turn = game!["turn"] as! Bool
                        let gameOver = game!["gameOver"] as! Bool
                        
                        let temp = Game(gameID : ID, board: board, firstplayerID: firstplayerID, secondplayerID: secondplayerID, gameOver: gameOver, turn: turn, currentUser: currentUser)
                        
                        Games.append(temp);
                        
                    } else {
                        print("Failed to add new Game, check network")
                    }
                }
            }
        }
        
        for game in Games{
            
            game.update()
        }
        
    }
}

//finds new games for current user and adds them to current games
func loopThroughGames(currentUser : PFUser){
    
    let query = PFQuery(className:"Game")
    query.whereKey("secondplayerID", equalTo:currentUser.objectId!)
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        
        if error == nil {
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) games.")
            // Do something with the found objects
            if let objects = objects {
                for object in objects {
                    if(!currentUser["currentGames"].containsObject(object.objectId!)){
                        
                        var currentGames : [String] = currentUser["currentGames"] as! Array<String>
                        currentGames.append(object.objectId!);
                        currentUser["currentGames"] = currentGames;
                    }
                    print(object.objectId)
                }
                
                currentUser.saveInBackgroundWithBlock{ (success :Bool, error : NSError?) -> Void in
                    if(success){
                        print("Found new game!");
                    } else {
                        print("Fuck me, what the fuck just happened")
                    }
                }
            }
        } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
        }
    }
    
}

//finds an opponent and creates a game with them
func findOpponent(currentUser : PFUser){
    
    
    
    if let query = PFUser.query(){
        query.whereKey("username", notEqualTo: currentUser.username!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) opponents.")
                // Do something with the found objects
                
                let random_Number = Int(arc4random_uniform((UInt32(objects!.count))))
                
                let opponent : PFUser = objects![random_Number] as! PFUser;
                initiateGame(currentUser, opponent: opponent);
                
            } else {
                
                print("Error in query");
                
            }
        }
    } else {
        
        print("check internet connection");
        
    }
    
    
}

func initiateGame(currentUser : PFUser, opponent : PFUser){
    
    let newGame = PFObject(className:"Game")
    newGame["firstplayerID"] = currentUser.objectId!
    newGame["secondplayerID"] = opponent.objectId!
    newGame["board"] = "..........";
    newGame["turn"] = true;
    newGame["gameOver"] = false;
    newGame.saveInBackgroundWithBlock {
        (success: Bool, error: NSError?) -> Void in
        if (success) {
            
            var currentGames : [String] = currentUser["currentGames"] as! Array<String>
            currentGames.append(newGame.objectId!);
            currentUser["currentGames"] = currentGames;
            
            currentUser.saveInBackgroundWithBlock{ (success :Bool, error : NSError?) -> Void in
                if(success){
                    print("Game saved....");
                } else {
                    print("Game failed to save within initiateGame function, not sure why...")
                }
            }
            
            print("Game Made Sucessfully.");
        } else {
            print("Game could not be made...Try again");
            // There was a problem, check error.description
        }
    }
    
    
}

func register(username: String, password: String) {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    let user = PFUser()
    
    user.username = username
    user.password = password
    
    user.signUpInBackgroundWithBlock {
        (succeeded: Bool, error: NSError?) -> Void in
        if let error = error {
            let errorString = error.userInfo["error"] as? NSString
            print("error : ");
            print(errorString);
            //Reload to screen, or display some error message
            
        } else {
            prefs.setBool(true, forKey: "UserMadeAccount")
            
            
            user["currentGames"] = [];
            
            user.saveInBackgroundWithBlock{ (success :Bool, error : NSError?) -> Void in
                if(success){
                    login(user.username!, password: user.password! );
                    //switch from register screen to login now
                    
                } else {
                    print("fuck")
                }
                
                
                
            }
        }
    }
    
    
}
