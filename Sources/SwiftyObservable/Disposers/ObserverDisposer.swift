//
//  File.swift
//  
//
//  Created by Arslan Basit on 16/01/2023.
//

import Foundation

class ObserverDisposer<T>: Disposer {
    
    var observers = Set<GenericObserver<T>>()
    
    func dispose(_ disposable: AnyDisposable)  {
        guard let observer = disposable as? GenericObserver<T> else {
            return
        }
        
        observers.remove(observer)
    }

    func disposeAll() {
        observers.removeAll()
    }
    
}
