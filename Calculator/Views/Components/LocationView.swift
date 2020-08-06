//
//  LocationView.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit


enum Coordinates: String {
    case Lat, Long
}

class LocationView: UIView {
    
    var didTapLatLong:(()->())?
    
    var didTapFindAddress:((_ lat: String, _ long: String)->())?
    
    var currentInput: String = ""{
        didSet{
            
            if currentSelection  == .Lat {
                self.currentLatitude = currentInput
            }else{
                self.currentLongitude = currentInput
            }
        }
    }
    
    var currentAddress: String?{
        didSet{
            if let currentAddress = self.currentAddress {
                self.lblAddressDetails.text = currentAddress
            }
        }
    }
    
    var currentSelection: Coordinates = .Lat
    var currentLatitude: String = ""{
        didSet{
            self.updateCoordinates()
        }
    }
    var currentLongitude: String = ""{
        didSet{
            self.updateCoordinates()
        }
    }
    
    
    let btnLatitude: LatLongButton = {
       let btn = LatLongButton()
        btn.placeHolder = NSLocalizedString("placeholder_latitude", comment: "")
        btn.dataModel = nil
         return btn
    }()
    
    let btnLongitude: LatLongButton = {
          let btn = LatLongButton()
        btn.placeHolder = NSLocalizedString("placeholder_longitude", comment: "") 
        btn.dataModel = nil
         return btn
    }()
    
    let btnFind: LatLongButton = {
        let btn = LatLongButton()
        btn.titleLabel?.font = .systemFont(ofSize: 40)
        btn.setImage(#imageLiteral(resourceName: "find"), for: .normal)
        btn.backgroundColor = .rgba(r: 70, g: 70, b: 70, a: 1)
        return btn
    }()
    
    let lblAddressDetails: UILabel = {
        let lbl = UILabel()
        lbl.noAutoConst()
        lbl.font = .systemFont(ofSize: 30)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(){
        self.backgroundColor = .rgba(r: 25, g: 25, b: 25, a: 0.5)
        self.layer.cornerRadius = 20
        self.noAutoConst()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.noAutoConst()
        self.addSubview(stackView)
        self.addSubview(btnFind)
        
        btnFind.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        btnFind.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        btnFind.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btnFind.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.btnFind.leadingAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        
        stackView.addArrangedSubview(btnLatitude)
        stackView.addArrangedSubview(btnLongitude)
        btnLatitude.addTarget(self, action: #selector(onTapLatitude(_:)), for: .touchUpInside)
        btnLongitude.addTarget(self, action: #selector(onTapLongitude(_:)), for: .touchUpInside)
        btnFind.addTarget(self, action: #selector(onTapFindAddress(_:)), for: .touchUpInside)
        self.addSubview(lblAddressDetails)
        lblAddressDetails.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        lblAddressDetails.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lblAddressDetails.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        lblAddressDetails.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        self.toggleLatLong()
    }
    
    private func updateCoordinates(){
        
        if currentSelection == .Lat{
            btnLatitude.dataModel = LatLongButtonDataModel(type: .Lat, input: self.currentLatitude)
        }else{
            btnLongitude.dataModel = LatLongButtonDataModel(type: .Long, input: self.currentLongitude)
        }
    }
    
    
    @objc func onTapLatitude(_ sender: LatLongButton){
        self.currentSelection = .Lat
        self.didTapLatLong?()
        toggleLatLong()
     }
    
    
    @objc func onTapLongitude(_ sender: LatLongButton){
          self.currentSelection = .Long
            self.didTapLatLong?()
           toggleLatLong()

      }
    
    
    private func toggleLatLong(){
        btnLongitude.onStateChange(isSelected: currentSelection == .Long)
        btnLatitude.onStateChange(isSelected: currentSelection == .Lat)
    }
    
    @objc func onTapFindAddress(_ sender: LatLongButton){
        if self.currentLatitude.count > 0 && self.currentLongitude.count > 0 {
            self.currentAddress = NSLocalizedString("address_waiting", comment: "")
            self.didTapFindAddress?(self.currentLatitude, self.currentLongitude)
        }
        
    }
        
}


extension LocationView{
    
    func clearHistory(){
        self.currentLatitude = ""
        self.currentLongitude = ""
        self.currentAddress = NSLocalizedString("address_promprt", comment: "")
        self.btnLatitude.dataModel = nil
        self.btnLongitude.dataModel = nil
    }
    
}
