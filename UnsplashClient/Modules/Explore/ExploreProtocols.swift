import Foundation

protocol ExploreViewProtocol: AnyObject {
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
    func setCollections(with collectionsData: [[UnsplashColletion]])
    func addNewImages(photos newImages: [photoModel])
    func setNewImages(photos newImages: [photoModel])
}

protocol ExploreConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExploreViewController)
}

protocol ExplorePresenterProtocol: AnyObject {
    func startHeaderImageTask()
    func setNewHeaderImage(imageData: Data, _ photographerName: String)
    func getCollections()
    func setColletions(with collectionsData: [UnsplashColletion])
    func getNewImages(page pageNum: Int)
    func addNewImages(photos newImages: [photoModel])
    func setNewImages(photos newImages: [photoModel])
    func presentExifScreen(photoId: String)
}

protocol ExploreRouterProtocol: AnyObject {
    func presentExifDataScreen(photoId: String)
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
