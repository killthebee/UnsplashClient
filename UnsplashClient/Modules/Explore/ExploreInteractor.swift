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
    
    func getNewImages(page pageNum: Int) {
        Task {
            guard
                let newImagesData = await self.apiService?.getNewImagesData(
                    page: pageNum
                )
            else {
                return
            }
            await self.presenter?.addNewImages(newImagesData: newImagesData)
        }
    }
}
