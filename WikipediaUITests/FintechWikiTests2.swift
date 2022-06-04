import XCTest

class   FintechWikiTests2: XCTestCase {
    static let app =  XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    static let appName = "Википедия"
    
    override class func setUp() {
        app.launch()
        OnBoardingPage().doSkip()
        FeedPage().tapSettings()
    }
    
    override class func tearDown() {
        app.terminate()
        Springboard().deleteMyApp(appName)
    }
    
    override func setUp() {
        SettingsPage().tapAbout()
    }
    
    override func tearDown() {
        AboutPage().tapBackSettings()
    }
    
    func testAuthorsDisplayed(){
        XCTAssertTrue(AboutPage().blockAuthors.exists)
    }
    
    func testTranslatorsDisplayed(){
        XCTAssertTrue(AboutPage().blockTranslators.exists)
    }
    
    func testContentLicensesDisplayed(){
        XCTAssertTrue(AboutPage().blockContentLicenses.exists)
    }
    
}
