//
//  MoviesListViewController.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, ObservableObjectDelegate {
    
    // MARK: - Outlets
    @IBOutlet var rootView: MoviesListView!
    private var networkProvider: NetworkProvider<MoviesList>?
    
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
        
        self.networkProvider = NetworkProvider(with: url, parameters: parameters)
        self.networkProvider?.delegate = self
        self.networkProvider?.execute()
    }
    
    // MARK: - <ObservableObjectDelegate>
    func modelWillLoad(observableObject: AnyObject) {
    }
    
    func modelDidLoad(observableObject: AnyObject) {

    }
    
    func modelFailLoading(observableObject: AnyObject, error: String) {
    }
}
