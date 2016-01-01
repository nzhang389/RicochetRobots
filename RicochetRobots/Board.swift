//
//  Board.swift
//  RicochetRobots
//
//  Created by Nathan Zhang on 10/28/15.
//  Copyright © 2015 Nathan Zhang. All rights reserved.
//

import Foundation
import UIKit


let NUMPIECES = 8

let BLUE = 0
let RED = 1
let YELLOW = 2
let GREEN = 3
let ANYCOLOR = 4

class Board{
    private var quarterArray: Array<BoardQuarter>;
    private var boardArray: Array<Array<BoardTile>>;
   
    private var piecesToUse = Array<Int>()
    private var numObjectives = 0
    //0  1
    //3  2
    
    private var objectivePosition = 0
    private var objectiveColor = -1
    
    private var possibleBoardPieces = [Int:Array<(Int, Int, BoardTile)>]()
    
    //First int for color, second for position
    private var possibleObjectives = Array<(Int, Int)>()
    //Use an int array, first is row number, then col number (backwards for x,y)
    init() {
        
        
        boardArray = Array<Array<BoardTile>>()
        quarterArray =  Array<BoardQuarter>();
        
        
        initPossibleBoardPieces();
        piecesToUse = fillPiecesToUse();
        
        for var x = 0; x < 4; x++ {
            var piece = BoardQuarter(extraWalls: possibleBoardPieces[piecesToUse[x]]!)
            var y = x
            while(y > 0){
                piece = rotateQuarterRight(piece)
                y--
            }
            quarterArray.append(piece);
        }
        
        //these should be row, col but its ok
        for var x = 0; x < 16; x++ {
            boardArray.append(Array<BoardTile>())
            for var y = 0; y < 16; y++ {
                if(x < 8 && y < 8){
                    boardArray[x].append(quarterArray[0][x,y])
                }
                else if(x < 8 && y >= 8){
                    boardArray[x].append(quarterArray[1][x,y-8])
                }
                else if(x >= 8 && y < 8){
                    boardArray[x].append(quarterArray[3][x-8,y])
                }
                else{
                    boardArray[x].append(quarterArray[2][x-8,y-8])
                }
                if(boardArray[x][y].Color() != -1){
                    possibleObjectives.append((boardArray[x][y].Color(), 100 * x + y))
                    numObjectives++
                }
            }
        }
        addObjective()
    }
    
    func addObjective(){
        let oldObjective = objectivePosition
        if(objectiveColor != -1){
            self[objectivePosition / 100, objectivePosition % 100].switchAsObjective()
        }
        while(oldObjective == objectivePosition){
            objectivePosition = possibleObjectives[Int(arc4random_uniform(UInt32(numObjectives)))].1
        }
        self[objectivePosition / 100, objectivePosition % 100].switchAsObjective()
        objectiveColor = self[objectivePosition / 100, objectivePosition % 100].Color()
    }
    
    func fillPiecesToUse() -> Array<Int>{
        var numbers = Array<Int>()
        var piecesToUse = Array<Int>()
        for var x = 0; x < NUMPIECES; x++ {
            numbers.append(x);
        }
        for var x = 0; x < 4; x++ {
            piecesToUse.append(numbers.removeAtIndex(Int(arc4random_uniform(UInt32(NUMPIECES - x)))))
        }
        return piecesToUse
    }

    func getObjective() -> (Int, Int) {
        return (objectiveColor, objectivePosition)
    }
    
    subscript(row: Int, column: Int) -> BoardTile {
        get{
            return boardArray[row][column]
        }
        set(newValue) {
            boardArray[row][column] = newValue
        }
    }
    
