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
        while !buttonAllTopArticles.exists {
            app.swipeUp()
        }
        buttonAllTopArticles.tap()
    }
    
    func tapSettings(){
        buttonSettings.tap()
    }
    
}
