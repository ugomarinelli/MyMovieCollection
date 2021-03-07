//
//  TVShow.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 03/03/2021.
//

import Foundation
import UIKit

struct TVShow: Decodable {
    var name: String
    var summary: String?
    var image: Image?
    var rating: Rating
}

struct Image: Decodable {
    var original: String?
    var medium: String?
}

struct Rating: Decodable {
    var average: Decimal?
}
