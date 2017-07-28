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
            let operation = CharacterSet(charactersIn: "+-×÷()")
            var tempString : String = String(describing: function)
            var counter = 0
            let operand = "+-×÷()"
            for char in tempString.characters {
                if operand.contains(String(char)) {
                    if (counter == 0) {
                        
                    }
                    else if (counter == tempString.characters.count - 1) {
                        
                    }
                    else {
                        
                    }
                }
            }
            dividedString = function?.components(separatedBy: operation)
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
    
    private func callAllOp(index : Int)->Double{
        var total : Double = 0
        var counter = index
        for variables in index..<(dividedString?.count)! {
            let sign = String(describing: dividedString?[variables])
            switch sign {
                case "+":
                    total += callAllOp(index: index + 1)
                case "-":
                    total -= callAllOp(index: index + 1)
                case "×":
                    total *= callAllOp(index: index + 1)
                case "÷":
                    total /= callAllOp(index: index + 1)
                case "(":
                    break
                case ")":
                    return total
                /*case "sin":
                    
                case "cos":
                    
                case "tan":
                    
                case "√":
                    */
                default:
                    total += Double(sign)!
            }
            counter += 1
        }
        return total
    }
    
    mutating func performGraphOperation(X : Double)->Double {
        let stringForm : String = String(X)
        function = function?.replacingOccurrences(of: "X", with: stringForm)
        /*
        var lastOpenPar : Int? = nil
        var counter = 0
        while (newEquation.contains("(")) {
            for char in newEquation.characters {
                if char == "(" {
                    lastOpenPar = counter
                }
                counter += 1
            }
            counter = 0
            if lastOpenPar != nil {
                var firstClosed = 0
                for char in newEquation.characters {
                    if ((counter > lastOpenPar!) && (char == ")")) {
                        firstClosed = counter
                    }
                    counter += 1
                }
 
        let start = newEquation.index(newEquation.startIndex, offsetBy: lastOpenPar!)
        let end = newEquation.index(newEquation.startIndex, offsetBy: firstClosed)
        let range = start..<end
        var subString = newEquation.substring(with: range)
        
        var dividedString = subString.components(separatedBy: operation)
        var total : Double = Double(dividedString[0])!
        var counter2 = 0
        */
        return callAllOp(index: 0)
        /*
        var total : Double = 0
        var counter = 0
        for variables in dividedString {
            switch variables {
                case "+":
                    
                case "-":
                    
                case "×":
                    
                case "÷":
                
                case "(":
                
                case ")":
                
                case "sin":
                
                case "cos":
                
                case "tan":
                
                case "√":
                
                default:
                    total += Double(variables)
            }
        }
        */
    }
    
};
