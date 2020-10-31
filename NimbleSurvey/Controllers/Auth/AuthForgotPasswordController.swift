//
//  AuthForgotPasswordController.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit
import SwiftyBase
import RxCocoa
import RxSwift

class AuthForgotPasswordController: ViewController {
    
    @Inject fileprivate var _viewModel: AuthForgotPasswordVM
    fileprivate let _disposeBag = DisposeBag()
    
    /// Outlets
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _setup()
        _binds()
    }
}

// MARK: - Navigation
extension AuthForgotPasswordController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup
fileprivate extension AuthForgotPasswordController {
    func _setup() {
        
    }
    
    func _binds() {
        
        // Login Button
        resetButton.rx.tap
            .withUnretained(self)
            .bind { `self`, _ in
                _ = self._viewModel.reset()
            }
            .disposed(by: _disposeBag)
        
        // Email
        emailTextField.rx.text
            .withUnretained(self)
            .bind { `self`, text in
                self._viewModel.setEmail(text)
            }
            .disposed(by: _disposeBag)
        
        // State
        _viewModel.state
            .withUnretained(self)
            .bind {
                $0.0._onStateChanged($0.1)
            }
            .disposed(by: _disposeBag)
        
        // Is Valid
        _viewModel.isValid
            .withUnretained(self)
            .bind {
                $0.0._onValidChanged($0.1)
            }
            .disposed(by: _disposeBag)
    }
}

// MARK: - Private
fileprivate extension AuthForgotPasswordController {
    
    func _onStateChanged(_ state: AuthForgotPasswordState) {
        
        switch state {
        case .initial:
            break
            
        case .resetting:
            showProgressHUD()
            
        case .resetted:
            dismissProgressHUD()
            
        case .error(let error):
            dismissProgressHUD()
            alert(error)
        }
    }
    
    func _onValidChanged(_ isValid: Bool) {
        
        switch isValid {
        case true:
            resetButton.isEnabled = true
            resetButton.backgroundColor = .white
            
        case false:
            resetButton.isEnabled = false
            resetButton.backgroundColor = .gray
            
        }
    }
}
