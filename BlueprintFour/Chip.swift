//
//  Chip.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import UIKit

//red goes first by default
enum ChipType{
    case Red, Black, Blank
    func toggle() -> ChipType{
        if self == .Red{
            return .Black
        }
        else if self == .Black{
            return .Red
        }
        else{
            return .Blank
        }
    }
}

class Chip: UIView {
    var type: ChipType
    var row: Int
    var col: Int
    var screenLocation:CGPoint = CGPointZero
    var imageView: UIImageView
    
    //init blank at 0,0
    init(){
        self.type = .Blank
        self.row = 0
        self.col = 0
        imageView = UIImageView(image: UIImage(named: "ball.png"))
        //super.init(image: UIImage(named: "ball.png"))
        super.init(frame: CGRectMake(0, 0, 100, 100))
    }
    
    init(type: ChipType, row: Int, col: Int){
        self.type = type
        if type == .Red {
            imageView = UIImageView(image: UIImage(named: "RedChip"))
        } else if type == .Black {
            imageView = UIImageView(image: UIImage(named: "GreenChip"))
        }
        self.row = row
        self.col = col
        imageView = UIImageView(image: UIImage(named: "ball.png"))
        super.init(frame: CGRectMake(0, 0, 100, 100))
        //super.init(image: UIImage())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


