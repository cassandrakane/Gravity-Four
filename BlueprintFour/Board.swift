//
//  Board.swift
//  BlueprintFour
//
//  Created by Cassandra Kane on 2/28/16.
//  Copyright © 2016 Cassandra Kane. All rights reserved.
//

import UIKit

let kRows = 7
let kCols = 7

enum BoardOrientation{
    case North, East, South, West
    
    func toRight() -> BoardOrientation{
        switch self{
        case .North:
            return .West
        case .East:
            return .North
        case .South:
            return .East
        case .West:
            return .North
        }
    }
}

enum WinType{
    case Horizontal /* anchor on left */ , Vertical , DiagonalLeft, DiagonalRight /*anchor on bottom for other 3*/
}

class Board: UIView {
    
    //data[row][column]
    var data: [[Chip]]
    var pieces: [Chip]
    var orientation: BoardOrientation = .North
    var turn: ChipType = .Red
    
    init(){
        
        data = [[Chip]](count: kRows, repeatedValue: [Chip](count: kCols, repeatedValue: Chip.init()))
        pieces = [Chip]()
        for row in 0..<kRows {
            for col in 0..<kCols {
                let newChip = Chip(type: .Blank, row: row, col: col)
                data[row][col] = newChip
            }
        }
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        data = [[Chip]](count: kRows, repeatedValue: [Chip](count: kCols, repeatedValue: Chip.init()))
        pieces = [Chip]()
        for row in 0..<kRows {
            for col in 0..<kCols {
                let newChip = Chip(type: .Blank, row: row, col: col)
                data[row][col] = newChip
            }
        }
        super.init(coder: aDecoder)
    }

    /*required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        
    }*/
    
    // (rows, columns)
    func currentDimensions() -> (Int, Int){
        switch orientation{
        case .North,.South:
            return (kRows, kCols)
        case .East, .West:
            return (kCols, kRows)
        }
    }
    
    //calls dropInColumn w/ current turn then toggles turn (if success)
    func playChip(col: Int) -> Chip{
        let chip = dropInColumn(col, type: turn)
        if chip.type != ChipType.Blank {
            turn = turn.toggle()
        }
        return chip
    }
    
    //returns a blank chip if no chip was placed (b/c coords are out of bounds)
    func dropInColumn(col: Int, type: ChipType) -> Chip{
        
        let dim: (rows: Int, cols: Int) = currentDimensions()
        
        if col >= dim.cols {
            return Chip()
        }
        
        for row in 0..<dim.rows{
            if data[row][col].type == ChipType.Blank {
                let newChip = Chip(type: type, row: row, col: col)
                self.data[row][col] = newChip
                pieces.append(newChip)
                return newChip
            }
        }
        
        return Chip()
    }
    
    
    func rotateRight(){
        let dim: (rows: Int, cols: Int) = currentDimensions()
        var newData = [[Chip]](count: kRows, repeatedValue: [Chip](count: kCols, repeatedValue: Chip()))
        
        for row in 0..<dim.rows{
            for col in 0..<dim.cols{
                newData[dim.rows-1-col][row] = data[row][col]
                data[row][col].row = dim.rows-1-col
                data[row][col].col = row
            }
        }
        
        data = newData
        orientation = orientation.toRight()
    }
    
    func rotateLeft(){
        let dim: (rows: Int, cols: Int) = currentDimensions()
        var newData = [[Chip]](count: kRows, repeatedValue: [Chip](count: kCols, repeatedValue: Chip()))
        
        for row in 0..<dim.rows{
            for col in 0..<dim.cols{
                newData[col][dim.cols-1-row] = data[row][col]
                data[row][col].row = dim.rows-1-col
                data[row][col].col = row
            }
        }
        
        data = newData
        orientation = orientation.toRight().toRight().toRight()
    }
    
    func applyGravity() -> [(chip: Chip, oldRow: Int, oldCol: Int)]{
        let dim: (rows: Int, cols: Int) = currentDimensions()
        
        var piecesMoved = [(chip: Chip, oldRow: Int, oldCol: Int)]()
        
        for col in 0..<dim.cols {
            var nextEmpty: Int = 0
            for row in 0..<dim.rows{
                if data[row][col].type == .Blank {
                    continue
                }
                else{
                    let oldType = data[nextEmpty][col].type
                    data[nextEmpty][col].type = data[row][col].type
                    data[row][col].type = oldType
                    nextEmpty++
                    
                    piecesMoved.append((data[nextEmpty][col],row,col))
                }
            }
        }
    
        return piecesMoved
    }

    
    func checkWin() -> (chip: Chip, type: WinType){
        
        let dim: (rows: Int, cols: Int) = currentDimensions()
        
        //horizontal:
        for row in 0..<dim.rows{
            for col in 0...dim.cols-4{
                if data[row][col].type == .Blank {continue}
                if (data[row][col].type == data[row][col+1].type &&
                    data[row][col].type == data[row][col+2].type &&
                    data[row][col].type == data[row][col+3].type){
                        return (data[row][col], .Horizontal)
                }
            }
        }
        
        //vertical:
        for col in 0..<dim.cols{
            for row in 0...dim.rows-4{
                if data[row][col].type == .Blank {continue}
                if (data[row][col].type == data[row+1][col].type &&
                    data[row][col].type == data[row+2][col].type &&
                    data[row][col].type == data[row+3][col].type){
                        return (data[row][col], .Vertical)
                }
            }
        }
        
        //diagonal right:
        for col in 0...dim.cols-4{
            for row in 0...dim.rows-4{
                if data[row][col].type == .Blank {continue}
                if (data[row][col].type == data[row+1][col+1].type &&
                    data[row][col].type == data[row+2][col+2].type &&
                    data[row][col].type == data[row+3][col+3].type){
                        return (data[row][col], .DiagonalRight)
                }
            }
        }
        
        //diagonal left:
        for col in 3..<dim.cols{
            for row in 0...dim.rows-4{
                if data[row][col].type == .Blank {continue}
                if (data[row][col].type == data[row+1][col-1].type &&
                    data[row][col].type == data[row+2][col-2].type &&
                    data[row][col].type == data[row+3][col-3].type){
                        return (data[row][col], .DiagonalLeft)
                }
            }
        }
        
        return (Chip(), .Horizontal)
    }
    
    
    func encodeBoard() -> String{
        
        let dim: (rows: Int, cols: Int) = currentDimensions()
        var p = ""
        for row in 0..<dim.rows {
            for col in 0..<dim.cols{
                switch data[dim.rows-1-row][col].type{
                case .Red:
                    p += " X "
                case .Black:
                    p += " Y "
                case .Blank:
                    p += " . "
                }
            }
            p += "\n"
        }
        //print(p)
        return p
    }
    
    func printBoard(){
        print(encodeBoard())
    }
    
    class func decodeBoard(encoded: String) -> Board{
        
        let b = Board()
        var index = 1
        for r in 0..<kRows {
            for col in 0..<kCols{
                //b.data[row][col]
                let row = kRows-r-1
                switch encoded[encoded.startIndex.advancedBy(index)]{
                    
                case "X":
                    b.data[row][col].type = .Red
                case "Y":
                    b.data[row][col].type = .Black
                default:
                    b.data[row][col].type = .Blank
                    
                }
                index += 3
            }
            index += 1
        }
        
        return b
    }
    
}



