import UIKit

class UnsplashApi: ObservableObject {
    
    enum urlTarget {
        case codeExchange
        case randomPhoto
        case collectionList
        case newImages
        case collectionPhotos
        case login
        case getPhoto
        case sharePhoto
    }
    
    static let shared = UnsplashApi()
    
    // check app router
    public var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void = { _ in }
    
    var tokenStorage: TokenStorageProtocol?
    
    @Published var newImages: [photoModel] = []
    
    func makeUrl(_ urlArg: String = "", target: urlTarget) -> URL? {
        var urlComponents = URLComponents()
        let queryItems: [URLQueryItem]!
        switch target {
        case .codeExchange:
            queryItems = [
              URLQueryItem(name: "client_id", value: clientId),
              URLQueryItem(name: "client_secret", value: clientSecret),
              URLQueryItem(name: "redirect_uri", value: Urls.redirectUri.rawValue),
              URLQueryItem(name: "code", value: urlArg),
              URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            urlComponents.host = Urls.unsplashHost.rawValue
            urlComponents.path = Urls.tokenExchangePath.rawValue
        case .randomPhoto:
            queryItems = [
              URLQueryItem(name: "orientation", value: "landscape"),
            ]
            urlComponents.host = Urls.unslpashApiHost.rawValue
            urlComponents.path = Urls.randomPhotoPath.rawValue
        case .collectionList:
            queryItems = [
              URLQueryItem(name: "per_page", value: "5"),
            ]
            urlComponents.host = Urls.unslpashApiHost.rawValue
            urlComponents.path = Urls.collectionList.rawValue
        case .newImages:
            queryItems = [
              URLQueryItem(name: "per_page", value: "5"),
              URLQueryItem(name: "page", value: urlArg),
            ]
            urlComponents.host = Urls.unslpashApiHost.rawValue
            urlComponents.path = Urls.newPhotosPath.rawValue
        case .collectionPhotos:
            queryItems = [
              URLQueryItem(name: "per_page", value: "5"),
              URLQueryItem(name: "page", value: "1"),
              URLQueryItem(name: "orientation", value: "landscape"),
            ]
            urlComponents.host = Urls.unslpashApiHost.rawValue
            urlComponents.path = (Urls.collectionList.rawValue +
                                  "/\(urlArg)" + Urls.newPhotosPath.rawValue)
        case .login:
            queryItems = [
              URLQueryItem(name: "client_id", value: clientId),
              URLQueryItem(name: "redirect_uri", value: Urls.redirectUri.rawValue),
              URLQueryItem(name: "response_type", value: "code"),
              URLQueryItem(name: "scope", value: "public")
            ]
            urlComponents.host = Urls.unsplashHost.rawValue
            urlComponents.path = Urls.loginPath.rawValue
        case .getPhoto:
            queryItems = []
            urlComponents.host = Urls.unslpashApiHost.rawValue
            urlComponents.path = Urls.newPhotosPath.rawValue + "/\(urlArg)"
        case .sharePhoto:
            queryItems = []
            urlComponents.host = Urls.unsplashHost.rawValue
            urlComponents.path = Urls.newPhotosPath.rawValue + "/\(urlArg)"
        }
        urlComponents.scheme = HTTPScheme.secure.rawValue
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    func setupRequest(
        _ url: URL,
        _ method: HTTPMethod,
        _ accessToken: String? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let accessToken = accessToken {
            request.setValue(
                "Bearer \(accessToken)", forHTTPHeaderField: "Authorization"
            )
        }
        
        return request
    }
    
    func exchangeCode(
        code: String
    ) async -> TokenExchangeSuccessData? {
        var tokenExchangeData: TokenExchangeSuccessData? = nil
        guard let url = makeUrl(code, target: .codeExchange) else {
            return tokenExchangeData
        }
        
        let request = setupRequest(url, .post)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<TokenExchangeSuccessData, Error>) in
            switch result {
            case let .success(accessToken):
                tokenExchangeData = accessToken
            case let .failure(error):
                self.handleError(
                    error,
                    source: .codeExchange
                )
            }
        }
        
        return tokenExchangeData
    }
    
