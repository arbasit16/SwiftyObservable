//
//  File.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

internal class BindingObserver<T>: Observer {
    
    typealias Value = T
    
    var id: String
    private var observeHandler: ((T) -> Void)?
    var disposer: Disposer?

    init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    func addBinding<Object: AnyObject>(to keyPath: WritableKeyPath<Object, T>, on object: Object) {
        observeHandler = { value in
            var object = object
            object[keyPath: keyPath] = value
        }
    }
    
    func observe(_ value: Value) {
        observeHandler?(value)
    }
    
    static func == (lhs: BindingObserver<T>, rhs: BindingObserver<T>) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
