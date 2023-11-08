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
    
    func handleError(_ error: Error) {
//         what a fucking epic syntaxis
        if let error = error as? networkingErrors {
            if case let . customError(errodData) = error,
               let responseWithError = try? JSONDecoder().decode(ResponseWithErrors.self, from: errodData) {
                // TODO: Wire BS here!
                print("gonna make a vsplivashka pop up!")
                print("Unsplash errors: \(responseWithError.errors)")
            }
        } else {
            print("unsplash returned something else Oo")
        }
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
                self.handleError(error)
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
                    self.handleError(error)
                }
            case let .failure(error):
                self.handleError(error)
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
                self.handleError(error)
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
        await Networking.shared.performRequest(
            request
        ) { (result: Result<[UnsplashPhoto], Error>) async in
            switch result {
            case let .success(PhotosData):
                await self.downloadImagesAsync(with: PhotosData)
                await complitionHandler(self.newImages)
            case let .failure(error):
                self.handleError(error)
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
            print("failed to download cover photo; \(error)")
        }
    }
    
    func getPhoto(
        _ accessToken: String,
        _ photoID: String,
        _ complitionHandler: @escaping (photoModel, exifMetadata) async -> Void
    ) async {
        guard let url = makeUrl(photoID, target: .getPhoto) else {
            return
        }
        print(url.absoluteString)
        let request = setupRequest(url, .get, accessToken)
        await Networking.shared.performRequest(
            request
        ) { (result: Result<photoData, Error>) async in
            switch result {
            case let .success(PhotosData):
                do {
                    print("????")
                    let imageData = try await Networking.shared.getImage(
                        id: "whatever",
                        imageURL: PhotosData.urls.raw
                    )
                    await complitionHandler(imageData, PhotosData.exif)
                } catch {
                    self.handleError(error)
                }
                
            case let .failure(error):
                self.handleError(error)
            }
        }
    }
}
