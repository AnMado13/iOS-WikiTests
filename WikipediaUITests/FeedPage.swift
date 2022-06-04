import XCTest

class FeedPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonAllTopArticles: XCUIElement
    let buttonSettings: XCUIElement
    
    init() {
        self.buttonAllTopArticles = app.collectionViews.buttons["Все самые читаемые статьи"]
        self.buttonSettings = app.toolbars.buttons["Настройки"]
    }
    
    
    func tapAllTopArticles(){
        if buttonAllTopArticles.waitForExistence(timeout: 5){
            buttonAllTopArticles.tap()
        } else {
            XCTFail("Не удалось найти кнопку \"Все самые читаемые статьи\"")
        }
    }
    
    func tapSettings(){
        if buttonSettings.waitForExistence(timeout: 5) {
            buttonSettings.tap()
        } else {
            XCTFail("Не удалось найти кнопку \"Настройки\"")
        }
    }
    
}
