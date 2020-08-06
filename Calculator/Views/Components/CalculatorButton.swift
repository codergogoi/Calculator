//
//  CalculatorButton.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    
    var dataModel: ButtonAttributes?{
        didSet{
            if let dataModel = dataModel{
                self.setTitle(dataModel.title, for: .normal)
                self.backgroundColor = dataModel.backgroundColor
                self.setTitleColor(dataModel.textColor, for: .normal)
                
            }
        }
    }
    
    var didTap:((ButtonAttributes)->())?
    
    private var isPressed = false
    private var isToggle = false
    
    private var supportToggle: Bool{
        get{
            if let dataModel = self.dataModel{
                switch dataModel {
                case .divide, .multiply, .minus, .plus, .map:
                    return true
                default:
                    return false
                }
            }
            return false;
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

//MARK: - UI Setup

extension CalculatorButton {
    
    fileprivate func setupViews(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 20
         let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapToChangeColor(gesture:)))
        self.addGestureRecognizer(gesture)
        self.titleLabel?.font = .systemFont(ofSize: 30)
    }
}


//MARK: - Tap Animations
extension CalculatorButton {
    
    
    @objc fileprivate func onTapToChangeColor(gesture: UILongPressGestureRecognizer){
        
        if supportToggle {
            return
        }
        
        if gesture.state == .began {
            isPressed = true
        } else if gesture.state == .ended
        {
            isPressed = false
        }
        self.pressedAnimation()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         isPressed = true
        isToggle = !isToggle
        self.pressedAnimation()
        if let dataModel = self.dataModel{
            self.didTap?(dataModel)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPressed = false
        self.pressedAnimation()
    }
    
    
    fileprivate func pressedAnimation(){
        
        if(self.supportToggle){
            if isToggle{
                self.backgroundColor =  self.dataModel?.SelectedColor
                self.setTitleColor(self.dataModel?.backgroundColor, for: .normal)
            }else{
                self.backgroundColor = self.dataModel?.backgroundColor
                self.setTitleColor(self.dataModel?.textColor, for: .normal)
            }
        }else{
            if isPressed{
                self.backgroundColor = self.dataModel?.SelectedColor
            }else{
                UIView.animate(withDuration: 0, animations: {
                    self.backgroundColor = self.dataModel?.backgroundColor
                }, completion: nil)
            }
            
        }
        
     }
}

//MARK: - Reset Toggle
extension CalculatorButton {
    
    func resetToggle(){
        self.isToggle = false
        self.pressedAnimation()
    }
    
}
