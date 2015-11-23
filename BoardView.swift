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
    var startX: CGFloat
    var startY: CGFloat
    var contentSize: CGFloat
    var cellSize: CGFloat
    var cellDict = [NSInteger:CGImageRef]()
    
    override func layoutSubviews() {
        board = Board()
        startX = 0
        startY = 0
        contentSize = frame.width
        cellSize = contentSize / CGFloat(16)
    }

    required init?(coder aDecoder: NSCoder) {
        board = Board()
        startX = 0
        startY = 0
        contentSize = 0
        cellSize = 0
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let image = UIImage(named: "BlankTile.png")?.CGImage
        let horizWall = UIImage(named: "HorizontalWall.png")?.CGImage
        let vertWall = UIImage(named: "VerticalWall.png")?.CGImage
        for var row = 0; row < 16; row++ {
            for var col = 0 ; col < 16; col++ {
                //remake the walls so i print them onto the grid after doing all the blank tiles
                CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize), image)
                //let hashValue = board!.boardArray[row, col].getHash()
                let currentTile = board![row,col]
                if(currentTile.up){
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize / 8), horizWall)
                }
                if(currentTile.down){
                    startY += cellSize
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize, height: cellSize / 8), horizWall)
                    startY -= cellSize
                }
                if(currentTile.left){
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize / 8, height: cellSize), vertWall)
                }
                //DRAWING RIGHT IS NOT WOKRING
                if(currentTile.right){
                    startX += cellSize * CGFloat(7.0/8.0)
                    CGContextDrawImage(context, CGRect(x: startX, y: startY, width: cellSize / 8, height: cellSize), vertWall)
                    startX -= cellSize * CGFloat(7.0/8.0)
                }
                startX += cellSize;
            }
            startX = 0;
            startY += cellSize;
        }
        
        
        
    }
    
    
    

}
