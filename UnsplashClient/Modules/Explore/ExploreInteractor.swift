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
        
        // TODO: do something, this nesting's cray-cray
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) { _ in
            Task {
                await UnsplashApi.shared.getRandomPhoto(
                    accessToken
                ) { [weak self] image in
                    await MainActor.run { [weak self] in
                        self?.presenter?.setNewHeaderImage(
                            imageData: image.image,
                            image.title ?? "unknown"
                        )
                    }
                }
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
        
        Task {
            await UnsplashApi.shared.getCollections(accessToken) { [weak self] collections in
                await MainActor.run { [weak self] in
                    self?.presenter?.setColletions(with: collections)
                }
            }
        }
    }
    
    func handlerNewImages(_ pageNum: Int, _ images: [photoModel]) {
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
        
        Task {
            await UnsplashApi.shared.getNewImages(
                accessToken,
                page: pageNum
            ) { [weak self] photoModels in
                await MainActor.run { [weak self] in
                    self?.handlerNewImages(pageNum, photoModels)
                }
            }
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
