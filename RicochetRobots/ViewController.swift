//
//  ViewController.swift
//  RicochetRobots
//
//  Created by Nathan Zhang on 10/28/15.
//  Copyright © 2015 Nathan Zhang. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
   // var board: Board?
    
    var colorSelected = 0
    
    @IBAction func colorSelection(sender: UIButton) {
        switch sender.currentTitle! {
        case "Red" :
            colorSelected = RED
            break
        case "Blue" :
            colorSelected = BLUE
            break
        case "Yellow" :
            colorSelected = YELLOW
            break
        case "Green" :
            colorSelected = GREEN
            break
        default:
            break
        }
    }
    
    
    @IBAction func directionEntered(sender: UIButton) {
        switch sender.currentTitle! {
        case "Up" :
            boardView.moveInDirection(colorSelected, dir: UP)
            break
        case "Down" :
            boardView.moveInDirection(colorSelected, dir: DOWN)
            break
        case "Left" :
            boardView.moveInDirection(colorSelected, dir: LEFT)
            break
        case "Right" :
            boardView.moveInDirection(colorSelected, dir: RIGHT)
            
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBAction func newBoard(sender: UIButton) {
        boardView.newBoard()
    }
    
    @IBAction func newObjective(sender: UIButton) {
        boardView.newObjectives()
    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        board = nil
//        super.init(coder: aDecoder)
//        initialize()
//
//    }

    override func viewDidLayoutSubviews() {
//        boardView.board =
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

