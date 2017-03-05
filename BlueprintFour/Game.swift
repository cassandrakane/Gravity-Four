//
//  Game.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import Foundation
import Parse

class Game {
    
    var gameID : String;
    var board : String;
    var firstplayerID : String;
    var secondplayerID : String;
    var gameOver : Bool;
    var turn : Bool;
    var isCurrentUserFirst : Bool;
    
    //WHEN TURN IS TRUE, IT IS FIRSTPLAYER'S TURN
    
    init(gameID : String, board: String, firstplayerID: String, secondplayerID: String, gameOver: Bool, turn: Bool, currentUser: PFUser){
        self.gameID = gameID;
        self.board = board;
        self.firstplayerID = firstplayerID;
        self.secondplayerID = secondplayerID;
        self.gameOver = gameOver;
        self.turn = turn;
        
        if(currentUser.objectId! == firstplayerID){
            isCurrentUserFirst = true;
        }
        else {
            isCurrentUserFirst = false;
        }
    }
    
    func pushBoard(){
        
        
        let query = PFQuery(className:"Game")
        query.getObjectInBackgroundWithId(self.gameID) {
            (Game: PFObject?, error: NSError?) -> Void in
            if error == nil && Game != nil {
                print("Pushing Game Info to Opponent")
                
                Game!["board"] = self.board;
                Game!["turn"] = !self.turn;
                //HERE IS WHERE CHECKING FOR VICTORY SHOULD BE...
                
            } else {
                
                print("Unable to Push Game Info to Opponent")
                
            }
        }
        
        
        
        
        
    }
    
    func update(){
        if(isCurrentUserFirst && turn == false){
            
            let query = PFQuery(className:"Game")
            query.getObjectInBackgroundWithId(self.gameID) {
                (Game: PFObject?, error: NSError?) -> Void in
                if error == nil && Game != nil {
                    print("Updated Game Info")
                    
                    self.board = Game!["board"] as! String;
                    self.firstplayerID = Game!["firstplayerID"] as! String;
                    self.secondplayerID = Game!["secondplayerID"] as! String;
                    self.turn = Game!["turn"] as! Bool
                    self.gameOver = Game!["gameOver"] as! Bool
                    
                    
                } else {
                    print("Unable to update Game")
                }
            }
            
            
            
        }
    }
    
}
