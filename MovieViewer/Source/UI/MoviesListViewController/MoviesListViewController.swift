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
    private var getPopularFilmsProvider: PopularFilmsProvider?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        
        self.getPopularFilmsProvider = PopularFilmsProvider()
        self.getPopularFilmsProvider?.delegate = self
        self.getPopularFilmsProvider?.execute()
    }

    // MARK: - Private
    private func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - <ObservableObjectDelegate>
    func modelWillLoad(observableObject: AnyObject) {
    }
    
    func modelDidLoad(observableObject: AnyObject) {

    }
    
    func modelFailLoading(observableObject: AnyObject, error: String) {
    }
}
