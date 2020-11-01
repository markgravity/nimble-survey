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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _setup()
        _binds()
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
        
    }
    
    func _binds() {
        _viewModel.fetch()
            .then {
                self._onFetchComplated()
            }
            .catchThenAlert()
    }
}

// MARK: - Private
fileprivate extension LandingController {
    
    func _onFetchComplated() {
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
