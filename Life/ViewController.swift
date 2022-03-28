//
//  ViewController.swift
//  Life
//
//  Created by Billy Ellis on 20/11/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var sizeStepper: UIStepper!
    
    var timer: Timer? = nil
    
    var cellWidth = 5
    
    var gridX = 400
    var gridY = 450

    var cells: [[UIView]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        
        sizeStepper.maximumValue = 20
        
        drawGrid()
        
    }
    
    func drawGrid() {
        gridX = 400 / cellWidth
        gridY = 500 / cellWidth
    
        for x in 0..<gridX {
            var row: [UIView] = []
            
            for y in 0..<gridY {
                let v = UIView(frame: CGRect(x: x*(cellWidth+1), y: 44 + (y*(cellWidth+1)), width: cellWidth, height: cellWidth));
                v.backgroundColor = .white
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(recognizer:)))
                v.addGestureRecognizer(tap)
                
                self.view.addSubview(v)
                
                row.append(v)
            }
            
            cells.append(row)
        }
    }
    
    func removeGrid() {
        // remove previous grid first
        for x in 0..<gridX {
            for y in 0..<gridY {
                cells[x][y].removeFromSuperview()
            }
        }
        cells.removeAll()
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        for x in 0..<gridX {
            for y in 0..<gridY {
                cells[x][y].backgroundColor = .white
            }
        }
    }
    
    @IBAction func sizeChanged(_ sender: UIStepper) {
        cellWidth = Int(5 + sender.value)
        removeGrid()
        drawGrid()
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        for x in 0..<gridX {
            for y in 0..<gridY {
                var color = UIColor.white
                // 10% of the time, spawn a live cell
                if Int.random(in: 0..<10) == 1 {
                    color = .black
                }
                cells[x][y].backgroundColor = color
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if startButton.titleLabel?.text == "Start" {
            startButton.setTitle("Stop", for: .normal)
            let speed = 1.0 - speedSlider.value
            
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(speed), repeats: true) { timer in
                
                for x in 1..<self.gridX-1 {
                    for y in 1..<self.gridY-1 {
                        
                        var neighbourCount = 0

                        for x_offset in -1...1 {
                            for y_offset in -1...1 {
                                // dont treat this is a neighbour, this is the
                                // cell we're checking the neighbours of
                                if !(x_offset == 0 && y_offset == 0) {
                                    if self.cells[x + x_offset][y + y_offset].backgroundColor == UIColor.black {
                                        neighbourCount += 1
                                    }
                                }
                            }
                        }
                        
                        if self.cells[x][y].backgroundColor == UIColor.white {
                            // if the cell is dead
                            
                            if neighbourCount == 3 {
                                // come alive
                                self.cells[x][y].tag = 1
                            }
                            
                            // otherwise stay dead
                            
                        } else {
                            // if the cell is alive
                            
                            if neighbourCount > 3 {
                                // die
                                self.cells[x][y].tag = 2
                            }
                            
                            if neighbourCount < 2 {
                                // die
                                self.cells[x][y].tag = 2
                            }
                            
                        }
                    }
                }
                
                // we use tags to represent the state change
                // because we need to perform the rules on all
                // cells at the same time.
                //
                // changing the state of one before the other
                // breaks the algorithm
                for x in 1..<self.gridX-1 {
                    for y in 1..<self.gridY-1 {
                        if self.cells[x][y].tag == 1 {
                            self.cells[x][y].backgroundColor = .black
                        } else if self.cells[x][y].tag == 2 {
                            self.cells[x][y].backgroundColor = .white
                        }
                        self.cells[x][y].tag = 0
                    }
                }
            }
        } else {
            startButton.setTitle("Start", for: .normal)
            timer!.invalidate()
        }
        
    }
    
    @objc func cellTapped(recognizer : UITapGestureRecognizer) {
        if recognizer.view?.backgroundColor == .black {
            recognizer.view?.backgroundColor = .white
        } else {
            recognizer.view?.backgroundColor = .black
        }
    }

}

