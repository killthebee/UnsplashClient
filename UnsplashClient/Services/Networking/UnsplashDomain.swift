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
    
    private func makePhotoModel(
        id: String,
        title: String,
        imageData: Data
    ) -> photoModel {
        return photoModel(id: id, title: title, image: imageData)
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
        _ complitionHandler: @escaping (photoModel) async -> Void
    ) async {
        guard
            let url = makeUrl(target: .randomPhoto),
            let accessToken = tokenStorage?.getToken()
        else {
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
                        PhotoData.urls.thumb
                    )
                    let imageDataModel = photoModel(
                        id: "whatever",
                        title: PhotoData.user.name,
                        image: image
                    )
                    await complitionHandler(imageDataModel)
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
        _ complitionHandler: @escaping ([UnsplashColletion]) async -> Void
    ) async {
        guard
            let url = makeUrl(target: .collectionList),
            let accessToken = tokenStorage?.getToken()
        else {
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
                        self.makePhotoModel(
                            id: unslpashPhotoData.id,
                            title: "replace with nil",
                            imageData: try await Networking.shared.getImage(
                                unslpashPhotoData.urls.thumb
                            )
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
    
    func getNewImages(
        page pageNum: Int,
        _ complitionHandler: @escaping ([photoModel]) async -> ()
    ) async {
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
                collectionData.cover_photo.urls.thumb
            )
            let imageDataModel = makePhotoModel(
                id: collectionData.id,
                title: collectionData.title,
                imageData: photoData)
            await complitionHandler(imageDataModel)
        } catch {
            self.handleError(
                error,
                source: .collections
            )
        }
    }
    
    private let cachePhotoData = Cache<String, photoAndExifModel>()
    
    func getPhoto(
        _ photoID: String,
        _ complitionHandler: @escaping (photoModel, exifMetadata) async -> Void
    ) async {
        guard
            let url = makeUrl(photoID, target: .getPhoto),
            let accessToken = tokenStorage?.getToken()
        else {
            return
        }
        let request = setupRequest(url, .get, accessToken)
        if let photoData = self.cachePhotoData[photoID] {
            await complitionHandler(photoData.photoModel, photoData.exifData)
            return
        }
        await Networking.shared.performRequest(
            request
        ) { (result: Result<photoData, Error>) async in
            switch result {
            case let .success(PhotosData):
                do {
                    let imageData = try await Networking.shared.getImage(
                        PhotosData.urls.raw
                    )
                    let imageDataModel = self.makePhotoModel(
                        id: "whatever",
                        title: "whatever",
                        imageData: imageData
                    )
                    self.cachePhotoData[photoID] = photoAndExifModel(
                        photoModel: imageDataModel,
                        exifData: PhotosData.exif
                    )
                    await complitionHandler(imageDataModel, PhotosData.exif)
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
