//
//  UIImage+Colored.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 06/03/2021.
//

import Foundation
import UIKit

extension UIImage {

    func colored(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }

}
