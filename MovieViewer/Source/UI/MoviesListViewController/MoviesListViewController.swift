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
    private var searchMoviesProvider: NetworkJSONProvider<MoviesList>?
    private var moviesList: MoviesList? {
        didSet {
            self.rootView?.collectionView.reloadData()
        }
    }
    
    private var shouldShowPopular = true {
        didSet {
            if shouldShowPopular != oldValue {
                self.moviesList = nil
            }
        }
    }
    
    private var query = ""
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.startGetPopularMoviesProvider()
    }
    
    // MARK: - User Interaction
    @IBAction func onSearchButton(_ sender: UIButton) {
        self.query = self.rootView?.searchTextField.text ?? ""
        if self.query.isEmpty {
            self.showEmptyTextFieldAlert()
        } else {
            self.startSearchMoviesProvider(query: self.query)
        }
    }
    
    @IBAction func onPopularFilmsButton(_ sender: UIButton) {
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
        self.shouldShowPopular = true
        self.getPopularMoviesProvider?.execute()
    }
    
    private func startSearchMoviesProvider(query: String, page: Int = 1) {
        let url = URL(string: NetworkHandler.endpointString(endpoint: .searchMovies)) ?? URL(fileURLWithPath: "")
        let parameters = [Parameters.apiKey:NetworkHandler.APIKey,
                          Parameters.page: String(page),
                          Parameters.query: query]
        
        self.searchMoviesProvider = NetworkJSONProvider(with: url, parameters: parameters)
        self.searchMoviesProvider?.delegate = self
        self.shouldShowPopular = false
        self.searchMoviesProvider?.execute()
    }
    
    private func processMovies(provider: NetworkJSONProvider<MoviesList>) {
        if self.moviesList != nil {
            provider.result?.movies.forEach {[weak self] movie in
                self?.moviesList?.movies.append(movie)
            }
            
            self.moviesList?.page = provider.result?.page ?? 1
        } else {
            self.moviesList = provider.result
        }
    }
    
    private func showEmptyTextFieldAlert() {
        let alert = UIAlertController(title: Strings.whoops.rawValue, message: Strings.emptyTextField.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.ok.rawValue, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ObservableObjectDelegate
    func modelWillLoad(observableObject: AnyObject) {
        
    }
    
    func modelDidLoad(observableObject: AnyObject) {
        if observableObject is NetworkJSONProvider<MoviesList> {
            self.processMovies(provider: observableObject as! NetworkJSONProvider<MoviesList>)
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
                if self.shouldShowPopular {
                    self.startGetPopularMoviesProvider(page: moviesList.page + 1)
                } else {
                    self.startSearchMoviesProvider(query: self.query, page: moviesList.page + 1)
                }
            }
        }
    }
}
