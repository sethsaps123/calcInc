//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Eris  Llangos on 6/29/17.
//  Copyright © 2017 Eris  Llangos. All rights reserved.
//

import Foundation
import UIKit

fileprivate func changeSign(op: Double) -> Double {
    return -op
}

fileprivate func multiply (op1: Double, op2: Double) -> Double {
    return op1 * op2
}

fileprivate func add (op1: Double, op2: Double) -> Double {
    return op1 + op2
}

fileprivate func subtract (op1: Double, op2: Double) -> Double {
    return op1 - op2
}

fileprivate func divide (op1: Double, op2: Double) -> Double {
    return op1 / op2
}
struct CalculatorModel{
    
    private enum operationsTypes {
        case const(Double)
        case unaryOps((Double)->Double)
        case binaryOps((Double, Double)->Double)
        case equals
    }
    
    private var endings : Dictionary<String, Bool> = [
    "√" : false,
    "cos" : false,
    "sin" : false,
    "tan" : false,
    "±" : false,
    "+" : false,
    "-" : false,
    "×" : false,
    "÷" : false,
    "=" : false
    ]
    
    func canEnd(sign : String)->Bool {
        if endings.index(forKey: sign) == nil {
            return true
        }
        else {
            return false
        }
    }
    
    
    
    private var operations: Dictionary<String, operationsTypes> =
    [
        "π" : operationsTypes.const(Double.pi),
        "e" : operationsTypes.const(M_E),
        "√" : operationsTypes.unaryOps(sqrt),
        "cos" : operationsTypes.unaryOps(cos),
        "sin" : operationsTypes.unaryOps(sin),
        "tan" : operationsTypes.unaryOps(tan),
        "±" : operationsTypes.unaryOps(changeSign),
        "+" : operationsTypes.binaryOps(add),
        "-" : operationsTypes.binaryOps(subtract),
        "×" : operationsTypes.binaryOps(multiply),
        "÷" : operationsTypes.binaryOps(divide),
        "=" : operationsTypes.equals
    ]
    
    var result : Double? {
        
        get{
            return accumulator
        }
    }
    
    var function : String? = nil {
        didSet {
            
        }
    }
    
    var dividedString : [String]? = nil
    
    
    private var accumulator : Double?
    
    mutating func performOperation (_ symbol: String){
        if let operation = operations[symbol] {
            switch operation{
            case .const(let val):
                accumulator = val
                
            case .unaryOps(let f):
                if (accumulator != nil){
                    accumulator = f(accumulator!)
                }
            case .binaryOps(let f):
                if accumulator != nil{
                    operationPerformance = pendingBinary(function: f, firstOp: accumulator!)
                    accumulator = nil
                }
                
            case .equals:
               opEqual()
            }
        }
        
    }
    mutating private func opEqual (){
        if operationPerformance != nil && accumulator != nil{
            accumulator = operationPerformance!.perform(with: accumulator!)
            operationPerformance = nil
        }
    }
    private struct pendingBinary{
        let function: (Double, Double)->Double
        let firstOp : Double
        
        func perform (with secondOp: Double)->Double{
            return function(firstOp, secondOp)
        }
    }
    
    private var operationPerformance: pendingBinary?
    
    mutating func setOperand (_ operand: Double){
        accumulator = operand
    }
    
    private func allOperands (Op : String, Num1 : Double, Num2 : Double)->Double {
        switch Op {
            case "+":
                return add(op1: Num1, op2: Num2)
            case "-":
                return subtract(op1: Num1, op2: Num2)
            case "×":
                return multiply(op1: Num1, op2: Num2)
            case "÷":
                return divide(op1: Num1, op2: Num2)
            default:
                print("Broke in all operands func")
                exit(1)
        }
    }
    
    var functionToGraph : [String]? = nil
    
    struct pair {
        var total : Double
        var indexWentTill: Int
    }
    var yVals : [Double] = []
    
    var xVals : [Double] = [] {
        didSet {
            getYVals()
        }
    }
    private mutating func getYVals() {
        for x in xVals {
            indexCurrentlyOn = -1
            hitLast = false
            currentXVal = x
            yVals.append(performGraphOperation())
        }
    }
    private var indexCurrentlyOn : Int = -1
    private var currentXVal : Double? = nil
    private var currentOpenPar : [Int] = []
    private var hitClosedPar = false
    private var hitLast = false
    
    mutating func performGraphOperation()->Double {
        var total : Double = 0
        var counter = 0
        for variables in functionToGraph! {
            switch variables {
            case "+":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total += performGraphOperation()
                if hitClosedPar {
                    return total
                }
            case "-":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total -= performGraphOperation()
                if hitClosedPar {
                    return total
                }
                
            case "×":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total *= performGraphOperation()
                if hitClosedPar {
                    return total
                }
            case "÷":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total /= performGraphOperation()
                if hitClosedPar {
                    return total
                }
            case "(":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total += performGraphOperation()
                hitClosedPar = false
                break
            case ")":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                hitClosedPar = true
                return total
            case "sin":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total = sin(performGraphOperation())
                
            case "cos":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total = cos(performGraphOperation())
            case "tan":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total = tan(performGraphOperation())
            case "√":
                if counter <= indexCurrentlyOn {
                    break
                }
                indexCurrentlyOn = counter
                total = sqrt(performGraphOperation())
            case "X":
                if counter <= indexCurrentlyOn {
                    break
                }
                total += currentXVal!
            default:
                if counter <= indexCurrentlyOn {
                    break
                }
                total += Double(variables)!
            }
            counter += 1
            if hitLast {
                return total
            }
        }
        hitLast = true
        
        return total
    }
};
