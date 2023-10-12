import Foundation

protocol ExploreViewProtocol: AnyObject {
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
    func setCollections(with collectionsData: [[photoModel]])
}

protocol ExploreConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExploreViewController)
}

protocol ExplorePresenterProtocol: AnyObject {
    func startHeaderImageTask()
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
    func getCollections()
    func setColletions(with collectionsData: [photoModel]) 
}

protocol ExploreRouterProtocol: AnyObject {
    
}

protocol ExploreInteractorProtocol: AnyObject {
    func startHeaderImageTask()
    func getCollections()
}


