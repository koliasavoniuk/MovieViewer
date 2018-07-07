//
//  ObservableObject.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation

enum ModelState {
    case notLoaded
    case willLoad
    case didLoad
    case failLoading(error: String)
}

extension ModelState: Equatable {
    static func ==(lhs: ModelState, rhs: ModelState) -> Bool {
        switch (lhs, rhs) {
        case (.notLoaded, .notLoaded):
            return true
        case (.willLoad, .willLoad):
            return true
        case (.didLoad, .didLoad):
            return true
        case (.failLoading(let lhsError), .failLoading(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

protocol ObservableObjectDelegate: class {
    func modelNotLoaded(observableObject: AnyObject)
    func modelWillLoad(observableObject: AnyObject)
    func modelDidLoad(observableObject: AnyObject)
    func modelFailLoading(observableObject: AnyObject, error: String)
}

class ObservableObject: NSObject {
    weak var delegate: ObservableObjectDelegate?
    var shouldPostNotifications = false
    var state: ModelState = .notLoaded {
        didSet {
            if shouldPostNotifications {
                postNotification(withState: state)
            }
            performDelegateMethodOnMainThread(with: state)
        }
    }
    
    // MARK: - Private
    private func postNotification(withState state: ModelState) {
        let notificationName = notificationNameWithState(state: state)
        
        if Thread.isMainThread {
            NotificationCenter.default.post(name: notificationName, object: self)
        } else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: notificationName, object: self)
            }
        }
    }
    
    private func performDelegateMethodOnMainThread(with state: ModelState) {
        if Thread.isMainThread {
            performDelegateMethod(with: state)
        } else {
            DispatchQueue.main.async {
                self.performDelegateMethod(with: state)
            }
        }
    }
    
    private func performDelegateMethod(with state: ModelState) {
        switch state {
        case .notLoaded:
            delegate?.modelNotLoaded(observableObject: self)
        case .willLoad:
            delegate?.modelWillLoad(observableObject: self)
        case .didLoad:
            delegate?.modelDidLoad(observableObject: self)
        case .failLoading(let error):
            delegate?.modelFailLoading(observableObject: self, error: error)
        }
    }
    
    private func notificationNameWithState(state: ModelState) -> NSNotification.Name {
        switch state {
        case .notLoaded:
            return .modelNotLoadedNotification
        case .willLoad:
            return .modelWillLoadNotification
        case .didLoad:
            return .modelDidLoadNotification
        case .failLoading:
            return .modelDidFailLoadingNotification
        }
    }
}

extension ObservableObjectDelegate {
    func modelNotLoaded(observableObject: AnyObject) {
        
    }
    
    func modelWillLoad(observableObject: AnyObject) {
        
    }
    
    func modelDidLoad(observableObject: AnyObject) {
        
    }
    
    func modelFailLoading(observableObject: AnyObject, error: String) {
        
    }
}

enum ObservableNotificationName: String {
    case modelNotLoadedNotification
    case modelWillLoadNotification
    case modelDidloadNotification
    case modelDidFailLoadingNotification
}

extension Notification.Name {
    static let modelNotLoadedNotification      = NSNotification.Name(ObservableNotificationName.modelNotLoadedNotification.rawValue)
    static let modelWillLoadNotification       = NSNotification.Name(ObservableNotificationName.modelWillLoadNotification.rawValue)
    static let modelDidLoadNotification        = NSNotification.Name(ObservableNotificationName.modelDidloadNotification.rawValue)
    static let modelDidFailLoadingNotification = NSNotification.Name(ObservableNotificationName.modelDidFailLoadingNotification.rawValue)
}
