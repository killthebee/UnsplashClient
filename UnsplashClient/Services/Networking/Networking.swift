import Foundation

struct Networking {
    
    private func makeUrl(_ code: String) -> URL? {
        let queryItems = [
          URLQueryItem(name: "client_id", value: clientId),
          URLQueryItem(name: "client_secret", value: clientSecret),
          URLQueryItem(name: "redirect_uri", value: Urls.redirectUri.rawValue),
          URLQueryItem(name: "code", value: code),
          URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = HTTPScheme.secure.rawValue
        urlComponents.host = Urls.unsplashHost.rawValue
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    func setupRequest(
        _ url: URL,
        _ method: HTTPMethod
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    func performRequest(
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
        guard let url = makeUrl(code) else {
            return
        }
        
        let request = setupRequest(url, .post)
        performRequest(request, successHandler)
    }
}
