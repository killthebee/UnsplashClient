// not so sure about file name...
// I need to find the way to safly store keys

import AuthenticationServices

class LoginSession: NSObject {
    
    static let standard = LoginSession()
    
    func performLogin() {
        let authenticationSession = ASWebAuthenticationSession(
            url: makeLoginUrlWithParams(),
            callbackURLScheme: collbackScheme
        ) { [weak self] callbackURL, error in
            guard error == nil else {
                print(error)
                return
            }
            print(callbackURL)
        }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
            print("Failed to start ASWebAuthenticationSession")
        }
    }
    
    func makeLoginUrlWithParams() -> URL {
        var urlComps = URLComponents(string: Urls.login.rawValue)!
        let queryItems = [
          URLQueryItem(name: "client_id", value: clientId),
          URLQueryItem(name: "redirect_uri", value: collbackScheme + "://unsplash"),
          URLQueryItem(name: "response_type", value: "code"),
          URLQueryItem(name: "scope", value: "public")
        ]
        urlComps.queryItems = queryItems
        
        return urlComps.url!
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
