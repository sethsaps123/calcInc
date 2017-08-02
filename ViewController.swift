//
//  ViewController.swift
//  Calculator
//
//  Created by Eris  Llangos on 6/29/17.
//  Copyright © 2017 Eris  Llangos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var typedInGraphLabel : [String] = []
    private var typingNumber = false
    var lastInput : String? = nil
    var toControlGraph = graphController()
    @IBAction func clear(_ sender: UIButton) {
        typingNumber = false
        lastInput = nil
        displayLabel.text! = " "
        typedByUser = false
        typedInGraphLabel.removeAll()
    }
    
    //still have to fix typing number for this ****
    @IBAction func backspace(_ sender: UIButton) {
        if let text = displayLabel.text {
            displayLabel.text = String(text.characters.dropLast())
            lastInput = String(describing: text.characters.last)
            typedInGraphLabel.remove(at: typedInGraphLabel.endIndex - 1)
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
        typingNumber = false
        graphingMode = true
        displayLabel.text = " "
        lastInput = nil
        typedInGraphLabel.removeAll()
    }
    
    @IBAction func calcCalc(_ sender: UIButton) {
        typingNumber = false
        graphingMode = false
        lastInput = nil
        displayLabel.text = " "
        typedInGraphLabel.removeAll()
    }
    @IBAction func parenthesis(_ sender: UIButton) {
        if graphingMode {
            typingNumber = false
            let nums = String(displayLabel.text!)
            displayLabel.text = nums! + sender.currentTitle!
            lastInput = sender.currentTitle
            typedInGraphLabel.append(sender.currentTitle!)
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
                let dest = segue.destination as? graphSuperController
                dest?.functionToGraph = typedInGraphLabel
                 break
                
             default:
                break
            }
         }
     }
  
    @IBAction func graph(_ sender: UIButton) {
    }
    
    @IBAction func PressButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (typedByUser && !graphingMode){
            let currentDisplayed = displayLabel.text!
            displayLabel.text = currentDisplayed + digit
            lastInput = digit
        }
        else{
            let currentDisplayed = displayLabel.text!
            if (typingNumber) {
                var num = typedInGraphLabel.last!
                typedInGraphLabel.remove(at: typedInGraphLabel.endIndex - 1)
                num += sender.currentTitle!
                typedInGraphLabel.append(num)
            }
            else {
                lastInput = sender.currentTitle!
                typedInGraphLabel.append(sender.currentTitle!)
            }
            displayLabel.text = currentDisplayed + sender.currentTitle!
            typingNumber = true
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
            typingNumber = false
            if (sender.currentTitle! == "=") {
                displayLabel.text = "ERROR"
                lastInput = nil
                typedByUser = false
                
            }
            else {
                let nums = String(displayLabel.text!)
                displayLabel.text = nums! + sender.currentTitle!
                typedByUser = true
                lastInput = nums!
                typedInGraphLabel.append(sender.currentTitle!)
            }
        }
    }
    
    
    
}

