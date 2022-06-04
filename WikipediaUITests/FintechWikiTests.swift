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
        XCTAssertTrue(TopArticlesPage().buttonClose.waitForExistence(timeout: 5))
    }
    
    func testOpenBrowserWindow() {
        FeedPage().tapSettings()
        SettingsPage().tapDonate()
        XCTAssertTrue(browser.wait(for: .runningForeground, timeout: 5))
    }
}
