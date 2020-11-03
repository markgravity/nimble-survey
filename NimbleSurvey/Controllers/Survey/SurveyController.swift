//
//  SurveyController.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import UIKit
import SwiftyBase
import RxCocoa
import RxSwift

class SurveyController: ViewController {
    fileprivate let _disposeBag = DisposeBag()
    fileprivate var _survey: SurveyInfo!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _setup()
        _binds()
    }
    
    func configure(with survey: SurveyInfo) {
        _survey = survey
    }
}

// MARK: - Navigation
extension SurveyController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup
fileprivate extension SurveyController {
    
    func _setup() {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        //
        titleLabel.text = _survey.title
        descriptionLabel.text = _survey.description
        thumbnailImageView.af.setImage(withURL: _survey.coverImageURL)
    }
    
    func _binds() {
        
    }
}

// MARK: - Private
fileprivate extension SurveyController {
    
}
