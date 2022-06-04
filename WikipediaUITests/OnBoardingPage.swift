import XCTest

class OnBoardingPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonSkip: XCUIElement
    
    init() {
        self.buttonSkip = app.buttons["Пропустить"]
    }
    
    func doSkip() {
        if buttonSkip.waitForExistence(timeout: 5){
            buttonSkip.tap()
        }
    }
    
}
    
