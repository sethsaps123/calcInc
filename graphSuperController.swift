//
//  graphSuperController.swift
//  Calculator
//
//  Created by Seth Saperstein on 7/7/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import Foundation
import UIKit

class graphSuperController : UIViewController {
    
    private var xPoints : [Double] = []
    private var yPoints : [Double] = []
    
    var functionToGraph : [String] = [] {
        didSet {
            var i = 1
            let valueOfLeftSide = 100.0
            let intervals : Double = valueOfLeftSide / 100.0
            var firstPt = -(valueOfLeftSide)
            xPoints.append(Double(firstPt))
            while(i < 200) {
                firstPt += intervals
                xPoints.append(firstPt)
                i += 1
            }
            operateFunction()
        }
    }
    
    private func operateFunction() {
        var model = CalculatorModel()
        model.functionToGraph = self.functionToGraph
        model.xVals = xPoints
        yPoints = model.yVals
        
        
        return
    }

    private var size : CGFloat? = nil
    
    
    
    @IBAction func panGesture(_ sender: Any) {
        let sentFrom = sender as? UIPanGestureRecognizer
        self.view.center.equalTo((sentFrom?.location(in: self.view))!)
    }
    
    @IBOutlet weak var graph: graphController! {
        didSet {
            let handler = #selector(graph.pinchGest(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graph, action: handler)
           
            graph.addGestureRecognizer(pinchRecognizer)
            graph.xVals = xPoints
            graph.yVals = yPoints
        }
    }
    
    
}
