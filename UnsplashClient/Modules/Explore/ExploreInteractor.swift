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
        
        let successHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                UnsplashPhoto.self,
                from: data
            )
            let imageDownloadUrl = URL(string: responseObject.urls.raw)!
            let photographerName = responseObject.user.name
            if let imageData = try? Data(contentsOf: imageDownloadUrl) {
                DispatchQueue.main.async {
                    self.presenter?.setNewHeaderImage(imageData: imageData, photographerName)
                }
            }
        }
        
        headerImageTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 20,
            repeats: true
        ) {_ in
            Networking().getRandomPhoto(accessToken, successHandler)
        }
        headerImageTaskTimer?.fire()
    }
    
    // TODO: headerImageTaskTimer?.invalidate() !!! after implementing next module
    
    func getCollections() {
        guard let accessToken = self.keychainService.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        let successHandler = { (data: Data) throws in
            let responseObject = try JSONDecoder().decode(
                [UnsplashColletion].self,
                from: data
            )
            var collectionsData: [photoModel] = []
            for collection in responseObject {
                let coverImageUrl = URL(string: collection.cover_photo.urls.thumb)!
                if let data = try? Data(contentsOf: coverImageUrl) {
                    // here, in interactor, i have etl and downloading image data in same method
                    collectionsData.append(photoModel(
                        id: collection.id,
                        title: collection.title,
                        image: data
                    ))
                }
                DispatchQueue.main.async {
                    self.presenter?.setColletions(with: collectionsData)
                }
            }
        }
        
        Networking().getCollections(accessToken, successHandler)
    }
}
