//
//  RobotBrain.swift
//  RicochetRobots
//
//  Created by Nathan Zhang on 12/22/15.
//  Copyright © 2015 Nathan Zhang. All rights reserved.
//

import Foundation

let LEFT = 0
let UP = 1
let RIGHT = 2
let DOWN = 3


let NUMROBOTS = 4

class RobotBrain{
    private var robots = [Int]()
    init(){
        var numbers = [Int]()
        for var x = 0; x < 16; x++ {
            for var y = 0; y < 16; y++ {
                //robots can't be placed in the very center
                if(!((x == 8 || x == 7) && (y == 8 || y == 7))){
                    numbers.append(x * 100 + y)
                }
            }
        }
        for var x = 0; x < NUMROBOTS; x++ { //this uses 256 because there are 256 totals spots but it can't be placed in the 4 in the center
            robots.append(numbers.removeAtIndex(Int(arc4random_uniform(UInt32(252 - x)))))
        }
    }
    
    func getRobots() -> Array<Int> {
        return robots
    }
    
    func calculateNumberOfSteps(robotIndex: Int, direction: Int, myBoard: Board) -> Int {
        var currentPosition = robotPosition(robotIndex)
        //xIndex are the ones going up and down, y is left to right
        //x is first 2 numbers, y is last 2
        //THESE SHOULD REALLY BE CALLED ROW AND COLn)
        var numSteps = 0
        while(canMoveInDirection(&currentPosition, dir: direction, myBoard: myBoard)){
            numSteps++
        }
        robots[robotIndex] = currentPosition
        return numSteps
    }
    
    func canMoveInDirection(inout num: Int, dir: Int, myBoard: Board) -> Bool {
        var nextPosition = 0;
        switch dir {
        case LEFT:
            nextPosition = num - 1
            if(!isValidPosition(nextPosition)){
                return false
            }
            if(myBoard[num / 100, num % 100].Left() || myBoard[nextPosition / 100, nextPosition % 100].Right()){
                return false
            }
        case RIGHT:
            nextPosition = num + 1
            if(!isValidPosition(nextPosition)){
                return false
            }
            if(myBoard[num / 100, num % 100].Right() || myBoard[nextPosition / 100, nextPosition % 100].Left()){
                return false
            }
        case UP:
            nextPosition = num - 100
            if(!isValidPosition(nextPosition)){
                return false
            }
            if(myBoard[num / 100, num % 100].Up() || myBoard[nextPosition / 100, nextPosition % 100].Down()){
                return false
            }
        case DOWN:
            nextPosition = num + 100
            if(!isValidPosition(nextPosition)){
                return false
            }
            if(myBoard[num / 100, num % 100].Down() || myBoard[nextPosition / 100, nextPosition % 100].Up()){
                return false
            }
        default:
            return false
        }
        num = nextPosition
        return true
    }
    
    func isValidPosition (num: Int) -> Bool {
        
        let r = num / 100
        let c = num % 100
        if(0 <= r && r < 16 && c >= 0 && c < 16 && !hasRobot(num)){
            return true
        }
        return false
    }
        
    func hasRobot(position: Int) -> Bool{
        for var x = 0; x < NUMROBOTS; x++ {
            if(robots[x] == position){
                return true
            }
        }
        return false
    }
        
    func robotPosition(index: Int) -> Int{
        return robots[index]
    }
    


}