import XCTest

class TopArticlesPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonClose: XCUIElement
    
    init() {
        self.buttonClose = app.buttons["Закрыть"]
    }
    
}
