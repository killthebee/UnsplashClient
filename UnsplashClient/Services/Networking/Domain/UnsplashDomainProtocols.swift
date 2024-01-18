import Foundation

protocol UnsplashApiProtocol: AnyObject {
    static var shared: UnsplashApiProtocol { get }
    var newImages: [PhotoModel] { get set }
    
    var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void { get set }
    var tokenStorage: TokenStorageProtocol? { get set }
    
    func makeUrl(_ urlArg: String, target: urlTarget) -> URL?
    func exchangeCode(code: String) async -> TokenExchangeSuccessData?
    func getRandomPhoto() async -> UnsplashPhoto?
    func getCollections() async -> [UnsplashColletion]?
    func getNewImagesData(page pageNum: Int) async -> [UnsplashPhoto]?
    func getUnsplashImage(
        _ url: String,
        imageId: String,
        isThumb: Bool
    ) async -> (Data?, Bool)
    func getPhoto(_ photoID: String) async -> PhotoData?
}

extension UnsplashApiProtocol {
    func makeUrl(target: urlTarget) -> URL? {
           return makeUrl("", target: target)
       }
    
    func getUnsplashImage(
        _ url: String,
        imageId: String
    ) async -> (Data?, Bool) {
        return await getUnsplashImage(url, imageId: imageId, isThumb: false)
    }
}
