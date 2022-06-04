import XCTest

class AboutPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let buttonBackSettings: XCUIElement
    let blockAuthors: XCUIElement
    let blockTranslators: XCUIElement
    let blockContentLicense: XCUIElement
    
    init() {
        self.buttonBackSettings = app.buttons["Настройки"].firstMatch
        self.blockAuthors = app.staticTexts["Авторы"]
        self.blockTranslators = app.staticTexts["Переводчики"]
        self.blockContentLicense = app.staticTexts["Лицензия содержимого"]
    }
    
    func tapBackSettings() {
        if buttonBackSettings.waitForExistence(timeout: 5){
            buttonBackSettings.tap()
        } else {
            XCTFail("Кнопка назад в \"Настройки\" не найдена")
        }
    }
    
    func isDisplayed(element: XCUIElement) -> Bool {
        var swipeCount = 5
        while (swipeCount > 0) && !(element.isHittable) {
            app.swipeUp()
            swipeCount -= 1
        }
        if element.isHittable {
            return true
        }
        return false
    }
    
}
