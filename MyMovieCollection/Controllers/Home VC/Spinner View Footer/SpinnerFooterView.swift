//
//  SpinnerFooterView.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 06/03/2021.
//

import Foundation
import UIKit

public class SpinnerFooterView: UICollectionReusableView {
    
    var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.startAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Adding Spinner
        self.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
