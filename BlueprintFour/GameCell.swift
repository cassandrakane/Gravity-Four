//
//  GameCell.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playerTurnLabel: UILabel!
    
    var label: Label? {
        didSet {
            if let label = label, playerLabel = playerLabel, playerTurnLabel = playerTurnLabel {
                //sets up note table cell
                self.playerLabel.text = label.playerName
                self.playerTurnLabel.text = label.playerTurn
            }
        }
    }
}
