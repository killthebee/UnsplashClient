import Foundation

class ExploreInteractor: ExploreInteractorProtocol {
    
    weak var presenter: ExplorePresenterProtocol?
    
    let apiService: UnsplashApiProtocol?
    
    var headerImageTaskTimer: Timer?
    
    required init(
        presenter: ExplorePresenterProtocol,
        apiService: UnsplashApiProtocol = AppAssembly.currentApiService
    ) {
        self.presenter = presenter
        self.apiService = apiService
    }
    
    func startHeaderImageTask() {
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) { _ in
            Task {
                guard
                    let imageData = await self.apiService?.getRandomPhoto()
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
                let collections = await self.apiService?.getCollections()
            else {
                return
            }
            await self.presenter?.setColletions(with: collections)
        }
    }
    
    @MainActor
    func handlerNewImages(
        _ pageNum: Int,
        _ images: [PhotoModel]
    ) async {
        if pageNum != 1 {
            self.presenter?.addNewImages(photos: images)
            return
        }
        self.presenter?.setNewImages(photos: images)
    }
    
    func getNewImages(page pageNum: Int) {
        Task {
            await self.apiService?.getNewImages(page: pageNum)
            let allImages: [PhotoModel] = self.apiService?.newImages ?? []
            let lastImageDataIndex = pageNum * 5 - 1
            let newPhotosData = Array(allImages[
                lastImageDataIndex - 4 ... lastImageDataIndex
            ])
            await self.handlerNewImages(
                pageNum,
                newPhotosData
            )
        }
    }
}
