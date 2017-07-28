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
    
    @IBOutlet weak var graph: graphController! {
        didSet {
            let handler = #selector(graph.pinchGest(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graph, action: handler)
            graph.addGestureRecognizer(pinchRecognizer)
        }
    }
    
    
    
}
