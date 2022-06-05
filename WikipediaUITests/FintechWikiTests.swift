import XCTest

class 	FintechWikiTests: XCTestCase {
    let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let appName = "Википедия"
    let browser = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    
    override func setUp() {
        app.launch()
        OnBoardingPage().doSkip()
        TabBar().tapFeed()
    }
    
    override func tearDown() {
        browser.terminate()
        app.terminate()
        Springboard().deleteMyApp(appName)
    }
    
    func testSwitchScreen(){
        FeedPage().tapAllTopArticles()
        
        let predicate = NSPredicate(format: "label CONTAINS %@", "Самые читаемые")
        let elementQuery = app.staticTexts.containing(predicate)
        let expectedCountMatches = 3
        
        XCTAssertTrue(elementQuery.count == expectedCountMatches)
    }
    
    func testOpenBrowserWindow() {
        FeedPage().tapSettings()
        SettingsPage().tapDonate()
        
        XCTAssertTrue(browser.wait(for: .runningForeground, timeout: 5))
    }
}
