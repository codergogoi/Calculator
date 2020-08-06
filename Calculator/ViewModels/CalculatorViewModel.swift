//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit
 

class CalculatorViewModel {
    
    // essential private properties
    private var location: Location?
    private var bitCoin: BitCoin?
    
    private var currentNumber: String = ""
    private var lastNumber: String = ""
    private var currentOperation: ButtonAttributes = .ac
    private var buttons : [[ButtonAttributes]] = []
    
    private func setupDefaultFeatures(){
      buttons.append([.ac, .btc, .map, .divide])
      buttons.append([.seven,.eight, .nine, .multiply])
      buttons.append([.four,.five, .six, .minus])
      buttons.append([.one,.two, .three, .plus])
      buttons.append([.zero, .decimal, .cos, .sin, .equal])
  }
    
    init(){
        setupDefaultFeatures()
    }

}

//MARK: - API Calls
extension CalculatorViewModel {
    
    func getAddressFromLatLong( lat: String, long: String,completion: @escaping()->()){
        WebSerivce().getRequest(endPoint: "address/\(lat)/\(long)") { (response: Location?) in
            if let location = response{
                self.location = location
            }else{
                //throw error with custom message
            }
            completion()
        }
    }
    
    
    func getCurrentBitCoinRate( amount: String,completion: @escaping()->()){
        WebSerivce().getRequest(endPoint: "rate/\(amount)") { (response: BitCoin?) in
            if let price = response{
                self.bitCoin = price
            }else{
                //throw error with custom message
            }
            completion()
        }
    }
    
}


//MARK: - User Operations
extension CalculatorViewModel {
    
    func resetLastNumber(){
        self.lastNumber = ""
        self.currentNumber = ""
    }
    
    func currentOperation(dataModel: ButtonAttributes, completion: @escaping(_ number: String) ->()){
        
        var result = ""
        switch dataModel {
        case .divide, .multiply, .minus, .plus:
            self.currentOperation = dataModel
            result = lastNumber
        case .ac:
            self.currentOperation = .ac
            self.lastNumber = ""
            self.currentNumber = ""
            result = "0"
        case .equal:
            result = self.currentOperation != .btc ? self.formattedResult() : lastNumber
        case .btc:
            self.getCurrentBitCoinRate(amount: self.lastNumber.isEmpty ? "1" : self.lastNumber){
                completion(self.currentBitCoinRate)
            }
            self.lastNumber = ""
            self.currentNumber = ""
            
        default:
            
            if(currentOperation != .ac){
                if self.currentNumber.contains(".") && dataModel == .decimal{
                    return
                }
                self.currentNumber = self.currentNumber + dataModel.title
                result = currentNumber
            }else{
                if self.lastNumber.contains(".") && dataModel == .decimal{
                    return
                }
                self.lastNumber = self.lastNumber + dataModel.title
                result = lastNumber
            }
        }
        
        if(currentOperation != .btc){
            completion(result)
        }
        
    }
    
    
    fileprivate func formattedResult() -> String{
        
        let calculatedResulr = self.performOperations()
        
        if calculatedResulr.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(calculatedResulr))"
        }else{
            return "\(calculatedResulr)"
        }
    }
    
    
    fileprivate func performOperations() -> Double{
        
        guard let leftNumber = Double(self.lastNumber), let rightNumber = Double(self.currentNumber) else{
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
    
    var currentAddress: String{
        get{
            if let address = self.location?.address{
                return address
            }
            return ""
        }
    }
    
    var currentBitCoinRate: String {
        get{
            
            guard let rate = self.bitCoin?.price, let coins = self.bitCoin?.btc else {
                return ""
            }
            
            return "\(pluralize(coinValue: coins)) = \n $\(rate)"
        }
    }
    
    private func pluralize(coinValue: String) -> String{
        
        if let value = Int(coinValue) {
            return value > 1 ? "\(coinValue) Bitcoins" : "\(coinValue) Bitcoin"
        }
        return "\(coinValue) Bitcoin"
        
    }
     
    
}
