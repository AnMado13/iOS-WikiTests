import XCTest

class 	FintechWikiTests: XCTestCase {
    let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    
    override func setUp() {
        app.launch()
    }
    
    override func tearDown() {
        
    }
    
    func testExample(){
        let button = app.buttons.firstMatch
        button.waitForExistence(timeout: 10)
        button.tap()
    
    }
}