    func initPossibleBoardPieces(){
        //Create a text file that i can read in and then store into the dictionary
        //var possibleBoardPieces = [Int:Array<(Int, Int, BoardTile)>]()
        possibleBoardPieces[0] = [(0,1,BoardTile(u: false, d: false, l: false, r: true)),
            (1,4,BoardTile(u: true, d: false, l: true, r: false, c: 1)),
            (2,1,BoardTile(u: true, d: false, l: false, r: true, c: 3)),
            (4,6,BoardTile(u: false, d: true, l: false, r: true, c: 2)),
            (5,0,BoardTile(u: false, d: true, l: false, r: false)),
            (6,3,BoardTile(u: false, d: true, l: true, r: false, c: 0))]
        possibleBoardPieces[1] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
            (1,5,BoardTile(u: false, d: true, l: false, r: true, c: 3)),
            (2,1,BoardTile(u: false, d: true, l: true, r: false, c: 1)),
            (3,0,BoardTile(u: false, d: true, l: false, r: false)),
            (4,6,BoardTile(u: true, d: false, l: true, r: false, c: 2)),
            (6,2,BoardTile(u: true, d: false, l: false, r: true, c: 0))]
        possibleBoardPieces[2] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
            (2,5,BoardTile(u: false, d: true, l: false, r: true, c: BLUE)),
            (4,0,BoardTile(u: false, d: true, l: false, r: false)),
            (4,2,BoardTile(u: true, d: false, l: false, r: true, c: GREEN)),
            (5,7,BoardTile(u: false, d: true, l: true, r: false, c: RED)),
            (6,1,BoardTile(u: true, d: false, l: true, r: false, c: YELLOW))]
        possibleBoardPieces[3] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
            (1,6,BoardTile(u: false, d: true, l: true, r: false, c: BLUE)),
            (3,1,BoardTile(u: true, d: false, l: false, r: true, c: YELLOW)),
            (4,5,BoardTile(u: true, d: false, l: true, r: false, c: GREEN)),
            (5,2,BoardTile(u: false, d: true, l: false, r: true, c: RED)),
            (5,7,BoardTile(u: false, d: true, l: false, r: true, c: ANYCOLOR)),
            (6,0,BoardTile(u: false, d: true, l: false, r: false))]
        possibleBoardPieces[4] = [(0,4,BoardTile(u: false, d: false, l: false, r: true)),
            (1,6,BoardTile(u: false, d: true, l: false, r: true, c: YELLOW)),
            (2,1,BoardTile(u: true, d: false, l: true, r: false, c: GREEN)),
            (5,0,BoardTile(u: false, d: true, l: false, r: false)),
            (5,6,BoardTile(u: true, d: false, l: false, r: true, c: BLUE)),
            (6,3,BoardTile(u: false, d: true, l: true, r: false, c: RED))]
        possibleBoardPieces[5] = [(0,4,BoardTile(u: false, d: false, l: false, r: true)),
            (1,2,BoardTile(u: true, d: false, l: true, r: false, c: YELLOW)),
            (3,6,BoardTile(u: false, d: true, l: true, r: false, c: BLUE)),
            (4,0,BoardTile(u: false, d: true, l: false, r: false)),
            (5,4,BoardTile(u: true, d: false, l: false, r: true, c: RED)),
            (6,1,BoardTile(u: false, d: true, l: false, r: true, c: GREEN))]
        possibleBoardPieces[6] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
            (1,1,BoardTile(u: false, d: true, l: true, r: false, c: RED)),
            (2,6,BoardTile(u: true, d: false, l: false, r: true, c: GREEN)),
            (4,2,BoardTile(u: false, d: true, l: false, r: true, c: BLUE)),
            (5,0,BoardTile(u: false, d: true, l: false, r: false)),
            (5,7,BoardTile(u: true, d: false, l: true, r: false, c: YELLOW))]
        possibleBoardPieces[7] = [(0,4,BoardTile(u: false, d: false, l: false, r: true)),
            (1,2,BoardTile(u: false, d: true, l: false, r: true, c: RED)),
            (3,1,BoardTile(u: false, d: true, l: true, r: false, c: GREEN)),
            (4,0,BoardTile(u: false, d: true, l: false, r: false)),
            (4,6,BoardTile(u: true, d: false, l: true, r: false, c: YELLOW)),
            (6,5,BoardTile(u: true, d: false, l: false, r: true, c: BLUE)),
            (7,3,BoardTile(u: false, d: true, l: false, r: true, c: ANYCOLOR))]
    }

}



func rotateQuarterRight(a: BoardQuarter) -> BoardQuarter {
    var newQuarter = BoardQuarter()
    for var x = 0; x < 8; x++ {
        for var y = 0; y < 8; y++ {
            newQuarter[x,y] = rotateTileRight(a[7-y,x])
            //newQuarter[y,7-x] = rotateTileRight(a[x,y])
        }
    }
    return newQuarter
}

