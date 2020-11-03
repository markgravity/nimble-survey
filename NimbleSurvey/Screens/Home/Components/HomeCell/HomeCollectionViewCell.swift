//
//  HomeCollectionViewCell.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import UIKit
import AlamofireImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with survey: SurveyInfo) {
        imageView.af.setImage(withURL: survey.coverImageURL)
    }
}
