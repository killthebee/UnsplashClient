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
        with collectionData: UnsplashColletion
    ) {
        Task {
            guard
                let imageData = await UnsplashApi.shared.getCollectionCoverPhoto(
                    collectionData
                )
            else {
                return
            }
            image = UIImage(data: imageData)
        }
    }
}
