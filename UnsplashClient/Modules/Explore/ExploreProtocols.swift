import Foundation

protocol ExploreViewProtocol: AnyObject {
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
}

protocol ExploreConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExploreViewController)
}

protocol ExplorePresenterProtocol: AnyObject {
    func startHeaderImageTask()
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
}

protocol ExploreRouterProtocol: AnyObject {
    
}

protocol ExploreInteractorProtocol: AnyObject {
    func startHeaderImageTask()
}


