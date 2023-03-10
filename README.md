# SwiftyObservable

[![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org/about/)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-orange.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgray.svg)](LICENSE)

SwiftyObservable provides an `Observable` property wrapper that enables you to easily add observers to your properties. With just a few lines of code, you can trigger a closure, post a notification, or update a key path whenever the observed property's value changes.

## Installation

You can install SwiftyObservable using Swift Package Manager. Simply add the following line to your dependencies in Package.swift:

```
.package(url: "https://github.com/your-username/Observable.git", from: "1.0.0"),
```

## Usage

To use the Observable property wrapper, simply add it to your property declaration like this:

```swift
@Observable var someProperty: String = "initial value"
```

SwiftyObserver provides three observers that can be added to a property

### Closure Observer

The closure observer is the simplest observer and accepts a closure to be called when the property's value changes. The closure will be passed the new value of the property.

```swift
$someProperty.changeHandler { newValue in
    // Do something with the new value
}
```

### Binding Observer

The binding observer updates the value of a key path on an object when the property's value changes. The object must be of the same type as the property's value.

```swift
class MyClass {

    @Observable var myProperty: String? = "initial value"
    
}

let myObject = MyClass()
let myLabel = UILabel()


myObject.$myProperty.bind(to: \.text, on: myLabel)
```

### Notification Observer

The notification observer posts a notification when the property's value changes. You can specify the notification name. The notification's `userInfo` contains the updated value of the propery

```swift
$someProperty.notify(with: Notification.Name("SomePropertyDidChange"))
```

### Custom Observers

You can also create a custom observer by implementing the `Observer` protocol. This allows you to define your own behavior when the property's value changes. The `Observer` protocol is generic, with an associated type Value that corresponds to the type of the observed property.

```swift
class MyObserver: Observer {

    typealias Value = String

    var id: String = "id"
    var disposer: Disposer?
    
    var observe(_ value: Value) {
        // your custom behaviour
    }
    
```

Then add the observer using `addObserver` method

```swift
$someProperty.addObserver(myObserver)
```

### Storing Observer

Observers can be stored using `Set` of `AnyDisposable`. The type `AnyDisposable` is provided by SwiftyObservable and it allows you to remove the observer. An observer can be stored by calling its `store` method

```swift
class MyClass {

    @Observable var someProperty: String = "some value"
    
    var observers = Set<AnyDisposable>()
    
    func setupObserver() {
        $someProperty
            .changeHandler({ newValue in
                // Do something
            })
            .store(in: &observers)
    }
}
```

The observer can then be removed by calling its `dispose` method

```swift

extension MyClass {

    func removeObservers() {
        observers.forEach({ $0.dispose() })
    }
    
}
```

SwiftyObservable also provides way for storing and removing observers

## Contributing

Contributions to `SwiftyObservable` are welcome! Feel free to submit a pull request or open an issue if you encounter a bug or have a feature request.

## License

`SwiftyObservable` is available under the MIT license. See the [LICENSE](LICENSE) file for more information.


