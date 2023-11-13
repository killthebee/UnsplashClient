import Foundation

struct Networking {
    
    static let shared = Networking()
    
    func performRequest<ResponseType: Decodable>(
        _ request: URLRequest,
        _ complitionHandler: @escaping (Result<ResponseType, Error>) async -> Void
    ) async {
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
            // debug purposes 
//            if let responseString = String(data: data, encoding: .utf8) {
//                print("responseString = \(responseString)")
//            } else {
//                print("unable to parse response as string")
//            }
            guard
                let response = response as? HTTPURLResponse
            else {
                await complitionHandler(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                
                await complitionHandler(
                    .failure(networkingErrors.customError(data))
                )
                return
            }
            await complitionHandler(.success(data))
        } catch {
            await complitionHandler(.failure(error))
        }
    }
    
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
}
