//
//  DrawView.swift
//  TouchTracker
//
//  Created by Crispin Lloyd on 01/01/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var boundingBoxes = [String : [NSValue : Line]]()
    
    
    //Integer varible to enable unique key for circleLines dictionaries contained within boundingBoxes dictionary
    var circleLinesCount: Int = 1
    
    //Create array of array to hold circleLinesPoints arrays
       var circleLinesPointsArray = [[CGPoint]]()
    
    //Create integer varible to count circleLinesPoints arrays
    var drawCircleLinesCount: Int = 0


    
    func stroke(_ rect: CGRect){
            
        
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        path.stroke()
    }
    
    override func draw(_ rect: CGRect){
        //Draw circles in black
        UIColor.black.setStroke()
       
        //Draw circles
       prepareCircleBoundingBoxes()
    
    
    }
    
    func prepareCircleBoundingBoxes() {
        
        //Create array to hold the begin and end values for the 2 lines in the circleLines bounding box
        var circleLinesPoints: [CGPoint] = []
        

        
        //Iterate through each circle bounding box in boundingBoxes and retieve the two lines and create a CGRect to pass to stroke function to draw the circle
         for (_, circleLines) in boundingBoxes {
            
            
            for (key, _) in circleLines {

                
                if let line = circleLines[key] {
                    
                    circleLinesPoints.append( line.begin)
                    circleLinesPoints.append(line.end)
                    
                    }

                }
             
            //Add array to circleLinesPointsArray, but check if it is the first item to be added
            if circleLinesPointsArray.isEmpty {
                
                circleLinesPointsArray = [circleLinesPoints]
                
            } else {
                
                circleLinesPointsArray.append(circleLinesPoints)
            }
            
            
            //Increment circleLinesCount counter
            drawCircleLinesCount += 1
            
         
        
            //Check that data is present before executing the rest of the procedure
            if circleLinesPoints.count > 0 {


                
                //Declare variables to hold the x, y, width and height arguments that will be passed to the CGRect initializer
                    var beginX, beginY, rectWidth, rectHeight: CGFloat

           
                    //See which x coordinate for the two begins has the greater value and choose the lesser value as the x argument for the CGRect
                    if circleLinesPoints[1].x > circleLinesPoints[3].x {
                        beginX = circleLinesPoints[3].x
                        
                    } else {
                        
                        beginX = circleLinesPoints[1].x
                        
                    }
                    
                    //See which y coordinate for the two begins has the greater value and choose the lesser value as the y argument for the CGRect
                    if circleLinesPoints[1].y > circleLinesPoints[3].y {
                        beginY = circleLinesPoints[3].y
                        
                    } else {
                        
                        beginY = circleLinesPoints[1].y
                        
                    }
                    
                    //See which x coordinate for the two ends has the greater value and then subtract the other value from that value to generate the width of the rect for the circle
                    if circleLinesPoints[1].x > circleLinesPoints[3].x {
                        rectWidth = circleLinesPoints[1].x - circleLinesPoints[3].x

                    } else {
                        
                        rectWidth = circleLinesPoints[3].x - circleLinesPoints[1].x

                    }
                    
                    //Set the height value for the rect to equal the width value so that the rect represents a square to which will give a circle rather than an ovoid
                    rectHeight = rectWidth
                
                    
                    //Create the GCRect within which to draw the circle
                    let circleRect: CGRect = CGRect(x: beginX, y: beginY, width: rectWidth, height: rectHeight)
                    
                    //pass circleRect to the stroke function to draw the circle
                    stroke(circleRect)
                }
            
            //Empty circleLinesPointsArray array
            circleLinesPointsArray.removeAll()
            
            //Empty circleLinesPoints array
            circleLinesPoints.removeAll()

            }
            
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        //Empty circleLinesPointsArray array
        //circleLinesPointsArray.removeAll()
        
        //Check if UITouches Set contains 2 UITouches or not
        if touches.count == 2 {
            
            //Log statement to see the order of events
            print(#function)

            
            //Create dictionary to hold parallel lines that will define the bounding box for each circle
            var circleLines = [NSValue: Line]()
            
            for touch in touches {
                let location = touch.location(in: self)
                
                //Record location
                print("The location is: \(location)")
                
                let newLine = Line(begin: location, end: location)
                
                let key = NSValue(nonretainedObject: touch)
                circleLines[key] = newLine
                
            }
             //Add the circleLines dictionary to the parent boundingBoxes dictionary that hold the circleLines dictionary
            boundingBoxes["circleLines \(circleLinesCount)"] = circleLines
                
            //Increment circleLinesCount for next circleLines dictionary
            circleLinesCount = circleLinesCount + 1
        
        }
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if touches.count == 2 {
            
        //Log statement to see the order of events
        print(#function)

            for touch in touches {
                let touchPosition = touch.location(in: self)
                print("The location is:\(touchPosition)")
                
                //Iterate through each circleLines dictionary within bounding boxes dictionary and match each touch to each line
                updateLineEnds(currentTouch: touch, boundingBoxDic: &boundingBoxes)
                
                    }
            }
        
        //Redraw the view
        setNeedsDisplay()

    }
    
    //Function to update end values within circleLines dictionaries within boundingBox dictionary
    func updateLineEnds (currentTouch: UITouch, boundingBoxDic: inout [String : [NSValue : Line]]) {
        
        let touchKey = NSValue(nonretainedObject: currentTouch)
        
            for (_, circleLines) in boundingBoxDic {
                

                        if var line = circleLines[touchKey]  {
                            
                            //Log line.end before update
                            var lineEnd = line.end
                            print("Line end: \(lineEnd)")

                            line.end = currentTouch.location(in: self)

                    
                    
                            //Log line.end post update
                            lineEnd = line.end
                            print("Line end: \(lineEnd)")
                                
                        }
                   }

    }
        
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Log statement to see the order of events
        print(#function)
        
        boundingBoxes.removeAll()
        
        setNeedsDisplay()
    }
    
}
