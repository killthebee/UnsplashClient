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
    
    @Published var newImages: [photoModel] = []
    
    func makeUrl(_ code: String = "", target: urlTarget) -> URL? {
        var urlComponents = URLComponents()
        let queryItems: [URLQueryItem]!
        switch target {
        case .codeExchange:
            queryItems = [
              URLQueryItem(name: "client_id", value: clientId),
              URLQueryItem(name: "client_secret", value: clientSecret),
              URLQueryItem(name: "redirect_uri", value: Urls.redirectUri.rawValue),
              URLQueryItem(name: "code", value: code),
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
              URLQueryItem(name: "page", value: code),
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
                                  "/\(code)" + Urls.newPhotosPath.rawValue)
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
            urlComponents.path = Urls.newPhotosPath.rawValue + "/\(code)"
        case .sharePhoto:
            queryItems = []
            urlComponents.host = Urls.unsplashHost.rawValue
            urlComponents.path = Urls.newPhotosPath.rawValue + "/\(code)"
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
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                    currentScreen: .intro,
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
                        currentScreen: .explore,
                        source: .headerImage
                    )
                }
            case let .failure(error):
                self.handleError(
                    error,
                    currentScreen: .explore,
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
                    currentScreen: .explore,
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
    
    func getNewImages(
        _ accessToken: String,
        page pageNum: Int,
        _ complitionHandler: @escaping ([photoModel]) async -> ()
    ) async {
        // that's ugly xD
        guard let url = makeUrl(String(pageNum), target: .newImages) else {
            return
        }
        
        let request = setupRequest(url, .get, accessToken)
//        let request = setupRequest(url, .get)
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
                    currentScreen: .explore,
                    source: .newImages
                )
            }
        }
    }
    
    func getCollectionCoverPhoto(
        _ imageURL: String,
        _ complitionHandler: @escaping (Data) async -> Void
    ) async {
        let imageUrl = URL(string: imageURL)!
        do {
            let (data, response) = try await URLSession.shared.data(from: imageUrl)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200
            else {
                throw networkingErrors.imageDownloadError
            }
            
             await complitionHandler(data)
        } catch {
            // TODO: mb do something about collection cover photo?
            print("failed to download cover photo; \(error)")
        }
    }
    
    private let cachePhotoData = Cache<String, photoModel>()
    private let cachePhotoMetadata = Cache<String, exifMetadata>()

    
    func getPhoto(
        _ accessToken: String,
        _ photoID: String,
        _ complitionHandler: @escaping (photoModel, exifMetadata) async -> Void
    ) async {
        guard let url = makeUrl(photoID, target: .getPhoto) else {
            return
        }
//        let request = setupRequest(url, .get)
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
                        currentScreen: .exif,
                        source: .getPhoto
                    )
                }
                
            case let .failure(error):
                self.handleError(
                    error,
                    currentScreen: .exif,
                    source: .getPhoto
                )
            }
        }
    }
}

// MARK: - error handling
extension UnsplashApi {
    
    enum CurrentScreen {
        case explore
        case intro
        case exif
    }
    
    private func handleError(
        _ error: Error,
        currentScreen: CurrentScreen,
        source: ErrorSource
    ) {
//         what a fucking epic syntaxis
        if let error = error as? networkingErrors {
            if case let . customError(errodData) = error,
               let responseWithError = try? JSONDecoder().decode(ResponseWithErrors.self, from: errodData) {
                // TODO: try to make it async with @MainActor
                Task {
                    await MainActor.run{
                        showPopup(
                            error,
                            currentScreen: currentScreen,
                            source: source
                        )
                    }
                }
                print("Unsplash errors: \(responseWithError.errors)")
            }
        } else {
            print("unsplash returned something else Oo")
        }
    }
    
    private func showPopup(
        _ error: Error,
        currentScreen: CurrentScreen,
        source: ErrorSource
    ) {
        // NOTE: So, the thing is, after intro, expolre is The rootView,
        // but exif, after explore, is not!
        guard
            var rootVC = UIApplication.shared.connectedScenes.compactMap(
                { ($0 as? UIWindowScene)?.keyWindow }
            ).last?.rootViewController
        else {
            return
        }
        
        let vc: InfoView!
        switch currentScreen {
        case .intro:
            guard let introVC = rootVC as? IntroViewController else {
                return
            }
            vc = InfoView(error, source: source, vc: introVC)
            vc.transitioningDelegate = introVC.customTransitioningDelegate
            vc.modalPresentationStyle = .custom
                
            introVC.present(vc, animated: true)
        case .explore:
            guard let exploreVC = rootVC as? ExploreViewController else {
                return
            }
            if source == .headerImage {
                exploreVC.presenter?.invalidateHeaderTask()
            }
            vc = InfoView(error, source: source, vc: exploreVC)
            vc.transitioningDelegate = exploreVC.customTransitioningDelegate
            vc.modalPresentationStyle = .custom
                
            exploreVC.present(vc, animated: true)
        case .exif:
            guard let visibleVC = UIApplication.shared.connectedScenes.compactMap(
                { ($0 as? UIWindowScene)?.keyWindow }
            ).last?.visibleViewController else { return }
            guard let exifVC = visibleVC as? ExifViewController else {
                return
            }
            
            vc = InfoView(error, source: source, vc: exifVC)
            vc.transitioningDelegate = exifVC.customTransitioningDelegate
            vc.modalPresentationStyle = .custom
                
            exifVC.present(vc, animated: true)
        }
    }
}
