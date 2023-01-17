//
//  AnyRemovable.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

public class AnyDisposable: Disposable {
    
    public private(set) var id: String
    weak public var disposer: Disposer?
    private var removeHandler: () -> Void
    
    public init<T: Disposable>(_ disposable: T) {
        id = disposable.id
        disposer = disposable.disposer
        removeHandler = {
            disposable.dispose()
        }
    }
    
    public func dispose() {
        removeHandler()
    }
    
    public static func == (lhs: AnyDisposable, rhs: AnyDisposable) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
