import Foundation

enum networkingErrors: Error {
    case imageDownloadError
    case customError(Data)
}

enum urlTarget {
    case codeExchange
    case randomPhoto
    case collectionList
    case newImages
    case collectionPhotos
}

struct ResponseWithErrors: Decodable {
    let errors: [String]
}

struct Networking {
    
    static let shared = Networking()
    
    private func makeUrl(_ code: String = "", target: urlTarget) -> URL? {
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
              URLQueryItem(name: "per_page", value: "6"),
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
    
    func performRequest<ResponseType: Decodable>(
        _ request: URLRequest,
        _ complitionHandler: @escaping (Result<ResponseType, Error>) async -> Void
    ) async {
        // TODO: chech whether i really need those returns!
        await performRequest(request) { result async in
            switch result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(
                        ResponseType.self,
                        from: data
                    )
                    await complitionHandler(.success(responseObject))
                } catch {
                    await complitionHandler(.failure(error))
                }
            case .failure(let error):
                await complitionHandler(.failure(error))
            }
        }
    }
    
    func performRequest(
        _ request: URLRequest,
        _ complitionHandler: @escaping (Result<Data, Error>) async -> Void
    ) async {
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard
                let response = response as? HTTPURLResponse
            else {
                return await complitionHandler(.failure(URLError(.badServerResponse)))
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                return await complitionHandler(.failure(networkingErrors.customError(data)))
            }
            
            
            return await complitionHandler(.success(data))
        } catch {
            return await complitionHandler(.failure(error))
        }
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                return complitionHandler(.failure(error))
//            }
//
//            guard
//                let response = response as? HTTPURLResponse,
//                let data = data
//            else {
//                return complitionHandler(.failure(URLError(.badServerResponse)))
//            }
//
//            guard (200 ... 299) ~= response.statusCode else {
//                return complitionHandler(.failure(networkingErrors.customError(data)))
//            }
//
//            return complitionHandler(.success(data))
//        }.resume()
    }
    
    func performRequest1(
        _ request: URLRequest,
        _ successHandler: @escaping (Data) throws -> (),
        _ failureHandler: @escaping (Data) throws -> () = { _ in }
    ) {
        let tast = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            guard (200 ... 299) ~= response.statusCode else {
                do {
                    try failureHandler(data)
                    print(String(data: data, encoding: .utf8))
                } catch {
                    print(error)

                    if let responseString = String(data: data, encoding: .utf8) {
                        print("responseString = \(responseString)")
                    } else {
                        print("unable to parse response as string")
                    }
                }
                return
            }
            do {
                try successHandler(data)
            } catch {
                print(error)

                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }

        tast.resume()
    }
    
    func exchangeCode(
        code: String,
        _ successHandler: @escaping (Data) throws -> ()
    ) {
        guard let url = makeUrl(code, target: .codeExchange) else {
            return
        }
        
        let request = setupRequest(url, .post)
//        performRequest(request, successHandler)
    }
    
    func getRandomPhoto(
        _ accessToken: String,
        _ successHandler: @escaping (Data) throws -> ()
    ) {
        //Optional("{\"errors\":[\"OAuth error: The access token is invalid\"]}")
        // TODO: make a faulire handler to hadle ^
        guard let url = makeUrl(target: .randomPhoto) else {
            return
        }
        var request = setupRequest(url, .get, accessToken)
//        performRequest(request, successHandler)
    }
    
    func getCollections(
        _ accessToken: String,
        _ complitionHandler: @escaping ([UnsplashColletion]) async -> Void
    ) async {
        guard let url = makeUrl(target: .collectionList) else {
            return
        }
        var request = setupRequest(url, .get, accessToken)
        await performRequest(request) { (result: Result<[UnsplashColletion], Error>) async in
            switch result {
            case let .success(collections):
                await complitionHandler(collections)
            case let .failure(error):
                if let error = error as? networkingErrors {
                    handleError(error)
                } else {
                    print("unsplash returned something else Oo")
                }
                print("!!11")
                //                print(type(of: error))
                //TODO: remove token and look at errors :)
            }
        }
    }
    
    func handleError(_ error: networkingErrors) {
//         wtf is going on here what a fucking epic syntaxis
        if case let . customError(errodData) = error as? networkingErrors,
           let responseWithError = try? JSONDecoder().decode(ResponseWithErrors.self, from: errodData) {
            print("gonna make a vsplivashka pop up!")
            print("Unsplash errors: \(responseWithError.errors)")
        }
    }
    
    func getNewImages(
        _ accessToken: String,
        page pageNum: Int,
        _ successHandler: @escaping (Data) throws -> ()
    ) {
        // that's ugly xD
        guard let url = makeUrl(String(pageNum), target: .newImages) else {
            return
        }
        
        var request = setupRequest(url, .get, accessToken)
//        performRequest(request, successHandler)
    }
    
    func getCollectionPhotos(
        // TODO: think about refactoring( merging with func above ) (:
        // i mean this whole code/page/id arg situations looks kinda ugly
        _ accessToken: String,
        id: String,
        _ successHandler: @escaping (Data) throws -> ()
    ) {
        guard let url = makeUrl(id, target: .collectionPhotos) else {
            return
        }
        
        var request = setupRequest(url, .get, accessToken)
//        performRequest(request, successHandler)
    }
}

//@MainActor
class AsyncNetworking: ObservableObject {
    // NOTE: the only thing keeping me from merging networkings into 1 class is the shared property. Should I merge anyway tho?
    
    @Published var newImages: [photoModel] = []
    @Published var collectionImages: [photoModel] = []
    
    func getImage(
        id: String,
        title: String? = nil,
        imageURL: String
    ) async throws -> photoModel {
        let imageUrl = URL(string: imageURL)!
        let (data, response) = try await URLSession.shared.data(from: imageUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw networkingErrors.imageDownloadError
        }
        
        return photoModel(id: id, title: title, image: data)
    }
    
    func downloadImagesAsync(with response: [UnsplashPhoto]) async {
        do {
            // NOTE: here i learned that async let in forloop doesnt work coz amount of tasks is dynamic ( calculated in runtime ? )
            try await withThrowingTaskGroup(of: photoModel.self) { taskGroup in
                for unslpashPhotoData in response {
                    taskGroup.addTask{
                        try await self.getImage(
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
    
    func downloadCollections(with response: [UnsplashColletion]) async {
        do {
            try await withThrowingTaskGroup(of: photoModel.self) { taskGroup in
                for unslpashPhotoData in response {
                    taskGroup.addTask{
                        try await self.getImage(
                            id: unslpashPhotoData.id,
                            title: unslpashPhotoData.title,
                            imageURL: unslpashPhotoData.cover_photo.urls.thumb
                        )
                    }
                }
                
                while let newPhotoModel = try await taskGroup.next() {
                    collectionImages.append(newPhotoModel)
                }
            }
        } catch {
            print(error)
        }
    }
}
