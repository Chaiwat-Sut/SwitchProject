//
//  ViewController.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 6/2/2567 BE.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    var disposedBag = DisposeBag()
    
    @IBOutlet private weak var allSwitch: UISwitch!
    @IBOutlet private weak var hamburgerSwitch: UISwitch!
    @IBOutlet private weak var frenchFriesSwitch: UISwitch!
    @IBOutlet private weak var iceCreamSwitch: UISwitch!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservable()
        viewModel.setSwitches()
    }
    
    private func setupObservable(){
        viewModel.output
            .displaySwitch
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] all,ham,french,ice in
                self?.allSwitch.setOn(all, animated: true)
                self?.hamburgerSwitch.setOn(ham, animated: true)
                self?.frenchFriesSwitch.setOn(french, animated: true)
                self?.iceCreamSwitch.setOn(ice, animated: true)
        }).disposed(by: disposedBag)
        
        allSwitch.rx
            .isOn
            .observeOn(MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                self?.hamburgerSwitch.setOn(isOn, animated: true)
                self?.frenchFriesSwitch.setOn(isOn, animated: true)
                self?.iceCreamSwitch.setOn(isOn, animated: true)
                
                self?.viewModel.hamburger = isOn
                self?.viewModel.frenchFries = isOn
                self?.viewModel.iceCream = isOn
            }).disposed(by: disposedBag)
        
        hamburgerSwitch.rx
            .isOn
            .observeOn(MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                self?.viewModel.hamburger = isOn
                
                self?.checkAllSwitch()
            }).disposed(by: disposedBag)
        
        frenchFriesSwitch.rx
            .isOn
            .observeOn(MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                self?.viewModel.frenchFries = isOn
                
                self?.checkAllSwitch()
            }).disposed(by: disposedBag)
        
        iceCreamSwitch.rx
            .isOn
            .observeOn(MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                self?.viewModel.iceCream = isOn
                
                self?.checkAllSwitch()
            }).disposed(by: disposedBag)
        
        confirmButton.rx
            .tap
            .subscribe(onNext: {[weak self] _ in
                self?.resultLabel.text = self?.viewModel.setLabel()
            }).disposed(by: disposedBag)
    }
    
    func checkAllSwitch () {
        let type = viewModel.validateSwitches()
        switch type {
        case .allOn:
            allSwitch.setOn(true, animated: true)
        case .someOn:
            allSwitch.setOn(false, animated: true)
        case .allOff:
            allSwitch.setOn(false, animated: true)
        }
    }
    
}

