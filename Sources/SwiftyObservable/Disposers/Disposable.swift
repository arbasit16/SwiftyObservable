//
//  Disposable.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

public protocol Disposable: AnyObject, Hashable {
    
    var id: String { get }
    
    var disposer: Disposer? { get set }
    
    func dispose()
    
}

extension Disposable {
    
    func dispose() {
        disposer?.dispose(AnyDisposable(self))
    }
}


