import AuthenticationServices

class LoginSession: NSObject {
    
    static let standard = LoginSession()
    
    func performLogin(interactor: IntroInteractorProtocol) {
        let signInSuccessHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                TokenExchangeSuccessData.self,
                from: data
            )
            interactor.keychainService.save(
                Data(responseObject.access_token.utf8),
                service: "access-token",
                account: "unsplash"
            )
            DispatchQueue.main.async {
                interactor.showExploreScreen()
            }
        }
        let authenticationSession = ASWebAuthenticationSession(
            url: makeLoginUrlWithParams(),
            callbackURLScheme: collbackScheme
        ) { callbackURL, error in
            guard
              error == nil,
              let callbackURL = callbackURL,
              let queryItems = URLComponents(
                string: callbackURL.absoluteString
              )?.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value
            else {
              print("An error occurred when attempting to sign in.")
              return
            }
            Networking().exchangeCode(code: code, signInSuccessHandler)
            
        }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
            print("Failed to start ASWebAuthenticationSession")
        }
    }
    
    func makeLoginUrlWithParams() -> URL {
        var urlComponents = URLComponents(string: Urls.login.rawValue)!
        let queryItems = [
          URLQueryItem(name: "client_id", value: clientId),
          URLQueryItem(name: "redirect_uri", value: Urls.redirectUri.rawValue),
          URLQueryItem(name: "response_type", value: "code"),
          URLQueryItem(name: "scope", value: "public")
        ]
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}

extension LoginSession: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window ?? ASPresentationAnchor()
    }
}
