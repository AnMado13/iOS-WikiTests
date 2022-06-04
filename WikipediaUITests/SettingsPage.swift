import XCTest

class SettingsPage {
    private let app = XCUIApplication(bundleIdentifier: "org.wikimedia.wikipedia")
    let cellDonate: XCUIElement
    let cellAbout: XCUIElement
    
    init() {
        self.cellDonate = app.cells.staticTexts["Поддержать Википедию"]
        self.cellAbout = app.cells.staticTexts["О приложении"]
    }
    
    func tapDonate() {
        if cellDonate.waitForExistence(timeout: 5){
            cellDonate.tap()
        } else {
            XCTFail("Не удалось найти кнопку \"Поддержать Википедию\"")
        }
    }
    
    func tapAbout() {
        if cellAbout.waitForExistence(timeout: 5){
            cellAbout.tap()
        } else {
            XCTFail("Не удалось найти кнопку \"О приложении\"")
        }
    }
}
