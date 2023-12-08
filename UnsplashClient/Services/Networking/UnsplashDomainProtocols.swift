import Foundation

protocol UnsplashApiProtocol: AnyObject {
    static var shared: UnsplashApiProtocol { get }
    var newImages: [photoModel] { get set }
    
    var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void { get set }
    var tokenStorage: TokenStorageProtocol? { get set }
    
    func makeUrl(_ urlArg: String, target: urlTarget) -> URL?
    func exchangeCode(code: String) async -> TokenExchangeSuccessData?
    func getRandomPhoto() async -> UnsplashPhoto?
    func getCollections() async -> [UnsplashColletion]?
    func getNewImages(page pageNum: Int) async
    func getUnsplashImage(_ url: String, imageId: String ) async -> Data?
    func getPhoto(_ photoID: String) async -> photoData?
}

extension UnsplashApiProtocol {
    func makeUrl(target: urlTarget) -> URL?
       {
           return makeUrl("", target: target)
       }
}
