//
//  graphController.swift
//  Calculator
//
//  Created by Seth Saperstein on 7/7/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class graphController: UIView {
    
    
    private var axes = AxesDrawer()
    
    var xVals : [Double] = []
    var yVals : [Double] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var pt : CGPoint? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    var rectSize : CGSize? = nil {
        didSet {
            //call this built in function to tell to redraw
            setNeedsDisplay()
        }
    }
    private var rectangle : CGRect? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var scaleDueToPinching : Double = 5.0 {
        didSet {
            if scaleDueToPinching < 2 {
                scaleDueToPinching = 2
            }
            else if scaleDueToPinching > 12 {
                scaleDueToPinching = 12
            }
            setNeedsDisplay()
        }
    }
    
    var moveDueToPanning : Double = 0.0 {
        didSet {
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        pt = CGPoint(x: bounds.midX, y: bounds.midY)
        rectSize = CGSize(width: bounds.width, height: bounds.height)
        rectangle = CGRect(origin: pt!, size: rectSize!)
        axes.color = UIColor.black
        axes.drawAxes(in: rectangle!, origin: pt!, pointsPerUnit: CGFloat(scaleDueToPinching))
        var counter = 0
        let path = UIBezierPath()
        while (counter < xVals.count - 1) {
            path.move(to: (CGPoint(x: bounds.midX + CGFloat((xVals[counter] * scaleDueToPinching)), y: bounds.midY - CGFloat((yVals[counter] * scaleDueToPinching)))))
            path.addLine(to: (CGPoint(x: bounds.midX + CGFloat((xVals[counter + 1] * scaleDueToPinching)), y: bounds.midY - CGFloat((yVals[counter + 1] * scaleDueToPinching)))))
            counter += 1
        }
        UIColor.black.setStroke()
        path.stroke()
    }
    
    func drawEquation() {

    }
    
    func pinchGest(byReactingTo pinchRec: UIPinchGestureRecognizer) {
        switch pinchRec.state {
        case .changed, .ended:
            scaleDueToPinching *= Double(pinchRec.scale)
            pinchRec.scale = 1
        default:
            break
        }
    }
    
}
