//
//  ViewController.swift
//  tictactoe
//
//  Created by Thomas DiZoglio on 3/17/15.
//  Copyright (c) 2015 Thomas DiZoglio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Player: Int {
        
        case ComputerPlayer = 0, UserPlayer = 1
    }

    @IBOutlet weak var segNumPlayers: UISegmentedControl!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var imgView5: UIImageView!
    @IBOutlet weak var imgView6: UIImageView!
    @IBOutlet weak var imgView7: UIImageView!
    @IBOutlet weak var imgView8: UIImageView!
    @IBOutlet weak var imgView9: UIImageView!
    @IBOutlet weak var lblUserMessage: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentPlayer = Player.ComputerPlayer
    
    var plays = [Int:Int]()
    var done = false
    
    var singlePlayer = true
    
    var aiDeciding = false
    
    var ticTacImages = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            
            scrollView.scrollEnabled = true
            scrollView.contentSize = CGSize(width:800, height:400)
        }

        lblUserMessage.hidden = true

        ticTacImages = [imgView1, imgView2, imgView3, imgView4, imgView5, imgView6, imgView7 ,imgView8 ,imgView9]
        
        for imageView in ticTacImages {
            
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageClicked:"))
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Gesture Reocgnizer method
    func imageClicked(reco: UITapGestureRecognizer) {
        
        var imageViewTapped = reco.view as UIImageView
        
        println(plays[imageViewTapped.tag])
        println(aiDeciding)
        println(done)
        
        if plays[imageViewTapped.tag] == nil && !aiDeciding && !done {
            
            if (singlePlayer == true) {

                setImageForSpot(imageViewTapped.tag, player:.UserPlayer)
            }
            else {
                
                setImageForSpot(imageViewTapped.tag, player:currentPlayer)
                if (currentPlayer == .ComputerPlayer) {
                    
                    currentPlayer = .UserPlayer
                }
                else {
                    
                    currentPlayer = .ComputerPlayer
                }
            }
        }
        
        checkForWin()
        
        if (singlePlayer == true) {
            
            aiTurn()
        }
    }

    @IBAction func newGameButtonPressed(sender: AnyObject) {

        if (segNumPlayers.selectedSegmentIndex == 0) {
            
            singlePlayer = true
            lblUserMessage.text = "Singe Player"
        }
        else {
            
            singlePlayer = false
            lblUserMessage.text = "Two Player"
        }

        done = false
        lblUserMessage.hidden = true
        reset()
    }

    // Game Play selectors
    func reset() {
        
        plays = [:]
        imgView1.image = nil
        imgView2.image = nil
        imgView3.image = nil
        imgView4.image = nil
        imgView5.image = nil
        imgView6.image = nil
        imgView7.image = nil
        imgView8.image = nil
        imgView9.image = nil
    }

    func setImageForSpot(spot:Int,player:Player) {
        
        var playerMark = player == .UserPlayer ? "x" : "o"
        println("setting spot \(player.rawValue) spot \(spot)")
        plays[spot] = player.rawValue
        
        ticTacImages[spot].image = UIImage(named: playerMark)
    }
    
    func checkForWin() {
        
        // first row across
        var youWin = 1
        var theyWin = 0
        var whoWon = ["I":0,"you":1]
        var winner = 0
        
        for (key,value) in whoWon {

            // across the bottom
            if (plays[6] == value && plays[7] == value && plays[8] == value) {
            
                winner = 1
            }
            
            // across the middle
            if (plays[3] == value && plays[4] == value && plays[5] == value) {
            
                winner = 1
            }
            
            // across the top
            if (plays[0] == value && plays[1] == value && plays[2] == value) {
                
                winner = 1
            }
            
            // down the left side
            if (plays[6] == value && plays[3] == value && plays[0] == value) {
                
                winner = 1
            }
            
            // down the middle
            if (plays[7] == value && plays[4] == value && plays[1] == value) {
                
                winner = 1
           }
            
            // down the right side
            if (plays[8] == value && plays[5] == value && plays[2] == value) {
                
                winner = 1
            }

            // diagnoal
            if (plays[6] == value && plays[4] == value && plays[2] == value) {
                
                winner = 1
            }

            // diagnoal
            if (plays[8] == value && plays[4] == value && plays[0] == value) {
                
                winner = 1
           }
            
            if (winner == 1) {
                
                lblUserMessage.hidden = false
                lblUserMessage.text = "Looks like \(key) won!"
                done = true;
                
                var alert = UIAlertController(title: "Winner", message: "Looks like \(key) won!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return;
            }
        }
    }

    func checkBottom(#value:Int) -> [String] {
        
        return ["bottom",checkFor(value, inList: [6,7,8])]
    }
    
    func checkMiddleAcross(#value:Int) -> [String] {
        
        return ["middleHorz",checkFor(value, inList: [3,4,5])]
    }
    
    func checkTop(#value:Int) -> [String] {
        
        return ["top",checkFor(value, inList: [0,1,2])]
    }
    
    func checkLeft(#value:Int) -> [String] {
        
        return ["left",checkFor(value, inList: [0,3,6])]
    }
    
    func checkMiddleDown(#value:Int) -> [String] {
        
        return ["middleVert",checkFor(value, inList: [1,4,7])]
    }
    
    func checkRight(#value:Int) ->  [String] {
        
        return ["right",checkFor(value, inList: [2,5,8])]
    }
    
    func checkDiagLeftRight(#value:Int) ->  [String] {
        
        return ["diagRightLeft",checkFor(value, inList: [2,4,6])]
    }
    
    func checkDiagRightLeft(#value:Int) ->  [String] {
        
        return ["diagLeftRight",checkFor(value, inList: [0,4,8])]
    }
    
    func checkFor(value:Int, inList:[Int]) -> String {
        
        var conclusion = ""
        for cell in inList {
            
            if plays[cell] == value {
                
                conclusion += "1"
            } else {
                
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func checkThis(#value:Int) -> [String] {
        return ["right","0"]
    }
    
    func rowCheck(#value:Int) -> [String]? {
        
        var acceptableFinds = ["011","110","101"]
        var findFuncs = [self.checkThis]
        var algorthmResults = findFuncs[0](value: value)
        for algorthm in findFuncs {
            
            var algorthmResults = algorthm(value: value)
            var findPattern = find(acceptableFinds,algorthmResults[1])
            if findPattern != nil {
                
                return algorthmResults
            }
        }
        return nil
    }
    
    func isOccupied(spot:Int) -> Bool {
        
        println("occupied \(spot)")
        if plays[spot] != nil {
            
            return true
        }
        return false
    }
    
    func whereToPlay(location:String,pattern:String) -> Int {
        
        var leftPattern = "011"
        var rightPattern = "110"
        var middlePattern = "101"
        switch location {
            
        case "top":
            if pattern == leftPattern {
                
                return 0
            } else if pattern == rightPattern {
                
                return 2
            } else {
                
                return 1
            }
        case "bottom":
            if pattern == leftPattern {
                
                return 6
            } else if pattern == rightPattern {
                
                return 8
            } else {
                
                return 7
            }
        case "left":
            if pattern == leftPattern {
                
                return 0
            } else if pattern == rightPattern {
                
                return 6
            } else {
                
                return 3
            }
        case "right":
            if pattern == leftPattern {
                
                return 2
            } else if pattern == rightPattern {
                
                return 8
            } else {
                
                return 5
            }
        case "middleVert":
            if pattern == leftPattern {
                
                return 1
            } else if pattern == rightPattern {
                
                return 7
            } else {
                
                return 4
            }
        case "middleHorz":
            if pattern == leftPattern {
                
                return 3
            } else if pattern == rightPattern {
                
                return 5
            } else {
                
                return 4
            }
        case "diagLeftRight":
            if pattern == leftPattern {
                
                return 0
            } else if pattern == rightPattern {
                
                return 8
            } else {
                
                return 4
            }
        case "diagRightLeft":
            if pattern == leftPattern {
                
                return 2
            } else if pattern == rightPattern {
                
                return 6
            } else {
                
                return 4
            }
            
        default:
            return 4
        }
    }
    
    func firstAvailable(#isCorner:Bool) -> Int? {
        
        var spots = isCorner ? [0,2,6,8] : [1,3,5,7]
        for spot in spots {
            
            println("checking \(spot)")
            if !isOccupied(spot) {
                
                println("not occupied \(spot)")
                return spot
            }
        }
        return nil
    }
    
    
    
    func aiTurn() {
        
        if done {
            return
        }
        
        aiDeciding = true
        
        // We (the computer) have two in a row
        if let result = rowCheck(value: 0) {
            
            println("comp has two in a row")
            var whereToPlayResult = whereToPlay(result[0], pattern: result[1])
            if !isOccupied(whereToPlayResult) {
                
                setImageForSpot(whereToPlayResult, player: .ComputerPlayer)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        // They (the player) have two in a row
        if let result = rowCheck(value: 1) {
            
            var whereToPlayResult = whereToPlay(result[0], pattern: result[1])
            if !isOccupied(whereToPlayResult) {
                
                setImageForSpot(whereToPlayResult, player: .ComputerPlayer)
                aiDeciding = false
                checkForWin()
                return
            }
            
            // Is center available?
        }
        
        if !isOccupied(4) {
            
            setImageForSpot(4, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        
        if let cornerAvailable = firstAvailable(isCorner: true) {
            
            setImageForSpot(cornerAvailable, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        
        if let sideAvailable = firstAvailable(isCorner: false) {
            
            setImageForSpot(sideAvailable, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        
        lblUserMessage.hidden = false
        lblUserMessage.text = "Looks like it was a tie!"
        
        reset()
        
        println(rowCheck(value: 0))
        println(rowCheck(value: 1))
        
        aiDeciding = false
    }
}

