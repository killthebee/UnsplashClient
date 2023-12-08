import Foundation

protocol ExploreViewProtocol: AnyObject {
    var presenter: ExplorePresenterProtocol? { get }
    func setNewHeaderImage(_ imageData: TopBannerModel)
    func setCollections(with collectionsData: [UnsplashColletion])
    func addNewImages(photos newImages: [photoModel])
    func setNewImages(photos newImages: [photoModel])
    func invalidateHeaderTask()
}

protocol ExploreConfiguratorProtocol: AnyObject {
    func configure(
        with viewController: ExploreViewController
    )
}

protocol ExplorePresenterProtocol: AnyObject {
    var router: ExploreRouterProtocol? { get }
    func startHeaderImageTask()
    func setNewHeaderImage(_ imageData: UnsplashPhoto) async
    func getCollections()
    func setColletions(with collectionsData: [UnsplashColletion]) async
    func getNewImages(page pageNum: Int)
    func addNewImages(photos newImages: [photoModel])
    func setNewImages(photos newImages: [photoModel])
    func presentExifScreen(photoId: String)
    func invalidateHeaderTask()
}

protocol ExploreRouterProtocol: AnyObject {
    func presentExifDataScreen(photoId: String)
    var customTransitioningDelegate: BSTransitioningDelegate { get }
}

protocol ExploreInteractorProtocol: AnyObject {
    func startHeaderImageTask()
    func getCollections()
    func getNewImages(page pageNum: Int)
    func invalidateHeaderTask()
}

protocol CarouselCellDelegateProtocol {
    var dataMap: [Int: Data] { get set }
}
