//
//  HomeController.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import UIKit
import SwiftyBase
import RxCocoa
import RxSwift
import SkeletonView
import LNZCollectionLayouts

class HomeController: ViewController {
    @Inject fileprivate var _viewModel: HomeVM
    @Inject fileprivate var _authVM: AuthVM
    
    fileprivate let _disposeBag = DisposeBag()
    
    /// Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentDateLabl: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _setup()
        _binds()
    }
}

// MARK: - Navigation
extension HomeController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup
fileprivate extension HomeController {
    func _setup() {
        
        // Set size for collection view cell
        let layout = (collectionView.collectionViewLayout as! LNZInfiniteCollectionViewLayout)
        layout.itemSize = UIScreen.main.bounds.size
        layout.focusChangeDelegate = self
    }
    
    func _binds() {
        
        // Current Date Text
        _viewModel.currentDateText
            .bind(to: currentDateLabl.rx.text)
            .disposed(by: _disposeBag)
        
        // Title
        _viewModel.focusItem
            .map { $0?.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: _disposeBag)
        
        // Description
        _viewModel.focusItem
            .map { $0?.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: _disposeBag)
        
        // Avatar
        _authVM.user
            .map { $0?.avatarURL }
            .filter { $0 != nil }
            .map { $0! }
            .withUnretained(self)
            .bind {
                $0.0.avatarButton.af.setImage(for: .normal, url: $0.1)
            }
            .disposed(by: _disposeBag)
        
        
        // Collection View & PageControl
        _viewModel.items
            .withUnretained(self)
            .bind {
                $0.0.pageControl.numberOfPages = $0.1.count
                $0.0.collectionView.reloadData()
            }
            .disposed(by: _disposeBag)
        
        // Current Page for PageControl
        _viewModel.focusIndex
            .withUnretained(self)
            .bind {
                $0.0.pageControl.currentPage = $0.1
            }
            .disposed(by: _disposeBag)
        
        // First Load
        _showSkeletonLoading()
        _ = _viewModel.refresh()
            .catchThenAlert()
            .always {
                self._dismissSkeletonLoading()
            }
    }
}

// MARK: - Private
fileprivate extension HomeController {
    func _showSkeletonLoading() {
        let gradient = SkeletonGradient(baseColor: .hex("#29292B"), secondaryColor: .hex("#414143"))
        
        view.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func _dismissSkeletonLoading() {
        view.hideSkeleton()
    }
}

// MARK: - CollectionView
extension HomeController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        _viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: HomeCollectionViewCell.self, indexPath: indexPath)!
        let item = _viewModel.items.value[indexPath.row]
        
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - FocusChangeDelegate
extension HomeController: FocusChangeDelegate {
    func focusContainer(_ container: FocusedContaining, willChangeElement inFocus: Int, to newInFocus: Int) {
        
    }
    
    func focusContainer(_ container: FocusedContaining, didChangeElement inFocus: Int) {
        _viewModel.setFocusIndex(inFocus)
    }
}
