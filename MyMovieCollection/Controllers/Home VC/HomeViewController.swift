//
//  HomeViewController.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 03/03/2021.
//

import Foundation
import UIKit

protocol HomeUserInterface: AnyObject {
    // State of the view
    var viewState: HomeViewState { get set }
    
    // Showing spinner at the bottom
    func updateSpinnerView()
    
    // Reloading Cview when we have new data
    func reload()
    
    // show error
    func showError()
}

class HomeViewController: UIViewController, HomeUserInterface {

    var viewState: HomeViewState = HomeViewState(isLoading: false, tvShows: [])
    
    private var presenter: HomePresenter!
    
    /// Collection view definition
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.bounces = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Collection view layout settings
        let layout = UICollectionViewFlowLayout()
        layout.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 9 , height: 200)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
        
        // Cell and footer registration
        collectionView.register(SpinnerFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "SpinnerFooterView")
        collectionView.register(TVShowCell.self, forCellWithReuseIdentifier: TVShowCell.cellIdentifier)
        return collectionView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Setting presenter
        self.presenter = HomePresenterImpl(userInterface: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding Cview to view
        self.view.addSubview(collectionView)
        
        // Setup view constraints
        setupConstraints()
        
        // Get tv shows
        presenter.fetchTvShow()
    }
    
    private func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // MARK: HomeUserInterface
    
    // When we have new data, we should reload
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // When the user reaches the end of the tview, we show him the spinner
    func updateSpinnerView() {
        
        DispatchQueue.main.async {
            // reload only footer
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // When there was an error during the request
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Oops, there was an error during the request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let tvShowCell = collectionView.dequeueReusableCell(withReuseIdentifier: TVShowCell.cellIdentifier, for: indexPath) as? TVShowCell,
              let aTVShow = viewState.tvShows?[indexPath.row] else {
            fatalError("Couldn't dequeue LoadingImageCollectionViewCell")
        }
        
        // Setup cell with our tv show
        tvShowCell.setupCell(aTVShow)
        
        return tvShowCell
    }
    
    /// When the user selects an item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tvShow = viewState.tvShows?[indexPath.row] else {
            return
        }
        
        // Showing the detail view
        let detailVC = TVShowDetailViewController(tvShow)
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState.tvShows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let tvShows = viewState.tvShows, !tvShows.isEmpty, !viewState.isLoading else {
            return
        }
        
        // When we are 15 items above the end, we start to fetch
        if indexPath.row == tvShows.count - 15 {
            presenter.fetchTvShow()
        }
        
    }
    
    /// Footer View
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SpinnerFooterView", for: indexPath) as? SpinnerFooterView,
              kind == UICollectionView.elementKindSectionFooter
        else {
            return UICollectionReusableView()
        }
        
        return footer
    }
    
    /// Height for footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        // We only want to see the spinner when we are not loading
        return viewState.isLoading ? CGSize(width: collectionView
                                                .frame.width, height: 100) : .zero
    }
}
