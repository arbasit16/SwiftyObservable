import Foundation

@propertyWrapper
public class Observable<T> {
    
    private var disposer = ObserverDisposer<T>()
    
    public var wrappedValue: T {
        didSet {
            disposer.observers.forEach({ $0.observe(wrappedValue) })
        }
    }

    public var projectedValue: Observable<T> {
        self
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    public func observer<O: Observer>(_ observer: O) -> O where O.Value == T {
        observer.disposer = disposer
        disposer.observers.insert(GenericObserver(observer))
        return observer
    }

    public func removeAllObservers() {
        disposer.disposeAll()
    }
}

extension Observable {
    
    public func changeHandler(_ onChange: @escaping (T) -> Void) -> some Observer {
        let observer = CallbackObserver<T>(changeHandler: onChange)
        return self.observer(observer)
    }
    
    public func bind<Object: AnyObject>(to keyPath: WritableKeyPath<Object, T>, on object: Object) -> some Observer {
        let observer = BindingObserver<T>()
        observer.addBinding(to: keyPath, on: object)
        return self.observer(observer)
    }
    
    public func notify(with notificationName: NSNotification.Name, centre: NotificationCenter = .default) -> some Observer {
        let observer = NotificationObserver<T>(notificationName: notificationName, centre: centre)
        return self.observer(observer)
    }
    
}
