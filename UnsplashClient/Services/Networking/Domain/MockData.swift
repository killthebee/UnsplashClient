import Foundation

struct FakeUnsplashApiMockData {
    static let headerInfo: [UnsplashPhoto] = [
        UnsplashPhoto(
            id: "h1",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
            user: UnsplashUser(name: "Robert Jordan")
        ),
        UnsplashPhoto(
            id: "h2",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
            user: UnsplashUser(name: "Joaquin")
        ),
        UnsplashPhoto(
            id: "h3",
            links: PhotoLinks(download: "whatever"),
            urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
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
                urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c2",
            title: "Education",
            cover_photo: UnsplashPhoto(
                id: "c2",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c3",
            title: "Relationships",
            cover_photo: UnsplashPhoto(
                id: "c3",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c4",
            title: "Parade",
            cover_photo: UnsplashPhoto(
                id: "c4",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
                user: UnsplashUser(name: "whatever")
            )
        ),
        UnsplashColletion(
            id: "c5",
            title: "Cats",
            cover_photo: UnsplashPhoto(
                id: "c5",
                links: PhotoLinks(download: "whatever"),
                urls: PhotoUrls(raw: "whatever", thumb: "whatever", regular: "1"),
                user: UnsplashUser(name: "whatever")
            )
        )
    ]
    
    static let firstExifAndImageData = PhotoData(
        exif: ExifMetadata(
            make: "SONY",
            model: "ILCE-7M4",
            name: "SONY, ILCE-7M4",
            focal_length: "35.0",
            aperture: "1.8",
            exposure_time: "0.0166"),
        urls: PhotoUrls(raw: "i1", thumb: "i1", regular: "i1")
    )
}
