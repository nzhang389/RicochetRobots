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
    var board: Board?
    
    @IBOutlet weak var boardView: BoardView!
    let startPosition = CGPoint(x: 10, y: 10)


    required init?(coder aDecoder: NSCoder) {
        board = nil
        super.init(coder: aDecoder)
        initialize()

    }
    
    func initialize(){
        board = Board()
        for var x = 0; x < 8; x++ {
            for var y = 0; y < 8; y++ {
                //let tile =
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        boardView.board = board
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

