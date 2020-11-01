//
//  LoginController.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit
import SwiftyBase
import RxCocoa
import RxSwift
import RxSwiftExt

class LoginController: ViewController {
    @Inject fileprivate var _viewModel: LoginVM
    
    fileprivate let _disposeBag = DisposeBag()
    
    /// Outlets
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _setup()
        _binds()
    }
}

// MARK: - Navigation
extension LoginController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup
fileprivate extension LoginController {
    func _setup() {
        
    }
    
    func _binds() {
        
        // Login Button
        loginButton.rx.tap
            .withUnretained(self)
            .bind { `self`, _ in
                _ = self._viewModel.login()
            }
            .disposed(by: _disposeBag)
        
        // Email
        emailTextField.rx.text
            .withUnretained(self)
            .bind { `self`, text in
                self._viewModel.setEmail(text)
            }
            .disposed(by: _disposeBag)
        
        // Password
        passwordTextField.rx.text
            .withUnretained(self)
            .bind { `self`, text in
                self._viewModel.setPassword(text)
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
fileprivate extension LoginController {
    
    func _onStateChanged(_ state: LoginState) {
        
        switch state {
        case .initial:
            break
            
        case .logging:
            showProgressHUD()
            
        case .logged:
            dismissProgressHUD()
            performSegue(
                withNavigationOf: HomeController.self,
                sender: nil
            )
            
        case .error(let error):
            dismissProgressHUD()
            alert(error)
        }
    }
    
    func _onValidChanged(_ isValid: Bool) {
        
        switch isValid {
        case true:
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
            
        case false:
            loginButton.isEnabled = false
            loginButton.backgroundColor = .gray
        
        }
    }
}
