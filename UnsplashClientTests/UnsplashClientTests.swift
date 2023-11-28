import XCTest
@testable import UnsplashClient

final class UnsplashClientTests: XCTestCase {
    
    var unsplashAPI: UnsplashApi!
    var tokenManager: KeyChainManagerProtocol!
    let randomC0de = "2323232"

    override func setUpWithError() throws {
        try super.setUpWithError()
        unsplashAPI = UnsplashApi()
        tokenManager = KeyChainManager()
        tokenManager.save(
            randomC0de.data(using: .utf8)!,
            service: "test-token",
            account: "tests"
        )
    }

    override func tearDownWithError() throws {
        unsplashAPI = nil
        
        try super.tearDownWithError()
    }

    func testMakeURL() throws {
        
        let getRandomPhotoUrl = unsplashAPI.makeUrl(target: .randomPhoto)
        
        let getCollectionsUrl = unsplashAPI.makeUrl(target: .collectionList)
        
        let asserations = [
            getRandomPhotoUrl!.absoluteString ==
            "https://api.unsplash.com/photos/random?orientation=landscape",
            getCollectionsUrl!.absoluteString ==
            "https://api.unsplash.com/collections?per_page=5"
        ]
        
        XCTAssertTrue(
            getRandomPhotoUrl!.absoluteString ==
            "https://api.unsplash.com/photos/random?orientation=landscape"
        )
//    https://unsplash.com/oauth/token?client_id=lpjuJu1NvEkMVzV_X3pvAmkfWzeCcnOs2w59gdeyp1Q&client_secret=tUic-Ay2vrcl6-_RcDETtFWbCoFrXowm2uGL8R4zyXo&redirect_uri=tutututuclient://&code=9&grant_type=authorization_code
//    https://api.unsplash.com/photos/random?orientation=landscape
        //https://api.unsplash.com/collections?per_page=5
    }
    
    func testTokenManager() throws {
        let token = tokenManager.readToken(
            service: "test-token",
            account: "tests"
        )!
        
        XCTAssertTrue(token == randomC0de)
    }
}
