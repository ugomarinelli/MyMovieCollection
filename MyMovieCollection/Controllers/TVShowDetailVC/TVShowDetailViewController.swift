//
//  TVShowDetailViewController.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 06/03/2021.
//

import Foundation
import UIKit
import SDWebImage

// Here I choose not to have a state/presenter since it is a quite simple view
class TVShowDetailViewController: UIViewController {
    
    var tvShow: TVShow
    
    init(_ tvShow: TVShow) {
        self.tvShow = tvShow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // We need to embed everything in a scroll view to be able to scroll
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .black
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // We will put all our views in a stack view container
    private lazy var stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let iconImage = UIImage(systemName: "xmark.circle.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium))?.colored(.white)
        
        let button = UIButton()
        button.setImage(iconImage, for: .normal)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.numberOfLines = 0
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        return name
    }()
    
    private lazy var ratingLabel: UILabel = {
        let rating = UILabel()
        rating.textColor = .white
        rating.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        return rating
    }()
    
    private lazy var summary: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First we add the scroll view
        self.view.addSubview(scrollView)
        
        // In the scroll view, we add the stackview
        self.scrollView.addSubview(stackViewContainer)
        
        // We then add our components -> image / name / rating / summary
        self.stackViewContainer.addArrangedSubview(imageView)
        self.stackViewContainer.addArrangedSubview(nameLabel)
        
        // Only add ratings if we have it
        if tvShow.rating.average != nil {
            self.stackViewContainer.addArrangedSubview(ratingLabel)
        }
        
        self.stackViewContainer.addArrangedSubview(summary)
        
        // Adding the close button
        self.scrollView.addSubview(closeButton)
        
        // We set the constraints for the view
        setupConstraints()
        
        // We fill our view with the data
        setupView()
    }
    
    private func setupView() {
        self.nameLabel.text = tvShow.name
        self.summary.text = tvShow.summary?.htmlToString
        
        if let rating = tvShow.rating.average {
            self.ratingLabel.text = "Rating : \(rating) / 10"
        }
        
        guard let imgUrl = tvShow.image?.original else {
            return
        }
        
        // Rescale image
        let transformer = SDImageResizingTransformer(size: CGSize(width: UIScreen.main.bounds.width, height: 600), scaleMode: .aspectFit)
        
        imageView.sd_setImage(with: URL(string: imgUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
        
    }
    
    private func setupConstraints() {
        
        // Scroll view
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        
    }
    
    // When the user taps on the close button
    @objc
    private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
