//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var viewModel: CalculatorViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.viewModel = CalculatorViewModel()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
