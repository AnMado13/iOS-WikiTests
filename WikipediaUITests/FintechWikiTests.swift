import XCTest

class 	FintechWikiTests: XCTestCase {
    let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    
    override func setUp() {
        app.launch()
    }
    
    override func tearDown() {
        
    }
    
    func testScreenSwitching(){
        let buttonFeed = app.tabBars["Панель вкладок"].buttons["Лента"]
        buttonFeed.tap()
        let buttonAllTopArticles = app.collectionViews.buttons["Все самые читаемые статьи"]
        buttonAllTopArticles.tap()
        let buttonClose = app.buttons["Закрыть"]
        XCTAssertTrue(buttonClose.exists)
    }
}
