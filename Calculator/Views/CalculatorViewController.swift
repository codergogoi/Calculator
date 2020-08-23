//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit
import Network
import Firebase


class CalculatorViewController: UIViewController {
    
    //MARK: - UI Components
    let resultView: UIView = {
        let view = UIView()
        view.noAutoConst()
        return view
    }()
    
    let contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.noAutoConst()
        contentView.backgroundColor = .yellow
        contentView.axis = .vertical
        contentView.distribution = .fillEqually
        return contentView
    }()
    
    let lblResult: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 60)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byCharWrapping
        lbl.noAutoConst()
        lbl.text = "0"
        lbl.textAlignment = .right
        return lbl
    }()
    
    // Location View for Address Display
    let locationView = LocationView()
    var onLocationOperation = false
    var locationViewIntialTransform: CGAffineTransform?
    
    //alert View
    let alert = AppAlert()
    
    var alertTransform: CGAffineTransform?
    var isShowAlert = false{
        didSet{
            self.onShowHideAlert()
        }
    }
    
    
    //ViewModel
    fileprivate var viewModel: CalculatorViewModel?
    
    
    //Others
    var monitor: NWPathMonitor?
    
    var isIntenetAvailable = false
    private let spacing: CGFloat = 10
    var lastNumber: Double = 0
    var currentNumber: Double = 0
    var lastSelectedOperator: CalculatorButton?
    
    
    //MARK: - FireBase
    var remoteConfig: RemoteConfig?
    
    private func setupRemoteConfigDefaults(){
        let defaultValues = [
            RemoteKeys.isMap.rawValue : true as NSObject,
            RemoteKeys.isBtc.rawValue: true as NSObject,
            RemoteKeys.isDivide.rawValue: true as NSObject,
            RemoteKeys.isMultiply.rawValue: true as NSObject,
            RemoteKeys.isMinus.rawValue: true as NSObject,
            RemoteKeys.isPlus.rawValue: true as NSObject,
            RemoteKeys.isCos.rawValue: true as NSObject,
            RemoteKeys.isSign.rawValue: true as NSObject,
        ]
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.setDefaults(defaultValues)
    }
    
    private func fetchRemoteConfig(){
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        remoteConfig?.fetchAndActivate { [weak self] (status, error) in
            if status == .successFetchedFromRemote {
                self?.remoteConfig?.activate { (changed, error) in
                    DispatchQueue.main.async {
                        self?.onSetupToggleFunctions()
                    }
                }
            }

        }
    }
    
    //MARK: - Check Connectivity
    private func checkInternetConnection(){
        monitor?.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isIntenetAvailable = true
            }else{
                self?.isIntenetAvailable = false
            }
        }
    }
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.viewModel = CalculatorViewModel()
        self.setupRemoteConfigDefaults()
        self.fetchRemoteConfig()
        self.setupViews()
        self.onSetupToggleFunctions()
        monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor?.start(queue: queue)
        checkInternetConnection()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        fatalError("Touch not responding... fake news!")
//    }
     
    
    deinit {
        print("================================")
        print("Deinit Successfully: No retain cycle detected! :)")
        print("================================")

    }
}



//MARK: - UI Setup
extension CalculatorViewController {
    
    
    fileprivate func setupViews(){
        
        self.view.addSubview(resultView)

        self.contentView.spacing = spacing
        self.view.addSubview(contentView)

        resultView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        resultView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        resultView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        resultView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35, constant: 0).isActive = true

