import XCTest

class   FintechWikiTests2: XCTestCase {
    static let app =  XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    static let appName = "Википедия"
    let testPage = AboutPage()
    
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
        testPage.tapBackSettings()
    }
    
    func testAuthorsDisplayed(){
        let authors = testPage.blockAuthors
        if authors.waitForExistence(timeout: 5){
            XCTAssertTrue(testPage.isDisplayed(element: authors))
        } else {
            XCTFail("Блок \"Авторы\" отсутствует в иерархии View")
        }
    }
    
    func testTranslatorsDisplayed(){
        let translators = AboutPage().blockTranslators
        if translators.waitForExistence(timeout: 5){
            XCTAssertTrue(testPage.isDisplayed(element: translators))
        } else {
            XCTFail("Блок \"Переводчики\" отсутствует в иерархии View")
        }
    }
    
    func testContentLicenseDisplayed(){
        let license = AboutPage().blockContentLicense
        if license.waitForExistence(timeout: 5) {
            XCTAssertTrue(testPage.isDisplayed(element: license))
        } else {
            XCTFail("Блок \"Лиценхия содержимого\" отсутствует в иерархии View")
        }
        
    }
    
}
