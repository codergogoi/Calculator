//
//  AppAlert.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit

class AppAlert: UIView {
    
    var didTapOk:(()->())?
     var message: String = "" // set other error Message when requires
 
    let lblMessage: UILabel = {
        let lbl = UILabel()
        lbl.noAutoConst()
        lbl.font = .systemFont(ofSize: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = NSLocalizedString("error_message_connectivity", comment: "")
        lbl.textColor = .rgba(r: 200, g: 200, b: 200, a: 1)
        lbl.textAlignment  = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupView(){
        self.backgroundColor = .rgba(r: 40, g: 40, b: 40, a: 1)
        self.layer.cornerRadius = 20
        self.noAutoConst()
        
        let btnOkay = LatLongButton()
        btnOkay.setTitle(NSLocalizedString("action_ok", comment: ""), for: .normal)
        self.addSubview(lblMessage)
        self.addSubview(btnOkay)
        
        btnOkay.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnOkay.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnOkay.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        btnOkay.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        btnOkay.addTarget(self, action: #selector(onTapOk(_:)), for: .touchUpInside)
        
        lblMessage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        lblMessage.bottomAnchor.constraint(equalTo: btnOkay.topAnchor, constant: -10).isActive = true
        lblMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        lblMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    
    @objc private func onTapOk(_ sender: LatLongButton){
        didTapOk?()
    }
    
    
    
}
