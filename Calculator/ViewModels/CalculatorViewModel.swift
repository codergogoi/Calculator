//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit

class CalculatorViewModel {
    
    
    private var rightNumber: String = ""
    private var leftNumber: String = ""
    private var currentOperation: ButtonAttributes = .ac
    private var buttons : [[ButtonAttributes]] = []
    
    private func setupDefaultFeatures(){
        buttons.append([.ac, .plusminus, .percent, .divide])
        buttons.append([.seven,.eight, .nine, .multiply])
        buttons.append([.four,.five, .six, .minus])
        buttons.append([.one,.two, .three, .plus])
        buttons.append([.zero, .decimal, .equal])
    }
    
    init(){
        setupDefaultFeatures()
        self.leftNumber = ""
    }
    
}



//MARK: - User Operations
extension CalculatorViewModel {
    
    func resetLastNumber(){
        self.leftNumber = ""
        self.rightNumber = ""
    }
    // first collect numbers to left
    
    func currentOperation(dataModel: ButtonAttributes, completion: @escaping(_ number: String, _ isToggle: Bool) ->()){
        
        var result = ""
        var toggle = false
        
        switch dataModel {
        case .divide, .multiply, .minus, .plus:
            //check if same operation exist
                self.currentOperation = dataModel
                if self.rightNumber.isEmpty {
                    result = self.leftNumber
                    return
                }
                result = self.formattedResult()
                self.leftNumber = result
                self.rightNumber = ""
          case .equal:
            if self.rightNumber.isEmpty{
                self.rightNumber = self.leftNumber
            }
            result = self.formattedResult()
            self.leftNumber = result
            toggle = true
        case .ac:
            self.currentOperation = .ac
            self.leftNumber = ""
            self.rightNumber = ""
            result = "0"
            toggle = true
        case .plusminus:
             if self.currentOperation.isOperation{
                self.rightNumber = self.togglePositiveNagetive(number: self.rightNumber)
                result = self.rightNumber
            }else{
                 self.leftNumber = self.togglePositiveNagetive(number: self.leftNumber)
                result = self.leftNumber
            }
            toggle = true
        case .percent:
            if self.currentOperation.isOperation{
                  self.rightNumber = self.getPercentage(number: self.rightNumber)
                  result = self.rightNumber
              }else{
                   self.leftNumber = self.getPercentage(number: self.leftNumber)
                  result = self.leftNumber
              }
              toggle = true
        default:
            if self.currentOperation.isOperation{
                toggle = true
                if self.rightNumber.contains(".") && dataModel == .decimal{
                    return
                }
                self.rightNumber.append(dataModel.title)
                result = rightNumber
                
            }else{
                 if self.leftNumber.contains(".") && dataModel == .decimal{
                    return
                }
                self.leftNumber.append(dataModel.title)
                result = leftNumber
            }
            
        }
        
        completion(result,toggle)
        
        
    }
    
    fileprivate func getPercentage(number: String)-> String{
         if let percent = Double(number){
            return self.formatNumber(number: percent * 0.01)
        }
        
        return  number
    }
    
    
    
    
    fileprivate func togglePositiveNagetive(number: String)-> String{
        // - TODO: - Need to check for zero plus minus
        if let toggleNumber = Double(number){
             return self.formatNumber(number: -toggleNumber)
        }
        
        return  number
    }
    
    
    fileprivate func formatNumber(number: Double) -> String{
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
           return "\(Int(number))"
        }
        return "\(number)"
      
    }
    
    
    fileprivate func formattedResult() -> String{
        
        let calculatedResult: Double = self.performOperations()
        return self.formatNumber(number: calculatedResult)
        
       
    }
    
    
    fileprivate func performOperations() -> Double{
        
        guard let leftNumber = Double(self.leftNumber), let rightNumber = Double(self.rightNumber) else{
            return 0
        }
        
        var result: Double = 0.0
        
        switch self.currentOperation {
        case .divide:
            result = leftNumber / rightNumber
        case .multiply:
            result = leftNumber * rightNumber
        case .minus:
            result = leftNumber - rightNumber
        case .plus:
            result = leftNumber + rightNumber
        default:
            return 0
        }
        return result
        
    }
    
    
}


//MARK: - Expose Public Data
extension CalculatorViewModel{
    
    func options() -> [[ButtonAttributes]]{
        return self.buttons
    }
     
    
    
}
//MARK: - UnitTest Input
extension CalculatorViewModel{
    
    func mockInputs(leftNumber: String = "0", rightNumber: String = "0", operation: ButtonAttributes){
        self.leftNumber = leftNumber
        self.rightNumber = rightNumber
        self.currentOperation = operation
    }
    
}
