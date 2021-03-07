//
//  TVShowService.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 03/03/2021.
//

import Foundation
import Combine

enum TVShowError: Error {
    case endReached
    case genericServerError
}

protocol TVShowService {
    
    /// Method tha will call the TVShow API and returns a lis of tv shows
    func getTVShows(pageIndex: Int) -> AnyPublisher<[TVShow], Error>
}

class TVShowServiceImpl: TVShowService {
    
    func getTVShows(pageIndex: Int) -> AnyPublisher<[TVShow], Error> {
        
        // Usually I would externalize the API
        let urlString = "http://api.tvmaze.com/shows?page=\(pageIndex)"
        
        // Creating URL from string
        guard let urlRequest = URL(string: urlString) else {
            fatalError("API Construction Error")
        }
        
        let request = URLRequest(url: urlRequest)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ (error) -> Error in
                    return error
            })
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw  TVShowError.genericServerError
                }
                
                switch  httpResponse.statusCode {
                case 200:
                    return data
                case 404:
                    throw TVShowError.endReached
                default:
                    throw TVShowError.genericServerError
                }
            }
            .decode(type: [TVShow].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
