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
    private var pt : CGPoint? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    private var rectSize : CGSize? = nil {
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
    
    var graphSize : CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        pt = CGPoint(x: bounds.midX, y: bounds.midY)
        rectSize = CGSize(width: bounds.width, height: bounds.height)
        rectangle = CGRect(origin: pt!, size: rectSize!)
        axes.color = UIColor.black
        axes.drawAxes(in: rectangle!, origin: pt!, pointsPerUnit: graphSize)
        print (graphSize)
        //draw a line
        //x is 100 / graphSize
        //y is
        let path = UIBezierPath()
        var counter = 0
        //while counter < 50 {
            //let yValue =
           // let xValue = bounds.midX +
                
            path.move(to: (CGPoint(x: bounds.minX, y: bounds.midY + 100)))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY + 100))
            UIColor.black.setStroke()
            path.stroke()
       // }
    }
    
    func drawEquation() {
        /*
        let rectangle = CGRect(x: bounds.midX, y: bounds.midY, width: 20, height: 20)
        let line = UIBezierPath(rect: rectangle)
        UIColor.black.setStroke()
        line.stroke()
        setNeedsDisplay()
         */
    }
    
    func pinchGest(byReactingTo pinchRec: UIPinchGestureRecognizer) {
        switch pinchRec.state {
        case .changed, .ended:
                graphSize *= pinchRec.scale
                pinchRec.scale = 1
        default:
            break
        }
    }
 
    
    
}
