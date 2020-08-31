//
//  ButtonAttributes.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit


enum RemoteKeys: String{
    case isMap, isBtc, isDivide,isMultiply, isMinus,isPlus, plusMinus,percent, none
}


enum ButtonAttributes: String{
    
    case zero, one, two, three, four, five,six, seven, eight, nine
    case ac,plusminus,percent,divide,multiply,minus,plus,equal
    case decimal
    
    var title: String{
        switch self{
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .plusminus: return "+/-"
        case .percent: return "%"
        case .divide: return "÷"
        case .multiply: return "×"
        case .minus: return "-"
        case .plus: return "+"
        case .equal: return "="
        case .decimal: return "."
        default:
            return "AC"
        }
    }
    
    var backgroundColor : UIColor {
        switch self {
        case .zero, .one, .two, .three,.four, .five,.six, .seven, .eight, .nine, .decimal:
            return .rgba(r: 70, g: 70, b: 70, a: 1)
        case .ac, .plusminus, .percent:
            return .rgba(r: 130, g: 130, b: 130, a: 1)
        case .divide, .multiply, .plus, .minus, .equal:
            return .rgba(r: 239, g: 130, b: 30, a: 1)
        }
    }
    
    var isOperation: Bool{
         switch self {
            case .plusminus, .percent, .divide, .multiply, .plus, .minus, .equal:
               return true
            default:
                return false
           }
        }
 
    var SelectedColor : UIColor {
        switch self {
        case .zero, .one, .two, .three,.four, .five,.six, .seven, .eight, .nine, .decimal:
            return .rgba(r: 120, g: 120, b: 120, a: 1)
        case .ac, .plusminus, .percent:
            return .rgba(r: 200, g: 200, b: 200, a: 1)
        case .divide, .multiply, .plus, .minus, .equal:
            return .rgba(r: 225, g: 225, b: 225, a: 1)
            
        }
    }
    
    var textColor : UIColor {
        switch self {
        case .zero, .one, .two, .three,.four, .five,.six, .seven, .eight, .nine, .decimal:
            return .rgba(r: 225, g: 225, b: 225, a: 1)
        case .ac, .plusminus, .percent:
            return .rgba(r: 0, g: 0, b: 0, a: 1)
        case .divide, .multiply, .plus, .minus, .equal:
            return .rgba(r: 225, g: 225, b: 225, a: 1)
        }
    }
    
    var remoteKey: RemoteKeys{
 
        switch self {
 
        case .divide:
            return .isDivide
        case .multiply:
            return .isMultiply
        case .minus:
            return .isMinus
        case .plus:
            return .isPlus
        case .plusminus:
            return .plusMinus
        case .percent:
            return .percent
        default:
            return .none
        }
        
    }
    
    
}


