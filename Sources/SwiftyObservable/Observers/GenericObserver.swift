//
//  File.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

internal class GenericObserver<T>: AnyDisposable, Observer {

    typealias Value = T
    
    private var observerHandler: (T) -> Void

    internal init<O: Observer>(_ observer: O) where O.Value == T {
        observerHandler = { value in
            observer.observe(value)
        }
        
        super.init(observer)
    
    }
    
    internal func observe(_ value: T) {
        observerHandler(value)
    }

}

