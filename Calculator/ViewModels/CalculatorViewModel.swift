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
    
    
}

//MARK: - API Calls
extension CalculatorViewModel {
    
       fileprivate func getAddressFromLatLong( lat: String, long: String,completion: @escaping()->()){
           WebSerivce().getRequest(endPoint: "address/\(lat)/\(long)") { (response: Location?) in
               if let location = response{
                    //Assign Location to respective object
               }else{
                   //throw error with custom message
               }
               completion()
           }
       }
       
       
       fileprivate func getCurrentBitCoinRate( amount: String,completion: @escaping()->()){
           WebSerivce().getRequest(endPoint: "rate/\(amount)") { (response: BitCoin?) in
               if let price = response{
                   //Assign Price to respective object
               }else{
                   //throw error with custom message
               }
               completion()
           }
       }
    
}


//MARK: - User Operations
extension CalculatorViewModel {
    
    fileprivate func performOperations() -> Double{
        
        return 0
    }
    
}


//MARK: - Expose Public Data
extension CalculatorViewModel{
    
    
    
}
