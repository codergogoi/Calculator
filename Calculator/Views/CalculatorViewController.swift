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
    
    // We will show hide some of the operation through remote config
    private func setupRemoteConfigDefaults(){
        let defaultValues = [
            RemoteKeys.isMap.rawValue : true as NSObject,
            RemoteKeys.isBtc.rawValue: true as NSObject,
            RemoteKeys.isDivide.rawValue: true as NSObject,
            RemoteKeys.isMultiply.rawValue: true as NSObject,
            RemoteKeys.isMinus.rawValue: true as NSObject,
            RemoteKeys.isPlus.rawValue: true as NSObject,
            RemoteKeys.plusMinus.rawValue: true as NSObject,
            RemoteKeys.percent.rawValue: true as NSObject,
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
        
        
        
        
        
        self.viewModel?.currentOperation(dataModel: dataModel) { [weak self] (result, isToggle) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lblResult.text = result
                if isToggle{
                    if let existingOperation = self.lastSelectedOperator{
                        existingOperation.resetToggle()
                    }
                }
                
            }
        }
        
        
        
    }
    
    
}

