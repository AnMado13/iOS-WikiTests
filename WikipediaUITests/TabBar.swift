import XCTest

class TabBar {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonFeed: XCUIElement
    
    init() {
        self.buttonFeed = app.tabBars.buttons["Лента"]
    }
    
    func tapFeed(){
        if buttonFeed.waitForExistence(timeout: 5) {
            buttonFeed.tap()
        } else{
            XCTFail("Раздел \"Лента\" не был найден")
        }
    }
    
}
