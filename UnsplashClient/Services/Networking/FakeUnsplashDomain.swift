import UIKit

class FakeUnsplashApi: UnsplashApiProtocol {
    
    
    // check app router
    public var errorPresentationHandler: (
        _ source: ErrorSource
    ) async -> Void = { _ in }
    
    var tokenStorage: TokenStorageProtocol?
    
    let headerInfo: [UnsplashPhoto] = [
        UnsplashPhoto(
            id: "h1",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
            user: UnsplashUser(name: "Robert Jordan")
        ),
        UnsplashPhoto(
            id: "h2",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
            user: UnsplashUser(name: "Joaquin")
        ),
        UnsplashPhoto(
            id: "h3",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
            user: UnsplashUser(name: "El Sordo")
        )
    ]
    
    let collectionsInfo: [UnsplashColletion] = [
        UnsplashColletion(
            id: "c1",
            title: "Bussiness",
            cover_photo: UnsplashPhoto(
                id: "c1",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c2",
            title: "Education",
            cover_photo: UnsplashPhoto(
                id: "c2",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c3",
            title: "Relationships",
            cover_photo: UnsplashPhoto(
                id: "c3",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c4",
            title: "Parade",
            cover_photo: UnsplashPhoto(
                id: "c4",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c5",
            title: "Cats",
            cover_photo: UnsplashPhoto(
                id: "c5",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever"),
                user: UnsplashUser(name: "whatever")
            )
        )
    ]
    
    var regularPhotoData: [String: Data?] = [:]
    
    init() {
        Task {
            await populateRegularPhotoData()
        }
    }
    
    private func populateRegularPhotoData() async {
        regularPhotoData["h1"] = UIImage(named: "headerTests1")!.jpegData(compressionQuality: 1)
        regularPhotoData["h2"] = UIImage(named: "headerTests2")!.jpegData(compressionQuality: 1)
        regularPhotoData["h3"] = UIImage(named: "headerTests3")!.jpegData(compressionQuality: 1)
        regularPhotoData["c1"] = UIImage(named: "c1BussinessTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c2"] = UIImage(named: "c2EducationTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c3"] = UIImage(named: "c3RelationshipsTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c4"] = UIImage(named: "c4ParadeTests")!.jpegData(compressionQuality: 1)
        regularPhotoData["c5"] = UIImage(named: "c5CatsTests")!.jpegData(compressionQuality: 1)
    }

    static let shared: UnsplashApiProtocol = FakeUnsplashApi()
    
    var newImages: [photoModel] = []
  
    // TODO: do i really need this method here? authsesh's api service doesn't hidden under protocol tho
    func exchangeCode(code: String) async -> TokenExchangeSuccessData? {
        return TokenExchangeSuccessData(
            access_token: "whatever",
            refresh_token: "whatever",
            token_type: "whatever",
            scope: "whatever",
            created_at: 1111
        )
    }
    
    var counter = 0
    // TODO: Yeah, one day im gonna make a generator, it's a shame there's no easy way to do it in swift
    func getRandomPhoto() async -> UnsplashPhoto? {
        if counter == 3 { counter = 0 }
        let photo = headerInfo[counter]
        counter += 1
        return photo
    }
    
    func getCollections() async -> [UnsplashColletion]? {
        return collectionsInfo
    }
    
    private func downloadImagesAsync(with response: [UnsplashPhoto]) async {
        do {
            try await withThrowingTaskGroup(of: photoModel.self) { taskGroup in
                for unslpashPhotoData in response {
                    taskGroup.addTask{
                        photoModel(
                            id: unslpashPhotoData.id,
                            title: nil,
                            image: try await Networking.shared.getImage(
                                unslpashPhotoData.urls.thumb
                            )
                        )
                    }
                }
                
                while let newPhotoData = try await taskGroup.next() {
                    newImages.append(newPhotoData)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getNewImages(page pageNum: Int) async {
        
    }
    
    func getUnsplashImage(_ url: String, imageId: String ) async -> Data? {
        if let photo = regularPhotoData[imageId] {
            return photo
        } else {
            return nil
        }
    }
    
    func getPhoto(_ photoID: String) async -> photoData? {
        return nil
    }
    
    func makeUrl(_ urlArg: String, target: urlTarget) -> URL? {
        return nil
    }
}
