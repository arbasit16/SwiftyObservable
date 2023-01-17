//
//  File.swift
//  
//
//  Created by Arslan Basit on 16/01/2023.
//

import Foundation

internal class NotificationObserver<T>: Observer {
  
    typealias Value = T
    
    private(set) var id: String = UUID().uuidString
    private var notificationName: NSNotification.Name
    private var notificationCentre: NotificationCenter
    var disposer: Disposer?
    
    init(notificationName: NSNotification.Name, centre: NotificationCenter = .default) {
        self.notificationName = notificationName
        self.notificationCentre = centre
    }
    
    func observe(_ value: Value) {
        let userInfo: [AnyHashable: Any] = ["value": value]
        notificationCentre.post(name: notificationName, object: nil, userInfo: userInfo)
    }
    
    static func == (lhs: NotificationObserver<T>, rhs: NotificationObserver<T>) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
