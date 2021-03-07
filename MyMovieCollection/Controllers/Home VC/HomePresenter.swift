//
//  HomePresenter.swift
//  MyMovieCollection
//
//  Created by Ugo Marinelli on 03/03/2021.
//

import Foundation
import Combine

// Interface with visible methods for accessing presenter
protocol HomePresenter {
    
    /// Method that will call the API and get tvShows
    func fetchTvShow()
}

class HomePresenterImpl: HomePresenter {
    
    // internal variables
    private var cancellable: AnyCancellable?
    private var tvShows: [TVShow] = []
    private var pageIndex: Int = 0
    
    // Usually, I would create a Dependency Injector for all my services
    private var tvShowService = TVShowServiceImpl()
    
    // Reference to Home View
    private weak var userInterface: HomeUserInterface?
    
    init(userInterface: HomeUserInterface) {
        self.userInterface = userInterface
    }
    
    // When we have a new State -> We update our View Controller
    private func updateUserInterface(isLoading: Bool, tvShows: [TVShow]?) {
        self.userInterface?.viewState = HomeViewState(isLoading: isLoading, tvShows: tvShows)
    }
    
    /// Method tthat will call the TV Show API
    func fetchTvShow() {
        
        self.userInterface?.viewState.isLoading = true
        self.userInterface?.updateSpinnerView()
        
        self.cancellable = tvShowService.getTVShows(pageIndex: pageIndex)
            .sink { (result) in
                
                switch result {
                
                case .failure (let anError):
                    // Handle failure
                    guard let errorCause = anError as? TVShowError, errorCause == .endReached else {
                        self.userInterface?.showError()
                        return
                    }
                    // Stop Spinner
                    self.userInterface?.viewState.isLoading = false
                    self.userInterface?.updateSpinnerView()
                    break
                case .finished:
                    break
                }
            } receiveValue: { (tvShows) in
                // Adding new tv shows
                self.tvShows.append(contentsOf: tvShows)
                
                // Updating state
                self.updateUserInterface(isLoading: false, tvShows: self.tvShows)
                self.userInterface?.reload()
                
                // incrementing page number
                self.pageIndex += 1
            }
    }
}
