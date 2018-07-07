//
//  MoviesListViewController.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, ObservableObjectDelegate, RootView {
    // MARK: - RootView
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
    
    private func startGetPopularMoviesProvider() {
        let url = URL(string: NetworkHandler.endpointString(endpoint: .popularMovies)) ?? URL(fileURLWithPath: "")
        let parameters = [Parameters.apiKey:NetworkHandler.APIKey]
        
        self.getPopularMoviesProvider = NetworkJSONProvider(with: url, parameters: parameters)
        self.getPopularMoviesProvider?.delegate = self
        self.getPopularMoviesProvider?.execute()
    }
    
    
    // MARK: - ObservableObjectDelegate
    func modelWillLoad(observableObject: AnyObject) {
    }
    
    func modelDidLoad(observableObject: AnyObject) {
        if observableObject === self.getPopularMoviesProvider {
            self.moviesList = getPopularMoviesProvider?.result
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
    
    
}
