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
    
    public var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void = { _ in }
    
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
        code: String,
        _ complitionHandler: @escaping (TokenExchangeSuccessData) async -> Void
    ) async {
        guard let url = makeUrl(code, target: .codeExchange) else {
            return
        }
        
        let request = setupRequest(url, .post)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<TokenExchangeSuccessData, Error>) in
            switch result {
            case let .success(accessToken):
                await complitionHandler(accessToken)
            case let .failure(error):
                self.handleError(
                    error,
                    source: .codeExchange
                )
            }
        }
    }
    
    func getRandomPhoto(
        _ accessToken: String,
        _ complitionHandler: @escaping (photoModel) async -> Void
    ) async {
        guard let url = makeUrl(target: .randomPhoto) else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<UnsplashPhoto, Error>) async in
            switch result {
            case let .success(PhotoData):
                do {
                    let image = try await Networking.shared.getImage(
                        id: "whatever",
                        title: PhotoData.user.name,
                        imageURL: PhotoData.urls.thumb
                    )
                    await complitionHandler(image)
                } catch {
                    self.handleError(
                        error,
                        source: .headerImage
                    )
                }
            case let .failure(error):
                self.handleError(
                    error,
                    source: .headerImage
                )
            }
        }
    }
    
    func getCollections(
        _ accessToken: String,
        _ complitionHandler: @escaping ([UnsplashColletion]) async -> Void
    ) async {
        guard let url = makeUrl(target: .collectionList) else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<[UnsplashColletion], Error>) async in
            switch result {
            case let .success(collections):
                await complitionHandler(collections)
            case let .failure(error):
                self.handleError(
                    error,
                    source: .collections
                )
            }
        }
    }
    
    private func downloadImagesAsync(with response: [UnsplashPhoto]) async {
        do {
            try await withThrowingTaskGroup(of: photoModel.self) { taskGroup in
                for unslpashPhotoData in response {
                    taskGroup.addTask{
                        try await Networking.shared.getImage(
                            id: unslpashPhotoData.id,
                            imageURL: unslpashPhotoData.urls.thumb
                        )
                    }
                }
                
                while let newPhotoModel = try await taskGroup.next() {
                    newImages.append(newPhotoModel)
                }
            }
        } catch {
            print(error)
        }
    }
    
    var counter  = 0
    
    func getNewImages(
        _ accessToken: String,
        page pageNum: Int,
        _ complitionHandler: @escaping ([photoModel]) async -> ()
    ) async {
        guard let url = makeUrl(String(pageNum), target: .newImages) else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<[UnsplashPhoto], Error>) async in
            switch result {
            case let .success(PhotosData):
                await self.downloadImagesAsync(with: PhotosData)
                await complitionHandler(self.newImages)
            case let .failure(error):
                self.handleError(
                    error,
                    source: .newImages
                )
            }
        }
    }
    
    func getCollectionCoverPhoto(
        _ collectionData: UnsplashColletion,
        _ complitionHandler: @escaping (photoModel) async -> Void
    ) async {
        do {
            let photoData = try await Networking.shared.getImage(
                id: collectionData.id,
                title: collectionData.title,
                imageURL: collectionData.cover_photo.urls.thumb
            )
            await complitionHandler(photoData)
        } catch {
            self.handleError(
                error,
                source: .collections
            )
        }
    }
    
    private let cachePhotoData = Cache<String, photoModel>()
    private let cachePhotoMetadata = Cache<String, exifMetadata>()
    // NOTE: keep photoModel and exifMetadat at same cell seems moronic to me
    // NOTE: hash for photoID stays the same, but, hash for url from photoData
    // does not despite url string is really the same combination of letters,
    // it's boggles me
    func getPhoto(
        _ accessToken: String,
        _ photoID: String,
        _ complitionHandler: @escaping (photoModel, exifMetadata) async -> Void
    ) async {
        guard let url = makeUrl(photoID, target: .getPhoto) else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        if let imageData = self.cachePhotoData[photoID] {
            if let metadata = cachePhotoMetadata[photoID] {
                await complitionHandler(imageData, metadata)
                return
            }
        }
        await Networking.shared.performRequest(
            request
        ) { (result: Result<photoData, Error>) async in
            switch result {
            case let .success(PhotosData):
                do {
                    let imageData = try await Networking.shared.getImage(
                        id: "whatever",
                        imageURL: PhotosData.urls.raw
                    )
                    self.cachePhotoData[photoID] = imageData
                    self.cachePhotoMetadata[photoID] = PhotosData.exif
                    await complitionHandler(imageData, PhotosData.exif)
                } catch {
                    self.handleError(
                        error,
                        source: .getPhoto
                    )
                }
                
            case let .failure(error):
                self.handleError(
                    error,
                    source: .getPhoto
                )
            }
        }
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
