//
//  File.swift
//  
//
//  Created by Arslan Basit on 15/01/2023.
//

import Foundation

internal class CallbackObserver<T>: Observer {

    private(set) var id: String
    private var changeHandler: (T) -> Void
    var disposer: Disposer?

    init(id: String = UUID().uuidString, changeHandler: @escaping (T) -> Void) {
        self.id = id
        self.changeHandler = changeHandler
    }

    func observe(_ value: T) {
        changeHandler(value)
    }

    static func == (lhs: CallbackObserver<T>, rhs: CallbackObserver<T>) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
