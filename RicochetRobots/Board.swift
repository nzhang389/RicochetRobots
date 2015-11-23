//
//  Board.swift
//  RicochetRobots
//
//  Created by Nathan Zhang on 10/28/15.
//  Copyright © 2015 Nathan Zhang. All rights reserved.
//

import Foundation
import UIKit

class Board{
    var p1: BoardQuarter
    var p2: BoardQuarter
    var p3: BoardQuarter
    var p4: BoardQuarter
    private var boardArray: Array<Array<BoardTile>>;
    //p1  p2
    //p4  p3
    
    
    
    //Ways to make the choosing of a board
    //Make a dictionary of all the different board quarters and randomly call one
    //choose a random number and somehow get that one to create a certain type
    // Store tuples of a coordinate and a boardTile in a file
    var possibleBoardPieces = [Int:Array<(Int, Int, BoardTile)>]()
    //Use an int array, first is x coord, then y coord
    init() {
        //variableValues[0] = {(
        //HARD CODE TONS OF SHIT
        
        //DON'T KNOW IF INITIALIZER FOR BOARDTILE WITH PARAMTERS SET WORKS RN

        initPossibleBoardPieces(possibleBoardPieces);
        //to make randomly generated int -, let randomNum = Int(arc4random_uniform(8))
        //Make 4 randomly generated ints -> put them in t
        
        //p1Num = randomNum = Int(arc4random_uniform(8))
        //p1 = BoardQuarter(possibleBoardPieces[p1Num])
        
        p1 = BoardQuarter()
        p2 = rotateQuarterRight(BoardQuarter())
        p3 = rotateQuarterRight(rotateQuarterRight(BoardQuarter()))
        p4 = rotateQuarterRight(rotateQuarterRight(rotateQuarterRight(BoardQuarter())))
        boardArray = Array<Array<BoardTile>>()
        for var x = 0; x < 16; x++ {
            boardArray.append(Array<BoardTile>())
            for var y = 0; y < 16; y++ {
                if(x < 8 && y < 8){
                    boardArray[x].append(p1[x,y])
                }
                else if(x < 8 && y >= 8){
                    boardArray[x].append(p2[x,y-8])
                }
                else if(x >= 8 && y < 8){
                    boardArray[x].append(p4[x-8,y])
                }
                else{
                    boardArray[x].append(p3[x-8,y-8])
                }
            }
        }
    }
    
    subscript(row: Int, column: Int) -> BoardTile {
        get{
            return boardArray[row][column]
        }
        set(newValue) {
            boardArray[row][column] = newValue
        }
    }
}


func initPossibleBoardPieces(var piece: [Int:Array<(Int, Int, BoardTile)>]){
    //Create a text file that i can read in and then store into the dictionary
    //var possibleBoardPieces = [Int:Array<(Int, Int, BoardTile)>]()
    piece[0] = [(0,1,BoardTile(u: false, d: false, l: false, r: true)),
                                (1,4,BoardTile(u: true, d: false, l: true, r: false)),
                                (2,1,BoardTile(u: true, d: false, l: false, r: true)),
                                (4,6,BoardTile(u: false, d: true, l: false, r: true)),
                                (5,0,BoardTile(u: false, d: true, l: false, r: false)),
                                (6,3,BoardTile(u: false, d: true, l: true, r: false))]
    piece[1] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
                                (1,5,BoardTile(u: false, d: true, l: false, r: true)),
                                (2,1,BoardTile(u: false, d: true, l: true, r: false)),
                                (3,0,BoardTile(u: false, d: true, l: false, r: false)),
                                (4,6,BoardTile(u: true, d: false, l: true, r: false)),
                                (6,2,BoardTile(u: true, d: false, l: false, r: true))]
    piece[2] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
                                (2,5,BoardTile(u: false, d: true, l: false, r: true)),
                                (4,0,BoardTile(u: false, d: true, l: false, r: false)),
                                (4,2,BoardTile(u: true, d: false, l: false, r: true)),
                                (5,7,BoardTile(u: false, d: true, l: true, r: false)),
                                (6,1,BoardTile(u: true, d: false, l: true, r: false))]
    piece[3] = [(0,3,BoardTile(u: false, d: false, l: false, r: true)),
                                (1,6,BoardTile(u: false, d: true, l: true, r: false)),
                                (3,1,BoardTile(u: true, d: false, l: false, r: true)),
                                (4,5,BoardTile(u: true, d: false, l: true, r: false)),
                                (5,2,BoardTile(u: false, d: true, l: false, r: true)),
                                (5,7,BoardTile(u: false, d: true, l: false, r: true)),
                                (6,0,BoardTile(u: false, d: true, l: false, r: false))]
    
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
    return newTile
}

//MAKE SURE I DO LAZY INITS SO IT ONLY INITIALZIES IF I DECIDE TO USE IT
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
    
    func test() {
        self[0,0].up = true
    }
}

class BoardTile: NSObject{
    
 
    //For if it wants a wall above it
    var up = false
    var down = false
    var left = false
    var right = false
    var isObjective = false
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
            return up == object.up && down == object.down && left == object.left && right == object.right && isObjective == object.isObjective
        } else {
            return false
        }
    }
    //hopefully we can do always print basic tile and then print an extra wall if one of the directions is true

}