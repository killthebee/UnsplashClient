import Foundation

struct FakeUnsplashApiMockData {
    static let headerInfo: [UnsplashPhoto] = [
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
    
    static let collectionsInfo: [UnsplashColletion] = [
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
    
//    let newImages: [photoModel] = [
//        photoModel(
//            id: <#T##String#>,
//            title: <#T##String?#>,
//            image:
//        )
//    ]
}