func rotateTileRight(a: BoardTile) -> BoardTile {
    var newTile = BoardTile()
    if(a.up){
        newTile.right = true
    } else{
        newTile.right = false
    }
    if(a.right){
        newTile.down = true
    }else {
        newTile.down = false
    }
    if(a.down){
        newTile.left = true
    }else {
        newTile.left = false
    }
    if(a.left){
        newTile.up = true
    }else{
        newTile.up = false
    }
    newTile.color = a.color
    return newTile
}

class BoardQuarter{
    
    private var boardQuarterArray: Array<Array<BoardTile>>;
    
    init(){
        boardQuarterArray = Array<Array<BoardTile>>();
        for var x = 0; x < 8 ; x++ {
            boardQuarterArray.append(Array<BoardTile>())
            for var y = 0; y < 8; y++ {
                boardQuarterArray[x].append(BoardTile())
                if y == 0{
                    boardQuarterArray[x][y].left = true
                }
                if x == 0{
                    boardQuarterArray[x][y].up = true
                }
                if x == 7 && y == 7{
                    boardQuarterArray[x][y].up = true
                    boardQuarterArray[x][y].left = true
                }
            }
        }
    }
    
    init(extraWalls: Array<(Int, Int, BoardTile)>){
        var counter = 0;
        boardQuarterArray = Array<Array<BoardTile>>();
        for var x = 0; x < 8 ; x++ {
            boardQuarterArray.append(Array<BoardTile>())
            for var y = 0; y < 8; y++ {
                if(counter < extraWalls.count && extraWalls[counter].0 == x && extraWalls[counter].1 == y){
                    boardQuarterArray[x].append(extraWalls[counter].2)
                    counter++
                } else {
                    boardQuarterArray[x].append(BoardTile())
                }
                if y == 0{
                    boardQuarterArray[x][y].left = true
                }
                if x == 0{
                    boardQuarterArray[x][y].up = true
                }
                if x == 7 && y == 7{
                    boardQuarterArray[x][y].up = true
                    boardQuarterArray[x][y].left = true
                }
            }
        }
    }
    
    subscript(row: Int, column: Int) -> BoardTile {
        get{
            return boardQuarterArray[row][column]
        }
        set(newValue) {
            boardQuarterArray[row][column] = newValue
        }
    }
    
}

//MAKE ISOBJECTIVE AN INT FOR THE COLOR IT IS

class BoardTile: NSObject{
    
 
    //For if it wants a wall above it
    private var up = false
    private var down = false
    private var left = false
    private var right = false
    private var color = -1
    private var isCurrentObjective = false
    //if it is true, its the bright square 
    
    override init(){
        super.init()
    }
 
    init(u: Bool, d: Bool, l: Bool, r: Bool){
        super.init()
        up = u;
        down = d;
        left = l;
        right = r;
    }
    
    init(u: Bool, d: Bool, l: Bool, r: Bool, c:Int){
        super.init()
        up = u;
        down = d;
        left = l;
        right = r;
        color = c
    }
    
    func Up () -> Bool{
        return up
    }
    
    func Down () -> Bool{
        return down
    }
    
    func Left () -> Bool{
        return left
    }
    
    func Right () -> Bool{
        return right
    }
    
    func Color () -> Int{
        return color
    }
    
    func switchAsObjective() {
        isCurrentObjective = !isCurrentObjective
    }
    
    func isTheObjective() -> Bool{
        return isCurrentObjective
    }
    
    func getHash() -> Int{
        var value = 0
        if up {
            value += 1
        }
        if down {
            value += (1 << 1)
        }
        if left {
            value += (1 << 2)
        }
        if right {
            value += (1 << 3)
        }
        return value
    }
    
    override func isEqual(object: AnyObject?) -> Bool{
        if let object = object as? BoardTile {
            return up == object.up && down == object.down && left == object.left && right == object.right && color == object.color
        } else {
            return false
        }
    }
    //hopefully we can do always print basic tile and then print an extra wall if one of the directions is true

}