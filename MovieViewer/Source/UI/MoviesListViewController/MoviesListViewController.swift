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
    private var getMoviesProvider: NetworkProvider<MoviesList>?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.startNetworkProvider()
    }

    // MARK: - Private
    private func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func startNetworkProvider() {
        let url = URL(string: NetworkHandler.endpointString(endpoint: .popularMovies)) ?? URL(fileURLWithPath: "")
        let parameters = [Parameters.apiKey: NetworkHandler.APIKey]
        
        self.getMoviesProvider = NetworkProvider(with: url, parameters: parameters)
        self.getMoviesProvider?.delegate = self
        DispatchQueue.global(qos: .background).async {
            self.getMoviesProvider?.execute()
        }
    }
    
    // MARK: - ObservableObjectDelegate
    func modelWillLoad(observableObject: AnyObject) {
    }
    
    func modelDidLoad(observableObject: AnyObject) {
        if observableObject === self.getMoviesProvider {
            DispatchQueue.main.async {
                self.rootView?.collectionView.reloadData()
            }
        }
    }
    
    func modelFailLoading(observableObject: AnyObject, error: String) {
        
    }
}

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getMoviesProvider?.result?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieCollectionViewCell? = cast(collectionView.dequeueReusableCell(withReuseIdentifier: toString(MovieCollectionViewCell.self), for: indexPath))
        
        self.getMoviesProvider?.result.map {
            cell?.fill(with: $0.movies[indexPath.row])
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    
}
