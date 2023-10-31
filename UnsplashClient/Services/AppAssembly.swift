class AppAssembly {
    
    let keychainService: KeyChainManagerProtocol!
    
    init (keychainService: KeyChainManagerProtocol) {
        self.keychainService = keychainService
    }
}

// MARK: - IntroScreen
extension AppAssembly {
    
    func makeFirstScreen() -> Presentable {
//        return makeExifScreen()
        if let accessToken = keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) {
            return makeExploreScreen()
        }
        
        return makeIntroScreen()
    }
    
    func makeIntroScreen() -> Presentable {
        let introVC = IntroViewController()
        let configurator = IntroConfigurator(assembly: self)
        configurator.configure(with: introVC)
        return introVC
    }
}

// MARK: - ExploreScreen
extension AppAssembly {
    
    func makeExploreScreen() -> Presentable {
        let exploreVC = ExploreViewController()
        let configurator = ExploreConfigurator(assembly: self)
        configurator.configure(with: exploreVC)
        return exploreVC
    }
}

// MARK: - ExifScreen
extension AppAssembly {
    
    func makeExifScreen() -> Presentable {
        let exifVC = ExifViewController()
        let configurator = ExifConfigurator(assembly: self)
        configurator.configure(with: exifVC)
        return exifVC
    }
}

