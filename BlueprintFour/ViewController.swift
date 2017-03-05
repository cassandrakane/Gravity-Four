//
//  ViewController.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            
            print("You are already logged in");
            
            findOpponent(currentUser!);
            
            // Do stuff with the user
        } else {
            
            let UserMadeAccount = self.prefs.boolForKey("UserMadeAccount")
            if(UserMadeAccount){
                
                
                
                
                //show login screen
            } else {
                
                
                register("Vishnu",password: "fsdajjlkj");
                
                //show sign in screen
            }
            
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}

