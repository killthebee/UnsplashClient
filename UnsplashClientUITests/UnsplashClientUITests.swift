import XCTest
@testable import UnsplashClient

final class UnsplashClientUITests: XCTestCase {
    
//    var tokenManager: KeyChainManagerProtocol!
    var app: XCUIApplication!
    
    let testToken = "u79URgKP7fzNj3dhCvvbjDa7u_Zr2UjpFpa6651z9l8"

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["UI_tests"]
        app.launch()
//        let tokenManager = KeyChainManager()
        continueAfterFailure = false
//        tokenManager.save(
//            testToken.data(using: .utf8)!,
//            service: "access-token",
//            account: "unsplash"
//        )
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
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
    
    func testTables() throws {
        let hmm = app.collectionViews.children(
            matching: .cell
        ).element(boundBy: 0)
        
        XCTAssertTrue(hmm.exists)
    }
//
//    func testNewTableCells() throws {
//        let cell = app.cells.element(matching: .cell, identifier: "Cell_0")
////        cell.waitForExistence(timeout: 10)
//        while !cell.exists {
//            sleep(1)
//        }
//        XCTAssertTrue(cell.exists)
//    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
