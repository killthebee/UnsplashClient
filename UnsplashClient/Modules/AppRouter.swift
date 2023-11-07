class AppRouter {
    
    var assembly = AppAssembly(keychainService: KeyChainManager())
    
    func makeFirstScreen() -> Presentable {
//        return makeExifScreen()
        if let accessToken = assembly.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) {
            return assembly.makeExploreScreen()
        }
        
        return assembly.makeIntroScreen()
    }
}
