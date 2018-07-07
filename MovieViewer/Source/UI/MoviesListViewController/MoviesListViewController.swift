//
//  MoviesListViewController.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, ObservableObjectDelegate, RootView {
    // Mvar: - RootView
    typealias ViewType = MoviesListView
    
    // MARK: - Outlets
    private var getPopularMoviesProvider: NetworkJSONProvider<MoviesList>?
    private var moviesList: MoviesList? {
        didSet {
            self.rootView?.collectionView.reloadData()
        }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.startGetPopularMoviesProvider()
    }

    // MARK: - Private
    private func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func startGetPopularMoviesProvider(page: Int = 1) {
        let url = URL(string: NetworkHandler.endpointString(endpoint: .popularMovies)) ?? URL(fileURLWithPath: "")
        let parameters = [Parameters.apiKey:NetworkHandler.APIKey, Parameters.page: String(page)]
        
        self.getPopularMoviesProvider = NetworkJSONProvider(with: url, parameters: parameters)
        self.getPopularMoviesProvider?.delegate = self
        self.getPopularMoviesProvider?.execute()
    }
    
    private func processMovies() {
        if self.moviesList != nil {
            self.getPopularMoviesProvider?.result?.movies.forEach {[weak self] movie in
                self?.moviesList?.movies.append(movie)
            }
            
            self.moviesList?.page = self.getPopularMoviesProvider?.result?.page ?? 1
        } else {
            self.moviesList = getPopularMoviesProvider?.result
        }
    }
    
    // MARK: - ObservableObjectDelegate
    func modelWillLoad(observableObject: AnyObject) {
        
    }
    
    func modelDidLoad(observableObject: AnyObject) {
        if observableObject === self.getPopularMoviesProvider {
            self.processMovies()
        }
    }
    
    func modelFailLoading(observableObject: AnyObject, error: String) {
        
    }
}

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesList?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieCollectionViewCell? = cast(collectionView.dequeueReusableCell(withReuseIdentifier: toString(MovieCollectionViewCell.self), for: indexPath))
        
        self.moviesList.map {
            cell?.fill(with: $0.movies[indexPath.row])
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let moviesList = self.moviesList {
            if indexPath.row == moviesList.movies.count - 1 {
                self.startGetPopularMoviesProvider(page: moviesList.page + 1)
            }
        }
    }
}
