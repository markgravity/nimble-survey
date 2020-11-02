//
//  LandingController.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit
import SwiftyBase
import RxCocoa
import RxSwift

class LandingController: ViewController {
    @Inject fileprivate var _viewModel: LandingVM
    @Inject fileprivate var _authVM: AuthVM
    
    fileprivate let _disposeBag = DisposeBag()
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Prevent do anything
        // when run by tests
        #if DEBUG
        if let _ = NSClassFromString("XCTest") {
            return
        }
        #endif
        _setup()
    }
}

// MARK: - Navigation
extension LandingController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup
fileprivate extension LandingController {
    func _setup() {
        
        // Fade in logo
        logoImageView.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.logoImageView.alpha = 1
            self?._binds()
        }
    }
    
    func _binds() {
        _viewModel.fetch()
            .delay(1)
            .then {
                self._onFetchCompleted()
            }
            .catchThenAlert()
    }
}

// MARK: - Private
fileprivate extension LandingController {
    
    func _onFetchCompleted() {
        switch _authVM.isAuthenticated.value {
        case true:
            performSegue(
                withNavigationOf: HomeController.self,
                sender: nil
            )
        
        case false:
            performSegue(
                withNavigationOf: LoginController.self,
                sender: nil
            )
        }
    }
}
