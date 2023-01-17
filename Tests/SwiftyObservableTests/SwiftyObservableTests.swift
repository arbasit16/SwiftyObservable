import XCTest
@testable import SwiftyObservable

class ViewModelSpy {
    
    @Observable var firstValue: Int = 20
    @Observable var secondValue: String = "test"
    @Observable var thirdValue: Int = 10
}

class LabelSpy {
    var text: String = ""
}

class ViewControllerSpy {
    
    let viewModel: ViewModelSpy
    
    var observers = Set<AnyDisposable>()
    var callsMethodOnChange = false
    var postsNotificationOnUpdate = false
    var notificationValue: Int?
    var label = LabelSpy()
    
    init(viewModel: ViewModelSpy) {
        self.viewModel = viewModel
    }
    
    func viewDidLoad() {
        setupObservers()
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("testNotification"),
            object: nil,
            queue: nil,
            using: { notification in
                self.postsNotificationOnUpdate = true
                self.notificationValue = notification.userInfo?["value"] as? Int
            })
        
    }
    
    func setupObservers() {
        viewModel
            .$firstValue
            .changeHandler({ _ in
                self.callsMethodOnChange = true
            })
            .store(in: &observers)
        
        viewModel
            .$secondValue
            .bind(to: \.text, on: label)
            .store(in: &observers)
        
        let notificationName = Notification.Name("testNotification")
        viewModel
            .$thirdValue
            .notify(with: notificationName)
            .store(in: &observers)
        
    }

}

final class SwiftyObservableTests: XCTestCase {
    
    var removables = Set<AnyDisposable>()
    
    func testObservableCallsClosureOnValueUpdate() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        viewModelSpy.firstValue = 10
        XCTAssertTrue(sut.callsMethodOnChange)
    }
    
    func testObservableUpdatesBindValue() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        viewModelSpy.secondValue = "test2"
        XCTAssertEqual(sut.label.text, "test2")
    }
    
    func testNotifyObserverPostsNotificationOnUpdate() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        viewModelSpy.thirdValue = 20
        XCTAssertTrue(sut.postsNotificationOnUpdate)
    }
    
    func testNotifyObserverPassesDataWithNotificationOnUpdate() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        viewModelSpy.thirdValue = 20
        XCTAssertEqual(sut.notificationValue, 20)
    }
    
    func testCallbackObserverDoesNotCallClosureAfterRemove() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        sut.observers.forEach { $0.dispose() }
        viewModelSpy.firstValue = 30
        XCTAssertFalse(sut.callsMethodOnChange)
    }
    
    func testBindingObserverDoesNotUpdateValueAfterRemove() {
        let viewModelSpy = ViewModelSpy()
        let sut = ViewControllerSpy(viewModel: viewModelSpy)
        sut.viewDidLoad()
        sut.observers.forEach { $0.dispose() }
        viewModelSpy.secondValue = "test2"
        XCTAssertNotEqual(sut.label.text, "test2")
    }

}

