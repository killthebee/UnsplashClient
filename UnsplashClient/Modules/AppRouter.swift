class AppRouter {
    
    var assembly = AppAssembly(keychainService: KeyChainManager())
    
    func makeFirstScreen() -> Presentable {
//        return assembly.makeExifScreen()
        if CommandLine.arguments.contains("UI_tests") {
            return assembly.makeExploreScreen()
        }
        if let _ = assembly.keychainService.getToken() {
            return assembly.makeExploreScreen()
        }
        
        return assembly.makeIntroScreen()
    }
    
    @MainActor
    func presentErrorBottomSheet(
        _ source: ErrorSource
    ) async {
        let vc: InfoView!
        switch source {
        case .codeExchange:
            guard
                let introVC = assembly.getRootVC() as? IntroViewController,
                let transitionDelegate = introVC.presenter?.router?.customTransitioningDelegate
            else {
                return
            }
            vc = assembly.getInfoVC(
                currentVC: introVC,
                source: source,
                transitionDelegate
            )
            
            introVC.present(vc, animated: true)
        case .headerImage, .collections, .newImages:
            guard
                let exploreVC = assembly.getRootVC() as? ExploreViewController,
                let transitionDelegate = exploreVC.presenter?.router?.customTransitioningDelegate
            else {
                return
            }
            if source == .headerImage {
                exploreVC.presenter?.invalidateHeaderTask()
            }
            vc = assembly.getInfoVC(
                currentVC: exploreVC,
                source: source,
                transitionDelegate
            )
            
            exploreVC.present(vc, animated: true)
        case .getPhoto:
            guard
                let exifVC = assembly.getVisibleVC() as? ExifViewController,
                let transitionDelegate = exifVC.presenter?.router?.customTransitioningDelegate
            else {
                return
            }
            
            vc = assembly.getInfoVC(
                currentVC: exifVC,
                source: source,
                transitionDelegate
            )
                
            exifVC.present(vc, animated: true)
        }
    }
}
