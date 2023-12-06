import Foundation

class ExploreInteractor: ExploreInteractorProtocol {
    
    weak var presenter: ExplorePresenterProtocol?
    
    var headerImageTaskTimer: Timer?
    
    required init(
        presenter: ExplorePresenterProtocol
    ) {
        self.presenter = presenter
    }
    
    func startHeaderImageTask() {
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) { _ in
            Task {
                guard
                    let imageData = await UnsplashApi.shared.getRandomPhoto()
                else
                {
                    return
                }
                await self.presenter?.setNewHeaderImage(imageData)
            }
        }
        
        headerImageTaskTimer?.fire()
    }
    
    func invalidateHeaderTask() {
        headerImageTaskTimer?.invalidate()
    }
    
    func getCollections() {
        Task {
            guard
                let collections = await UnsplashApi.shared.getCollections()
            else {
                return
            }
            await self.presenter?.setColletions(with: collections)
        }
    }
    
    @MainActor
    func handlerNewImages(
        _ pageNum: Int,
        _ images: [photoModel]
    ) async {
        if pageNum != 1 {
            self.presenter?.addNewImages(photos: images)
            return
        }
        self.presenter?.setNewImages(photos: images)
    }
    
    func getNewImages(page pageNum: Int) {
        Task {
            await UnsplashApi.shared.getNewImages(page: pageNum)
            let lastImageDataIndex = pageNum * 5 - 1
            let newPhotosData = Array(UnsplashApi.shared.newImages[
                lastImageDataIndex - 4 ... lastImageDataIndex
            ])
            await self.handlerNewImages(
                pageNum,
                newPhotosData
            )
        }
    }
}
