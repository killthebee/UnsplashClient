import Foundation

class ExploreInteractor: ExploreInteractorProtocol {
    
    weak var presenter: ExplorePresenterProtocol?
    
    var headerImageTaskTimer: Timer?
    
    let keychainService: KeyChainManagerProtocol
    
    required init(
        presenter: ExplorePresenterProtocol,
        keychainService: KeyChainManagerProtocol
    ) {
        self.presenter = presenter
        self.keychainService = keychainService
    }
    
    func startHeaderImageTask() {
        guard let accessToken = self.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        let complition = { [weak self] (image: photoModel) async -> Void in
            await self?.presenter?.setNewHeaderImage(
                imageData: image.image,
                image.title ?? "unknown"
            )
        }
        
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) { _ in
            Task {
                await UnsplashApi.shared.getRandomPhoto(accessToken, complition)
            }
        }
        
        headerImageTaskTimer?.fire()
    }
    
    func invalidateHeaderTask() {
        headerImageTaskTimer?.invalidate()
    }
    
    func getCollections() {
        guard let accessToken = self.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        let compition = {
            [weak self] (collections: [UnsplashColletion]) async -> Void in
            await self?.presenter?.setColletions(with: collections)
        }
        
        Task {
            await UnsplashApi.shared.getCollections(accessToken,compition)
        }
    }
    
    @MainActor
    func handlerNewImages(_ pageNum: Int, _ images: [photoModel]) async {
        if pageNum != 1 {
            self.presenter?.addNewImages(photos: images)
            return
        }
        self.presenter?.setNewImages(photos: images)
    }
    
    func getNewImages(page pageNum: Int) {
        guard let accessToken = self.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        let complition = { [weak self] (photoModels: [photoModel]) async -> Void in
            await self?.handlerNewImages(pageNum, photoModels)
        }
        
        Task {
            await UnsplashApi.shared.getNewImages(
                accessToken,
                page: pageNum,
                complition
            )
        }
    }
    
//    func collectionSelected(id: String) {
//        // TODO: Yeah, it must be a whole new screen... lol
//        // Pretend this method doesnt exist pls
//        guard let accessToken = self.keychainService.readToken(
//            service: "access-token",
//            account: "unsplash"
//        ) else { return }
//
//        let successHandler = { (data: Data) throws in
//            let responseObject = try JSONDecoder().decode(
//                [UnsplashPhoto].self,
//                from: data
//            )
//            Task {
//                let asyncNetworking = AsyncNetworking()
//                await asyncNetworking.downloadImagesAsync(with: responseObject)
//                await MainActor.run {
//                    // NOTE: array might be empty
//                    self.presenter?.setNewImages(photos: asyncNetworking.newImages)
//                }
//            }
//        }
//
//        Networking.shared.getCollectionPhotos(
//            accessToken,
//            id: id,
//            successHandler
//        )
//    }
}
