import XCTest
@testable import UnsplashClient

final class UnsplashClientUITests: XCTestCase {
    
    let exploreScreen = ExploreScreen()
    let exifScreen = ExifScreen()
    
    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI_tests"]
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLables() throws {
        [   exploreScreen.headerLable,
            exploreScreen.newTableLable,
            exploreScreen.exploreLable
        ].forEach{XCTAssertTrue($0.exists)}
    }
    
//    func testCrutialSections() throws {
//        XCTAssertTrue(exploreScreen.newImages.exists)
//        XCTAssertTrue(exploreScreen.collections.exists)
//    }
    
    func testCollectionCells() throws {
        let firstCollection = exploreScreen.firstCollection
        XCTAssertTrue(firstCollection.exists)
        firstCollection.swipeLeft()
    }
    
    func testNewImagesCells() throws {
        let firstImage = exploreScreen.firstImage
        XCTAssertTrue(firstImage.exists)
        firstImage.tap()
        let infoButton = exifScreen.infoButton
        infoButton.tap()
        let cameraLable = exifScreen.cameraLable
        XCTAssertTrue(cameraLable.exists)
    }
    
    func testFromExifToExplore() throws {
        let firstImage = exploreScreen.firstImage
        XCTAssertTrue(firstImage.exists)
        firstImage.tap()
        let dismissButton = exifScreen.dismissButton
        dismissButton.tap()
        XCTAssertTrue(exploreScreen.newTableLable.exists)
    }
}
