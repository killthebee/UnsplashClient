import UIKit

extension UIImageView {
    
      func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
      }

      @objc
      private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
      }
}

extension UIImageView {
    
    func setImage(
        _ url: String,
        imageId: String,
        apiService: UnsplashApiProtocol = AppAssembly.currentApiService,
        complition: @escaping () -> Void = {}
    ) {
        Task {
            guard
                let imageData = await apiService.getUnsplashImage(
                    url,
                    imageId: imageId
                )
            else {
                return
            }
            image = UIImage(data: imageData)
            complition()
        }
    }
}
