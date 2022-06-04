import XCTest

class Springboard {
    
    private let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    func deleteMyApp(_ bundleDisplayName: String) {

        let icon = springboard.icons[bundleDisplayName]
        if icon.waitForExistence(timeout: 3) {
            icon.press(forDuration: 2)
            
            let buttonRemoveApp = springboard.buttons["Удалить приложение"]
            if buttonRemoveApp.waitForExistence(timeout: 5) {
                buttonRemoveApp.tap()
            } else {
                XCTFail("Кнопка \"Удалить приложение\" не была найдена")
            }
            
            let buttonDeleteApp = springboard.alerts.buttons["Удалить приложение"]
            if buttonDeleteApp.waitForExistence(timeout: 5) {
                buttonDeleteApp.tap()
            }
            else {
                XCTFail("Кнопка \"Удалить приложение\" в алерте не была найдена")
            }

            let buttonDelete = springboard.alerts.buttons["Удалить"]
            if buttonDelete.waitForExistence(timeout: 5) {
                buttonDelete.tap()
            }
            else {
                XCTFail("Кнопка \"Удалить\" не была найдена")
            }
        }
    }
}
