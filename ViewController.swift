//
//  ViewController.swift
//  Calculator
//
//  Created by Eris  Llangos on 6/29/17.
//  Copyright © 2017 Eris  Llangos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    var lastInput : String? = nil
    var toControlGraph = graphController()
    @IBAction func clear(_ sender: UIButton) {
        lastInput = nil
        displayLabel.text! = " "
        typedByUser = false
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if let text = displayLabel.text {
            displayLabel.text = String(text.characters.dropLast())
            lastInput = String(describing: text.characters.last)
        }
        if (displayLabel.text?.isEmpty)! {
            displayLabel.text = " "
        }
    }
    
    @IBOutlet weak var displayLabel: UILabel!
    var typedByUser : Bool = false
    
    private var graphingMode = false
    private var model = CalculatorModel()
    
    @IBAction func graphCalc(_ sender: UIButton) {
        graphingMode = true
        displayLabel.text = " "
        lastInput = nil
    }
    
    @IBAction func calcCalc(_ sender: UIButton) {
        graphingMode = false
        displayLabel.text = " "
    }
    @IBAction func parenthesis(_ sender: UIButton) {
        if graphingMode {
            let nums = String(displayLabel.text!)
            displayLabel.text = nums! + sender.currentTitle!
            lastInput = sender.currentTitle
        }
    }
   
    
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?)->Bool {
        if let ident = identifier {
            switch ident{
            case "toGraph":
                if lastInput == nil {
                    displayLabel.text = "ERROR GRAPHING"
                    return false
                }
                else if (!model.canEnd(sign: lastInput!)) {
                    displayLabel.text = "ERROR GRAPHING"
                    return false
                }
                else {
                    return true
                }
            default:
                return true
            }
        }
        return true
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let identifier = segue.identifier {
             switch identifier {
             case "toGraph":
                break
                 if let vc = segue.destination as? graphController {
                 //set things up for the graph here
                    //toControlGraph.drawEquation()
 
                 }
                
             default:
                break
            }
         }
     }

 
    @IBAction func graph(_ sender: UIButton) {
        let function : String = displayLabel.text!
        model.function = function
        print(model.performGraphOperation(X: 2))
    }
  
    
    @IBAction func PressButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (typedByUser){
            let currentDisplayed = displayLabel.text!
            displayLabel.text = currentDisplayed + digit
            lastInput = digit
        }
        else{
            displayLabel.text = digit
            typedByUser = true
            lastInput = digit
        }
    }
    
    var DisplayOperations : Double{
        get{
            return Double(displayLabel.text!)!
        }
        set{
            displayLabel.text = String(newValue)
        }
    }
    
    
    @IBAction func operations(_ sender: UIButton) {
        if !graphingMode {
            if typedByUser {
                model.setOperand(DisplayOperations)
                typedByUser = false
            }
            if let symbol = sender.currentTitle {
                model.performOperation(symbol)
            }
            if let result = model.result{
               DisplayOperations = result
            }
        }
        else if graphingMode {
            if (sender.currentTitle! == "=") {
                displayLabel.text = "ERROR"
                lastInput = nil
                typedByUser = false
                
            }
            else {
                let currentDisplayed = displayLabel.text!
                displayLabel.text = currentDisplayed + sender.currentTitle!
                lastInput = sender.currentTitle!
            }
        }
    }
    
    
    
}

