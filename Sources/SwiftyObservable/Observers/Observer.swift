//
//  Observer.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

public protocol Observer: Disposable {
    
    associatedtype Value
    
    func observe(_ value: Value)
    func store(in observers: inout Set<AnyDisposable>)
    
}

public extension Observer {
    
    func dispose() {
        let genericObserver = GenericObserver(self)
        disposer?.dispose(genericObserver)
    }
    
    func store(in observers: inout Set<AnyDisposable>) {
        observers.insert(AnyDisposable(self))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

}
