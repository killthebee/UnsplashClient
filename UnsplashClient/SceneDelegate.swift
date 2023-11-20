import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appRouter = AppRouter()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        bindErrorHandler()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appRouter.makeFirstScreen().toVC()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func bindErrorHandler() {
        UnsplashApi.shared.errorPresentationHandler = { [weak self] source in
            await self?.appRouter.presentErrorBottomSheet(source)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

