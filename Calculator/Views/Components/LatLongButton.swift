//
//  LatLongButton.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit

struct LatLongButtonDataModel{
    
    var type: Coordinates?
    var input: String?
}


class LatLongButton: UIButton {
    
     var placeHolder: String = ""
    
    //Set Color
    let btnColor: UIColor = .rgba(r: 20, g: 20, b: 20, a: 1)
    let titleColor: UIColor = .rgba(r: 200, g: 200, b: 200, a: 1)
    let selectedColor: UIColor = .rgba(r: 60, g: 60, b: 60, a: 1)
 
    var dataModel: LatLongButtonDataModel?{
        didSet{
            if let dataModel = self.dataModel{
                self.setTitle(dataModel.input, for: .normal)
             }else{
                self.setTitle(placeHolder, for: .normal)
            }
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(){
        
        self.noAutoConst()
        self.backgroundColor = btnColor
        self.layer.cornerRadius = 10
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 22)
        
     }
    
    func onStateChange(isSelected: Bool){
        
        self.backgroundColor = isSelected ? selectedColor : btnColor
        
    }
    
    
    
}

