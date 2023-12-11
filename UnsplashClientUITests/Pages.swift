import XCTest

struct ExploreScreen {
    
    private let app: XCUIApplication = XCUIApplication()
    
    var newTableLable: XCUIElement {
        app.staticTexts["New Images"]
    }
    
    var exploreLable: XCUIElement {
        app.staticTexts["Explore"]
    }
    
    var headerLable: XCUIElement {
        app.staticTexts["Photos for everyone"]
    }
    
    var newImages: XCUIElement {
        app.collectionViews.children(matching: .cell).element(boundBy: 3)
    }
    
    var collections: XCUIElement {
        app.collectionViews.children(matching: .cell).element(boundBy: 2)
    }
    
    var firstCollection: XCUIElement {
        app.descendants(
            matching: .cell
        ).matching(
            NSPredicate(format: "identifier == 'Collections_Cell_0'")
        ).firstMatch
    }
    
    var firstImage: XCUIElement {
        app.descendants(
            matching: .cell
        ).matching(
            NSPredicate(format: "identifier == 'Images_Cell_0'")
        ).firstMatch
    }
}

struct ExifScreen {
    
    private let app: XCUIApplication = XCUIApplication()
    
    var infoButton: XCUIElement {
        app.buttons.element(
            matching: NSPredicate(format: "identifier == 'info_button'")
        ).firstMatch
    }
    
    var cameraLable: XCUIElement {
        app.staticTexts["Camera"]
    }
    
    var dismissButton: XCUIElement {
        app.buttons.element(
            matching: NSPredicate(format: "identifier == 'dismiss_button'")
        ).firstMatch
    }
}
