class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    let apiService: UnsplashApiProtocol?
    
    required init(
        presenter: ExifPresenterProtocol,
        apiService: UnsplashApiProtocol = AppAssembly.currentApiService
    ) {
        self.presenter = presenter
        self.apiService = apiService
    }
    
    func getImage(photoId: String) {
        
        Task {
            guard
                let photoDataAndExif = await self.apiService?.getPhoto(
                    photoId
                )
            else
            {
                return
            }
            
            await presenter?.setImage(photoDataAndExif, photoId: photoId)
        }
    }
    
    func calculateInfoViewHeight(exif: ExifMetadata) -> Int {
        var result = 0
        var items = 0
        if exif.make != nil { items += 1 }
        if exif.model != nil { items += 1 }
        if exif.name != nil { items += 1 }
        if exif.exposure_time != nil { items += 1 }
        if exif.aperture != nil { items += 1 }
        if exif.focal_length != nil { items += 1 }
        if exif.iso != nil { items += 1 }
        let numOfSections = items == 0 ? 0 : (items - 1) / 2 + 1
        
        let headerHeight = 22
        let saftyInset = items < 3 ? 40 : 22
        
        result += saftyInset
        result += headerHeight
        result += numOfSections * 40
        return result
    }
}
