import XCTest
@testable import UnsplashClient

final class UnsplashClientUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let testToken = "u79URgKP7fzNj3dhCvvbjDa7u_Zr2UjpFpa6651z9l8"
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["UI_tests"]
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLables() throws {
        let newTableLable = app.staticTexts["New Images"]
        let exploreLable = app.staticTexts["Explore"]
        let headerLable = app.staticTexts["Photos for everyone"]
        let lables = [
            headerLable, exploreLable, newTableLable
        ].forEach{XCTAssertTrue($0.exists)}
    }
    
    func testCrutialSections() throws {
        let newImages = app.collectionViews.children(
            matching: .cell
        ).element(boundBy: 3)
        XCTAssertTrue(newImages.exists)
        let collections = app.collectionViews.children(
            matching: .cell
        ).element(boundBy: 2)
        XCTAssertTrue(collections.exists)
    }
    
    func testCollectionCells() throws {
        let firstCollections = app.descendants(
            matching: .cell
        ).matching(
            NSPredicate(format: "identifier == 'Collections_Cell_0'")
        ).firstMatch
        XCTAssertTrue(firstCollections.exists)
        firstCollections.swipeLeft()
    }
    
    func testNewImagesCells() throws {
        let firstImage = app.descendants(
            matching: .cell
        ).matching(
            NSPredicate(format: "identifier == 'Images_Cell_0'")
        ).firstMatch
        XCTAssertTrue(firstImage.exists)
        firstImage.tap()
        let infoButton = app.buttons.element(
            matching: NSPredicate(format: "identifier == 'info_button'")
        ).firstMatch
        infoButton.tap()
        let cameraLable = app.staticTexts["Camera"]
        XCTAssertTrue(cameraLable.exists)
    }
    
    func testFromExifToExplore() throws {
        let firstImage = app.descendants(
            matching: .cell
        ).matching(
            NSPredicate(format: "identifier == 'Images_Cell_0'")
        ).firstMatch
        XCTAssertTrue(firstImage.exists)
        firstImage.tap()
        let infoButton = app.buttons.element(
            matching: NSPredicate(format: "identifier == 'dismiss_button'")
        ).firstMatch
        infoButton.tap()
        let newTableLable = app.staticTexts["New Images"]
        XCTAssertTrue(newTableLable.exists)
    }
}
