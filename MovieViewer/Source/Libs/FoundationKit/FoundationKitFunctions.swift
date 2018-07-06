//
//  FoundationKitFunctions.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation

public func toString(_ cls: AnyClass) -> String {
    return String(describing: cls)
}

public func cast<Type, Result>(_ value: Type) -> Result? {
    return value as? Result
}
