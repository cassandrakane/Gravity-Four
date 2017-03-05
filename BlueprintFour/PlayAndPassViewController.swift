//
//  PlayAndPassViewController.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import UIKit

class PlayAndPassViewController: UIViewController {

    var angle: CGFloat = 0
    
    @IBOutlet weak var turnLabel: UILabel!

    @IBOutlet var winLabel: UILabel!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var gameBoard: Board!
    
    @IBOutlet weak var gameBoardView: UIImageView!
    
    var game: Game
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dropCol0(sender: AnyObject) {
        var newChip = gameBoard.playChip(0)
        animateChipDrop(0, chip: newChip)
    }
    
    @IBAction func dropCol1(sender: AnyObject) {
        var newChip = gameBoard.playChip(1)
        animateChipDrop(1, chip: newChip)
    }
    
    @IBAction func dropCol2(sender: AnyObject) {
        var newChip = gameBoard.playChip(2)
        animateChipDrop(2, chip: newChip)
    }
    
    @IBAction func dropCol3(sender: AnyObject) {
        var newChip = gameBoard.playChip(3)
        animateChipDrop(3, chip: newChip)
    }
    
    @IBAction func dropCol4(sender: AnyObject) {
        var newChip = gameBoard.playChip(4)
        animateChipDrop(4, chip: newChip)
    }
    
    @IBAction func dropCol5(sender: AnyObject) {
        var newChip = gameBoard.playChip(5)
        animateChipDrop(5, chip: newChip)
    }
    
    @IBAction func dropCol6(sender: AnyObject) {
        var newChip = gameBoard.playChip(6)
        animateChipDrop(6, chip: newChip)
    }
    
    
    @IBAction func rotateClockwise(sender: AnyObject) {
        gameBoard.rotateLeft()
        UIView.animateWithDuration(2.0, animations: {
            self.angle -= CGFloat(M_PI_2)
            self.gameBoardView.transform = CGAffineTransformMakeRotation(self.angle)
            }
        )
        chipsFall()
        
    }
    
    @IBAction func rotateCounterClockwise(sender: AnyObject) {
        gameBoard.rotateRight()
        UIView.animateWithDuration(2.0, animations: {
            self.angle += CGFloat(M_PI_2)
            self.gameBoardView.transform = CGAffineTransformMakeRotation(self.angle)
            }
        )
        chipsFall()
    }
    
    
    
    func chipsFall(){
        gameBoard.printBoard()
        var newChipPositions = gameBoard.applyGravity()
        gameBoard.printBoard()
        for chipInfo in newChipPositions {
            var chip = chipInfo.chip
            let rowDiff = chipInfo.oldRow - chip.row
            let chipHeight = gameBoard.bounds.height / 7
            let distanceToTravel = chipHeight * CGFloat(rowDiff)
            UIView.animateWithDuration(2, animations: {
                
                chip.frame = CGRect(x: chip.frame.origin.x, y: chip.frame.origin.y + distanceToTravel, width: chip.frame.width, height: chip.frame.height)
            })
        }
        if gameBoard.checkWin().chip.type != .Blank {
            winLabel.text = "You Win!"
        }  else {
            switchPlayerLabel()
        }
    }
    

    
    func animateChipDrop(col: Int, chip: Chip) {
        
        if chip.type == .Blank {
            return
        }
        
        let boardSize = gameBoardView.frame.size
        let chipSize = boardSize.width/CGFloat(kRows)
        
        
        chip.frame = CGRect(x: CGFloat(col)*chipSize, y: -chipSize, width: chipSize, height: chipSize)
        chip.imageView.frame = CGRect(origin: CGPointZero, size: chip.frame.size)
        chip.addSubview(chip.imageView)
        
        //chip.backgroundColor=UIColor.redColor()
        gameBoardView.addSubview(chip)
        
        UIView.animateWithDuration(Double(CGFloat(0.1)*CGFloat(kRows-chip.row)), delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            chip.center.y += CGFloat(kRows-chip.row)*chipSize
        }, completion: nil)
        
        if gameBoard.checkWin().chip.type != .Blank {
            winLabel.text = "You Win!"
        } else {
            switchPlayerLabel()
        }
    }
    
    func switchPlayerLabel() {
        if turnLabel.text == "Red's Turn" {
            turnLabel.text = "Green's Turn"
        } else if turnLabel.text == "Green's Turn" {
            turnLabel.text = "Red's Turn"
        } else {
            turnLabel.text = "? Turn"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
