import AuthenticationServices

class LoginSession: NSObject {
    
    static let standard = LoginSession()
    
    func performLogin(interactor: IntroInteractorProtocol) {
        guard let authUrl = UnsplashApi.shared.makeUrl(target: .login) else {
            return
        }
        
        let authenticationSession = ASWebAuthenticationSession(
            url: authUrl,
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
            Task {
                guard
                    let tokenExchangeData = await UnsplashApi.shared.exchangeCode(
                        code: code
                    )
                else {
                    return
                }
                interactor.keychainService.save(
                    Data(tokenExchangeData.access_token.utf8),
                    service: "access-token",
                    account: "unsplash"
                )
                interactor.showExploreScreen()
            }
        }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
            print("Failed to start ASWebAuthenticationSession")
        }
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