        resultView.addSubview(lblResult)
        lblResult.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: spacing).isActive = true
        lblResult.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -spacing).isActive = true
        lblResult.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -spacing).isActive = true

        contentView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: spacing).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        
        if let options = self.viewModel?.options(){
            for row in options {
                let stackView = UIStackView()
                stackView.noAutoConst()
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.spacing = spacing
                contentView.addArrangedSubview(stackView)
                for button in row{
                    let btn = CalculatorButton()
                    btn.dataModel = button
                    btn.didTap = {[weak self] dataModel in
                        self?.didTapButton(dataModel: dataModel)
                        //reset View Logic
                        switch dataModel {
                        case .divide,.multiply, .minus, .plus:
                            self?.lastSelectedOperator = btn
                        default:
                            return
                        }
                    }
                    stackView.addArrangedSubview(btn)
                }
            }
        }

 
        self.setupLocationView()
        self.setupAlertView()
        
    }
    
    
    
    fileprivate func setupLocationView(){
        
        self.resultView.addSubview(locationView)
        locationView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
        locationView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor).isActive = true
        locationView.topAnchor.constraint(equalTo: resultView.topAnchor).isActive = true
        locationView.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -spacing).isActive = true
        self.locationViewIntialTransform = self.locationView.transform
        self.locationView.transform =  locationView.transform.translatedBy(x: locationView.transform.tx, y: -500)
        locationView.didTapLatLong = {[weak self] in
            guard let self = self else {
                return
            }
            self.viewModel?.resetLastNumber()
          }

        locationView.didTapFindAddress = { [weak self] (lat, long) in
            
            guard let self = self else { return }
            
             self.viewModel?.getAddressFromLatLong(lat: lat, long: long, completion: { [weak self] in
                
                if let self = self{
                    let currentAddress = self.viewModel?.currentAddress
                    self.locationView.currentAddress = currentAddress
                    Analytics.logEvent("address_search", parameters: ["lat": lat, "long": long, "address": currentAddress ?? "Invalid Lat long used to search Address" ])
                }
             
           })
              
        }
        
    }
    
    fileprivate func setupAlertView(){
        resultView.addSubview(alert)
        alert.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
        alert.trailingAnchor.constraint(equalTo: resultView.trailingAnchor).isActive = true
        alert.topAnchor.constraint(equalTo: resultView.topAnchor).isActive = true
        alert.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -spacing).isActive = true
        self.alertTransform = alert.transform
        self.alert.transform =  alert.transform.translatedBy(x: alert.transform.tx, y: -500)
        self.alert.didTapOk = {[weak self] in
            guard let self = self else { return }
            self.isShowAlert = false
        }
 
    }
    
    fileprivate func onSetupToggleFunctions(){
        
        _ = self.contentView.subviews.compactMap { (stackView) -> UIStackView? in
             for button  in stackView.subviews{
                if let currentButton = button as? CalculatorButton{
                    if let key = currentButton.dataModel?.remoteKey{
                        if key != .none{
                            if let status = self.remoteConfig?.configValue(forKey: key.rawValue).boolValue{
                                if !status{
                                     currentButton.removeFromSuperview()
                                }
                            }
                         }
                    }
                }
            }
            return nil
        }
        
    }
    
}



//MARK: - User Operations
extension CalculatorViewController {
    
    //On Tap Calculator Buttons
    fileprivate func didTapButton(dataModel: ButtonAttributes){
        
        
        if self.isShowAlert{
            self.isShowAlert = false
        }
        
        switch dataModel {
        case .map:
            if !self.isIntenetAvailable  {
                self.isShowAlert = true
                return
            }
            
            self.locationView.clearHistory()
            onTapMap()
            Analytics.logEvent("map", parameters: nil)
            
        case .btc, .divide, .multiply, .minus, .plus, .equal, .cos, .sin:
            
            if dataModel == .btc {
                Analytics.logEvent("bitcoin", parameters: nil)
            }else{
                Analytics.logEvent("offline_operations", parameters: nil)
            }
            
            if dataModel == .btc && !self.isIntenetAvailable{
                self.isShowAlert = true
                return;
            }
            if onLocationOperation {
                onTapMap()
            }
            
            self.viewModel?.currentOperation(dataModel: dataModel) { [weak self] (result) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.lblResult.text = result
                }
                }
        default:
             if let existingOperation = self.lastSelectedOperator{
                existingOperation.resetToggle()
            }
            self.viewModel?.currentOperation(dataModel: dataModel) { [weak self] (result) in
                guard let self = self else { return  }
                DispatchQueue.main.async {
                    if self.onLocationOperation{
                        self.locationView.currentInput = result
                    }else{
                        self.lblResult.text = result
                    }
                }
            }
        }
        
    }
    
    // Show Hide Location View Animation
    fileprivate func onTapMap(){
        
//        self.dismiss(animated: true, completion: nil) // to check retain cycle
             
        self.onLocationOperation = !self.onLocationOperation
         
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            if self.onLocationOperation{
                if let initialTransform = self.locationViewIntialTransform{
                    self.lblResult.isHidden = true
                    self.locationView.transform =  initialTransform
                }
            }else{
                self.locationView.transform =  self.locationView.transform.translatedBy(x: self.locationView.transform.tx, y: -500)
                self.lblResult.isHidden = false
                
            }
            
        }, completion: nil)
     }
    
    //Show Hide Alert View Animation
    fileprivate func onShowHideAlert(){
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
                if self.isShowAlert{
                    if let initialTransform = self.alertTransform{
                        self.alert.transform =  initialTransform
                    }
                }else{
                    self.alert.transform =  self.alert.transform.translatedBy(x: self.alert.transform.tx, y: -500)
                }
            }, completion: nil)
        }
        
        
    }
    
}

