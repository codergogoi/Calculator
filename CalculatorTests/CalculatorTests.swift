//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by JAYANTA GOGOI on 8/4/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testCheckAddressWebService(){
        
        let viewModel = CalculatorViewModel()
        
        weak var lat_long_expectation = expectation(description: "lat_long_expectation")
        
        viewModel.getAddressFromLatLong(lat: "59.31", long: "18.06") {
            
            if viewModel.currentAddress.count > 0 {
                lat_long_expectation?.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if(error != nil){
                assertionFailure("Latitude and Longitude API failed with \(error?.localizedDescription ?? "error not readable")")
            }
        }
        
    }
    
    func testBitcoinWebservice(){
        
        let viewModel = CalculatorViewModel()
        
        weak var bitcoin_expectation = expectation(description: "bitcoin_expectation")
        
        viewModel.getCurrentBitCoinRate(amount: "1") {
            if viewModel.currentBitCoinRate.count > 0 {
                bitcoin_expectation?.fulfill()
            }
        }
        
        
        waitForExpectations(timeout: 10) { (error) in
            if(error != nil){
                assertionFailure("Bitcoin API failed with \(error?.localizedDescription ?? "error not readable")")
            }
        }
        
    }
    
    //MARK: - Calculation Operation test
    
    
    func testAddition(){
        
        let viewModel = CalculatorViewModel()
        
        viewModel.mockInputs(leftNumber: ButtonAttributes.two.title, rightNumber: ButtonAttributes.two.title,operation: .plus)
        
        viewModel.currentOperation(dataModel: .equal) { (result) in
            XCTAssertEqual(result, "4", "Addition Operation result shound 2 + 2 = 4")
        }
        
    }
    
    func testSubstraction(){
        
        let viewModel = CalculatorViewModel()
        
        viewModel.mockInputs(leftNumber: ButtonAttributes.five.title, rightNumber: ButtonAttributes.seven.title,operation: .minus)
        
        viewModel.currentOperation(dataModel: .equal) { (result) in
            XCTAssertEqual(result, "-2", "Substraction Operation result shound 5 - 7 = -2")
        }
        
    }
    
    func testMultiplication(){
        
        let viewModel = CalculatorViewModel()
        
        viewModel.mockInputs(leftNumber: ButtonAttributes.six.title, rightNumber: ButtonAttributes.two.title,operation: .multiply)
        
        viewModel.currentOperation(dataModel: .equal) { (result) in
            XCTAssertEqual(result, "12", "Multiplication Operation result shound 6 X 2 = 12")
        }
        
    }
    
    func testDivision(){
        
        let viewModel = CalculatorViewModel()
        
        let devident = ButtonAttributes.two.title + ButtonAttributes.zero.title
        
        viewModel.mockInputs(leftNumber: devident, rightNumber: ButtonAttributes.five.title,operation: .divide)
        
        viewModel.currentOperation(dataModel: .equal) { (result) in
            XCTAssertEqual(result, "4", "Division Operation result shound 20 / 5 = 5")
        }
        
    }
    
    
    func testSin(){
        
        let viewModel = CalculatorViewModel()
        
        let degrees = ButtonAttributes.nine.title + ButtonAttributes.zero.title
        viewModel.mockInputs(leftNumber: degrees, operation: .sin)
        
        viewModel.currentOperation(dataModel: .sin) { (result) in
            XCTAssertEqual(result, "1", "Sin Operation result shound bew 90 degrees = 1")
        }
        
    }
    
    func testCos(){
        
        let viewModel = CalculatorViewModel()
        
        let degrees = ButtonAttributes.three.title + ButtonAttributes.six.title + ButtonAttributes.zero.title
        viewModel.mockInputs(leftNumber: degrees, operation: .cos)
        
        viewModel.currentOperation(dataModel: .cos) { (result) in
            XCTAssertEqual(result, "1", "Cos Operation result shound bew 360 degrees = 1")
        }
        
    }
     
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
