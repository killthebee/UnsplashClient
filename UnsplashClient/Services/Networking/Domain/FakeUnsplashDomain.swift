import UIKit

class FakeUnsplashApi: UnsplashApiProtocol {
    
    static let shared: UnsplashApiProtocol = FakeUnsplashApi()
    
    public var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void = { _ in }
    
    var tokenStorage: TokenStorageProtocol?
    
    let headerInfo: [UnsplashPhoto] = FakeUnsplashApiMockData.headerInfo
    
    let collectionsInfo: [UnsplashColletion] = FakeUnsplashApiMockData.collectionsInfo
    
    var regularPhotoData: [String: Data?] = [:]
    
    var newImages: [PhotoModel] = []
    
    var exifAndImageData: [PhotoData] = [FakeUnsplashApiMockData.firstExifAndImageData]
  
    func exchangeCode(code: String) async -> TokenExchangeSuccessData? {
        return TokenExchangeSuccessData(
            access_token: "whatever",
            refresh_token: "whatever",
            token_type: "whatever",
            scope: "whatever",
            created_at: 1111
        )
    }
    
    var counter = 0
    private var isHeaderDataEmpty = true
    func getRandomPhoto() async -> UnsplashPhoto? {
        if isHeaderDataEmpty {
            populateHeaderData()
            isHeaderDataEmpty = false
        }
        if counter == 3 { counter = 0 }
        let photo = headerInfo[counter]
        counter += 1
        return photo
    }
    
    private var isCollectionDataEmpty = true
    func getCollections() async -> [UnsplashColletion]? {
        if isCollectionDataEmpty {
            populateRegularPhotoData()
            isCollectionDataEmpty = false
        }
        return collectionsInfo
    }
    
    func getNewImages(page pageNum: Int) async {
        populateNewImages()
        addNewImagesToRegularPhotos()
        return
    }
    
    func getUnsplashImage(_ url: String, imageId: String ) async -> Data? {
        if let photo = regularPhotoData[imageId] {
            return photo
        } else {
            return nil
        }
    }
    
    func getPhoto(_ photoID: String) async -> PhotoData? {
        return exifAndImageData[0]
    }
    
    func makeUrl(_ urlArg: String, target: urlTarget) -> URL? {
        return nil
    }
}

extension FakeUnsplashApi {
    private func populateRegularPhotoData() {
        regularPhotoData["c1"] = UIImage(named: "c1BussinessTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c2"] = UIImage(named: "c2EducationTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c3"] = UIImage(named: "c3RelationshipsTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c4"] = UIImage(named: "c4ParadeTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c5"] = UIImage(named: "c5CatsTests")!.jpegData(compressionQuality: 1)
    }
    
    private func populateHeaderData() {
        regularPhotoData["h1"] = UIImage(named: "headerTests1")!.jpegData(compressionQuality: 1)
        regularPhotoData["h2"] = UIImage(named: "headerTests2")!.jpegData(compressionQuality: 1)
        regularPhotoData["h3"] = UIImage(named: "headerTests3")!.jpegData(compressionQuality: 1)
    }
    
    private func addNewImagesToRegularPhotos() {
        newImages.forEach{
            regularPhotoData[$0.id] = $0.image
        }
    }
    
    private func populateNewImages() {
        newImages = [
            PhotoModel(
                id: "i1",
                title: nil,
                image: UIImage(named: "i1")!.jpegData(compressionQuality: 1)!
            ),
            PhotoModel(
                id: "i2",
                title: nil,
                image: UIImage(named: "i2")!.jpegData(compressionQuality: 1)!
            ),
            PhotoModel(
                id: "i3",
                title: nil,
                image: UIImage(named: "i3")!.jpegData(compressionQuality: 1)!
            ),
            PhotoModel(
                id: "i4",
                title: nil,
                image: UIImage(named: "i4")!.jpegData(compressionQuality: 1)!
            ),
            PhotoModel(
                id: "i5",
                title: nil,
                image: UIImage(named: "i5")!.jpegData(compressionQuality: 1)!
            )
        ]
        
        
    }
}
