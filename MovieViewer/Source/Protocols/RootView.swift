//
//  RootView.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

protocol RootView: class {
    associatedtype ViewType: UIView
    
    var rootView: ViewType? { get }
}

extension RootView where Self: UIViewController {
    var rootView: ViewType? {
        return self.viewIfLoaded as? ViewType
    }
}
