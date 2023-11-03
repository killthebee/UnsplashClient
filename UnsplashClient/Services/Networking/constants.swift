enum Urls: String {
    case login = "https://unsplash.com/oauth/authorize"
    case unsplashHost = "unsplash.com"
    case unslpashApiHost = "api.unsplash.com"
    case redirectUri = "tutututuclient://"
    case randomPhoto = "https://unsplash.com/photos/random"
    case tokenExchangePath = "/oauth/token"
    case randomPhotoPath = "/photos/random"
    case collectionList = "/collections"
    case newPhotosPath = "/photos"
    case loginPath = "/oauth/authorize"
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HTTPScheme: String {
    case secure = "https"
}

let collbackScheme = "tutututuclient"

let clientId = "lpjuJu1NvEkMVzV_X3pvAmkfWzeCcnOs2w59gdeyp1Q"
let clientSecret = "tUic-Ay2vrcl6-_RcDETtFWbCoFrXowm2uGL8R4zyXo"
