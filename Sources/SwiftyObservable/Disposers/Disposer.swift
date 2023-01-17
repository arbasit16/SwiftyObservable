//
//  File.swift
//  
//
//  Created by Arslan Basit on 16/01/2023.
//

import Foundation

public protocol Disposer: AnyObject {
    
    func dispose(_ disposable: AnyDisposable)
    func disposeAll() 
    
}
