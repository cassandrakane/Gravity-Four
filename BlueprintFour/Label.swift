//
//  Label.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import Foundation

class Label {
    var playerName: String = ""
    var playerTurn: String = ""
    
    init(pN: String, pT: String) {
        playerName = pN
        playerTurn = pT
    }
}