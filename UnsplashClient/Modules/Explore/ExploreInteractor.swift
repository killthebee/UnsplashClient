import Foundation

// NOTE: btw, i think my success closures making a strong link to interactor, mb i should use capture manager to mark this links as weak?

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
        
        let successHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                UnsplashPhoto.self,
                from: data
            )
            let imageDownloadUrl = URL(string: responseObject.urls.raw)!
            let photographerName = responseObject.user.name
            if let imageData = try? Data(contentsOf: imageDownloadUrl) {
                DispatchQueue.main.async {
                    self.presenter?.setNewHeaderImage(
                        imageData: imageData,
                        photographerName
                    )
                }
            }
        }
        
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) {_ in
            Networking.shared.getRandomPhoto(accessToken, successHandler)
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
        
//        let successHandler = { (data: Data) throws in
//            let responseObject = try JSONDecoder().decode(
//                [UnsplashColletion].self,
//                from: data
//            )
//            Task {
//                let asyncNetworking = AsyncNetworking()
//                await asyncNetworking.downloadCollections(with: responseObject)
//                await MainActor.run {
//                    self.presenter?.setColletions(
//                        with: asyncNetworking.collectionImages
//                    )
//                }
//            }
//        }
        let complitionHandler = { [weak self] (collections: [UnsplashColletion]) in
            let asyncNetworking = AsyncNetworking()
            await asyncNetworking.downloadCollections(with: collections)
            await MainActor.run { [weak self] in
                self?.presenter?.setColletions(
                    with: asyncNetworking.collectionImages
                )
            }
            
            
        }
        Task {
            await Networking.shared.getCollections(
                accessToken, complitionHandler)
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
        let successHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                [UnsplashPhoto].self,
                from: data
            )
            Task {
                let asyncNetworking = AsyncNetworking()
                await asyncNetworking.downloadImagesAsync(with: responseObject)
                await MainActor.run {
                    // Do i rly need suspention point here? is it even a suspention point or is it fires w/o waiting?! 96 to 97 looks pretty sync
                    // i mean, i'm tryin to figure out whether this await is
                    // givingup control of thread? And if so, is it necessary?
                    self.handlerNewImages(pageNum, asyncNetworking.newImages)
                }
            }
        }
        
        Networking.shared.getNewImages(
            accessToken,
            page: pageNum,
            successHandler
        )
    }
    
    func collectionSelected(id: String) {
        // TODO: Yeah, it must be a whole new screen... lol
        guard let accessToken = self.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        let successHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                [UnsplashPhoto].self,
                from: data
            )
            Task {
                let asyncNetworking = AsyncNetworking()
                await asyncNetworking.downloadImagesAsync(with: responseObject)
                await MainActor.run {
                    // NOTE: array might be empty
                    self.presenter?.setNewImages(photos: asyncNetworking.newImages)
                }
            }
        }
        
        Networking.shared.getCollectionPhotos(
            accessToken,
            id: id,
            successHandler
        )
    }
}