    func getRandomPhoto() async -> UnsplashPhoto? {
        var photo: UnsplashPhoto? = nil
        guard
            let url = makeUrl(target: .randomPhoto),
            let accessToken = tokenStorage?.getToken()
        else {
            return photo
        }
        
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<UnsplashPhoto, Error>) async in
            switch result {
            case let .success(photoData):
                photo = photoData
            case let .failure(error):
                self.handleError(
                    error,
                    source: .headerImage
                )
            }
        }
        
        return photo
    }
    
    func getCollections() async -> [UnsplashColletion]? {
        var unsplashCollections: [UnsplashColletion]? = nil
        guard
            let url = makeUrl(target: .collectionList),
            let accessToken = tokenStorage?.getToken()
        else {
            return unsplashCollections
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<[UnsplashColletion], Error>) async in
            switch result {
            case let .success(collections):
                unsplashCollections = collections
            case let .failure(error):
                self.handleError(
                    error,
                    source: .collections
                )
            }
        }
        
        return unsplashCollections
    }
    
    private func downloadImagesAsync(with response: [UnsplashPhoto]) async {
        do {
            try await withThrowingTaskGroup(of: photoModel.self) { taskGroup in
                for unslpashPhotoData in response {
                    taskGroup.addTask{
                        photoModel(
                            id: unslpashPhotoData.id,
                            title: nil,
                            image: try await Networking.shared.getImage(
                                unslpashPhotoData.urls.thumb
                            )
                        )
                    }
                }
                
                while let newPhotoData = try await taskGroup.next() {
                    newImages.append(newPhotoData)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getNewImages(page pageNum: Int) async {
        guard
            let url = makeUrl(String(pageNum), target: .newImages),
            let accessToken = tokenStorage?.getToken()
        else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<[UnsplashPhoto], Error>) async in
            switch result {
            case let .success(photosData):
                await self.downloadImagesAsync(with: photosData)
            case let .failure(error):
                self.handleError(
                    error,
                    source: .newImages
                )
            }
        }
    }
    
    let unsplashPhotoDataCache = Cache<String, Data>()
    
    func getUnsplashImage(
        _ url: String,
        imageId: String
    ) async -> Data? {
        if let imageData = unsplashPhotoDataCache[imageId] {
            return imageData
        }
        do {
            let photoData = try await Networking.shared.getImage(
                url
            )
            unsplashPhotoDataCache[imageId] = photoData
            
            return photoData
        } catch {
            // TODO: Think about error handling!
//            self.handleError(
//                error,
//                source: .collections
//            )
            return nil
        }
    }
    
    func getPhoto(
        _ photoID: String
    ) async -> photoData? {
        var photoDataAndExif: photoData? = nil
        guard
            let url = makeUrl(photoID, target: .getPhoto),
            let accessToken = tokenStorage?.getToken()
        else {
            return photoDataAndExif
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<photoData, Error>) async in
            switch result {
            case let .success(DownloadedPhotoDataAndExif):
                photoDataAndExif = DownloadedPhotoDataAndExif
            case let .failure(error):
                self.handleError(
                    error,
                    source: .getPhoto
                )
            }
        }
        
        return photoDataAndExif
    }
}

// MARK: - error handling
extension UnsplashApi {
    
    private func handleError(
        _ error: Error,
        source: ErrorSource
    ) {
//         what an epic syntaxis
        if let error = error as? networkingErrors {
            if case let . customError(errodData) = error,
               let responseWithError = try? JSONDecoder().decode(
                ResponseWithErrors.self, from: errodData
               ) {
                Task {
                    await errorPresentationHandler(source)
                }
                print("Unsplash errors: \(responseWithError.errors)")
            }
        } else {
            print("unsplash returned something else Oo")
        }
    }
        
}
