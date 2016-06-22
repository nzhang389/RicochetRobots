//
//  BoardView.swift
//  RicochetRobots
//
//  Created by Nathan Zhang on 11/2/15.
//  Copyright © 2015 Nathan Zhang. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var board: Board?
    var myRobots: RobotBrain
    var startX: CGFloat
    var startY: CGFloat
    var contentSize: CGFloat
    var cellSize: CGFloat
    var cellDict = [NSInteger:CGImageRef]()
    var context: CGContext?
    let timer = NSTimer()
    
    override func layoutSubviews() {
        myRobots = RobotBrain()
        board = Board()
        startX = 0
        startY = 0
        contentSize = frame.width
        cellSize = contentSize / CGFloat(16)
        context = nil
    }

    required init?(coder aDecoder: NSCoder) {
        myRobots = RobotBrain()
        board = Board()
        startX = 0
        startY = 0
        contentSize = 0
        cellSize = 0
        context = nil
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        context = UIGraphicsGetCurrentContext()
        drawBoard()
        drawObjective()
        drawRobots()
        drawWalls()
    }
    
    func newObjectives(){
        board?.addObjective()
        self.setNeedsDisplay()
    }
    
    func newBoard(){
        board = Board()
        myRobots = RobotBrain()
        self.setNeedsDisplay()
    }
    
    func moveInDirection(color: Int, dir: Int) -> Bool{
        var reachedObjective = false;
        myRobots.calculateNumberOfSteps(color, direction: dir, atObjective: &reachedObjective, myBoard: board!)
        if(reachedObjective){
            return true;
        }
        self.setNeedsDisplay()
        return false;
    }

    
    func drawBoard(){
        resetStartingPoint()
        let image = UIImage(named: "BlankTile.png")?.CGImage
        for var row = 0; row < 16; row++ {
            for var col = 0 ; col < 16; col++ {
                //remake the walls so i print them onto the grid after doing all the blank tiles
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), image)
                //let hashValue = board!.boardArray[row, col].getHash()
                
                startX += cellSize;
            }
            startX = 0;
            startY += cellSize;
        }
    }
    
    func drawRobots(){
        let robots = myRobots.getRobots()
        for var x = 0; x < NUMROBOTS; x++ {
            resetStartingPoint()
            let xIndex = robots[x] % 100
            let yIndex = robots[x] / 100
            startX += cellSize * CGFloat(xIndex)
            startY += cellSize * CGFloat(yIndex)
            switch x {
            case RED:
                let img = UIImage(named: "redRobot.png")?.CGImage
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
                break
            case YELLOW:
                let img = UIImage(named: "yellowRobot.png")?.CGImage
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
                break
            case BLUE:
                let img = UIImage(named: "blueRobot.png")?.CGImage
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
                break
            default: //green
                let img = UIImage(named: "greenRobot.png")?.CGImage
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
            }

        }
    }
    

    
    func drawWalls(){
        resetStartingPoint()
        let horizWall = UIImage(named: "HorizontalWall.png")?.CGImage
        let vertWall = UIImage(named: "VerticalWall.png")?.CGImage
        for var row = 0; row < 16; row++ {
            for var col = 0; col < 16; col++ {
                let currentTile = board![row,col]
                if(currentTile.Up()){
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize / 8), horizWall)
                }
                if(currentTile.Down()){
                    startY += cellSize * CGFloat(7.0/8.0)
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize / 8), horizWall)
                    startY -= cellSize * CGFloat(7.0/8.0)
                }
                if(currentTile.Left()){
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize / 8, height: cellSize), vertWall)
                }
                if(currentTile.Right()){
                    startX += cellSize * CGFloat(7.0/8.0)
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize / 8, height: cellSize), vertWall)
                    startX -= cellSize * CGFloat(7.0/8.0)
                }
                startX += cellSize
            }
            startX = 0
            startY += cellSize
        }
    }
    
    func drawObjective(){
        resetStartingPoint()
        let color = board!.getObjective().0
        let position = board!.getObjective().1
        //THESE VALUES ARE "BACKWARDS" becuase UIVIEW has x going side to side, while I use x going up and down
        let xIndex = position % 100
        let yIndex = position / 100
        startX += cellSize * CGFloat(xIndex)
        startY += cellSize * CGFloat(yIndex)
        switch color {
        case RED:
            let img = UIImage(named: "RedTile.png")?.CGImage
            CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
            break
        case YELLOW:
            let img = UIImage(named: "YellowTile.png")?.CGImage
            CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
            break
        case BLUE:
            let img = UIImage(named: "BlueTile.png")?.CGImage
            CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
            break
        case GREEN:
            let img = UIImage(named: "GreenTile.png")?.CGImage
            CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
            break
        default:
            let img = UIImage(named: "YellowTile.png")?.CGImage
            CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), img)
        }
        
    }
    
    func resetStartingPoint(){
        startX = 0
        startY = 0
    }

}
