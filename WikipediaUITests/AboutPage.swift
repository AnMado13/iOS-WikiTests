import XCTest

class AboutPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonBackSettings: XCUIElement
    let blockAuthors: XCUIElement
    let blockTranslators: XCUIElement
    let blockContentLicenses: XCUIElement
    
    init() {
        self.buttonBackSettings = app.buttons["Настройки"]
        self.blockAuthors = app.staticTexts["Авторы"]
        self.blockTranslators = app.staticTexts["Переводчики"]
        self.blockContentLicenses = app.staticTexts["Лицензии содержимого"]
    }
    
    func tapBackSettings() {
        if buttonBackSettings.waitForExistence(timeout: 5){
            buttonBackSettings.tap()
        } else {
            XCTFail("Кнопка назад в \"Настройки\" не найдена")
        }
    }
    
}
