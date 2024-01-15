import Foundation

class ExplorePresenter: ExplorePresenterProtocol {
    weak var view: ExploreViewProtocol?
    var interactor: ExploreInteractorProtocol?
    var router: ExploreRouterProtocol?
    
    required init(view: ExploreViewProtocol) {
        self.view = view
    }
    
    func startHeaderImageTask() {
        interactor?.startHeaderImageTask()
    }
    
    @MainActor
    func setNewHeaderImage(_ imageData: UnsplashPhoto) async {
        let topBannerData = TopBannerModel(
            urls: imageData.urls,
            id: imageData.id,
            photographerName: imageData.user.name
        )
        view?.setNewHeaderImage(topBannerData)
    }
    
    func getCollections() {
        interactor?.getCollections()
    }
    
    @MainActor
    func setColletions(with collectionsData: [UnsplashColletion]) async {
        view?.setCollections(with: collectionsData)
    }
    
    func getNewImages(page pageNum: Int) {
        interactor?.getNewImages(page: pageNum)
    }
    
    func addNewImages(photos newImages: [PhotoModel]) {
        view?.addNewImages(
            photos: newImages
        )
    }
    
    func setNewImages(photos newImages: [PhotoModel]) {
        view?.setNewImages(
            photos: newImages
        )
    }
    
    func presentExifScreen(photoId: String) {
        interactor?.invalidateHeaderTask()
        router?.presentExifDataScreen(photoId: photoId)
    }
    
    func invalidateHeaderTask() {
        interactor?.invalidateHeaderTask()
    }
    
    private func makePhotoModel(
        id: String,
        title: String? = nil,
        imageData: Data
    ) -> PhotoModel {
        return PhotoModel(id: id, title: title, image: imageData)
    }
}
