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
                if(!((x == 8 || x == 9) && (y == 8 || y == 9))){
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
        let yIndex = currentPosition % 100
        let xIndex = currentPosition / 100
        var numSteps = 0
        switch direction{
        case LEFT:
            while (xIndex - numSteps > 0 && myBoard[xIndex - numSteps, yIndex].Left() == false && myBoard[xIndex - numSteps - 1, yIndex].Right() == false && !hasRobot(currentPosition)){
                numSteps++
                currentPosition -= 1
            }
            return numSteps
        case RIGHT:
            while (xIndex + numSteps < 15 && myBoard[xIndex + numSteps, yIndex].Right() == false && myBoard[xIndex + numSteps + 1, yIndex].Left() == false && !hasRobot(currentPosition)){
                numSteps++
                currentPosition += 1
            }
            return numSteps
        
        case UP:
            while (yIndex - numSteps > 0 && myBoard[xIndex, yIndex - numSteps].Up() == false && myBoard[xIndex, yIndex - numSteps - 1].Down() == false && !hasRobot(currentPosition)){
                numSteps++
                currentPosition -= 100
            }
            return numSteps
        case DOWN:
            while (yIndex + numSteps < 15 && myBoard[xIndex, yIndex + numSteps].Down() == false && myBoard[xIndex , yIndex + numSteps + 1].Up() == false && !hasRobot(currentPosition)){
                numSteps++
                currentPosition += 100
            }
            return numSteps
        default:
            return -1;
        }
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