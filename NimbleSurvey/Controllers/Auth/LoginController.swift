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
                
                _ = self._viewModel.login(
                    email: self.emailTextField.text,
                    password: self.passwordTextField.text
                )
            }
            .disposed(by: _disposeBag)
        
        // State
        _viewModel.state
            .withUnretained(self)
            .bind {
                $0.0._onStateChanged($0.1)
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
            
        case .error(let error):
            dismissProgressHUD()
            alert(error)
        }
    }
}
