//
//  TVShowCollectionViewCell.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 05/03/2021.
//

import Foundation
import SDWebImage
import UIKit

class TVShowCell: UICollectionViewCell {
    
    static let cellIdentifier = "TVShowCell"

    var titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        return title
    }()
    
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
 
        // We want round corners
        imageView.layer.cornerRadius = 15.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Adding our components to the view
        self.contentView.addSubview(thumbnail)
        self.contentView.addSubview(titleLabel)
            
        // Setting up constraints
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ aTvShow: TVShow) {
        // Setting title
        self.titleLabel.text = aTvShow.name
        
        // Using SDWebImage for caching
        guard let imgUrl = aTvShow.image?.medium else {
            return
        }

        // Setting spinner
        self.thumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.thumbnail.sd_setImage(with: URL(string: imgUrl), placeholderImage: nil)
    }
    
    private func setupConstraints() {
        
        // Setting image constraints
        thumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        thumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        thumbnail.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        // Setting title constraint
        titleLabel.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 3).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: 8).isActive = true
    }
}
