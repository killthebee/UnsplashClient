import UIKit

class AppAssembly {
    
    let keychainService: TokenStorageProtocol!
    
    init (keychainService: TokenStorageProtocol) {
        self.keychainService = keychainService
    }
}

// MARK: - IntroScreen
extension AppAssembly {
    
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
    
    func makeExifScreen(photoId: String) -> Presentable {
        let exifVC = ExifViewController()
        exifVC.photoId = photoId
        let configurator = ExifConfigurator(assembly: self)
        configurator.configure(with: exifVC)
        return exifVC
    }
}

// MARK: - current VCs
extension AppAssembly {
    
    func getRootVC() -> Presentable? {
        let vc = UIApplication.shared.connectedScenes.compactMap(
            { ($0 as? UIWindowScene)?.keyWindow }
        ).last?.rootViewController
        
        return vc
    }
    
    func getVisibleVC() -> Presentable? {
        let vc = UIApplication.shared.connectedScenes.compactMap(
            { ($0 as? UIWindowScene)?.keyWindow }
        ).last?.visibleViewController
        
        return vc
    }
}

// MARK: - Info Vc
extension AppAssembly {
    
    func getInfoVC(
        currentVC: UIViewController,
        source: ErrorSource,
        _ transitionDelegate: BSTransitioningDelegate
    ) -> InfoView {
        let vc = InfoView(source: source, vc: currentVC)
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        
        return vc
    }
}
