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
    
    private func makeBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return effectView
    }
    
    private func setThumb(_ imageData: Data, blurView: UIVisualEffectView) {
        image = UIImage(data: imageData)
        self.addSubview(blurView)
    }
    
    private func setRegular(_ imageData: Data, blurView: UIVisualEffectView) {
        UIView.transition(
            with: self,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.image = UIImage(data: imageData)
                blurView.removeFromSuperview()
            },
            completion: nil
        )
    }
    
    func setImage(
        _ urls: PhotoUrls,
        imageId: String,
        _ apiService: UnsplashApiProtocol = AppAssembly.currentApiService
    ) {
        Task {
            image = nil
            var (imageData, fromCache) = await apiService.getUnsplashImage(
                urls.thumb,
                imageId: imageId,
                isThumb: true
            )
            
            guard imageData != nil else { return }
            if fromCache {
                image = UIImage(data: imageData!)
                return
            }
            
            let blurEffect = makeBlurEffect()
            setThumb(imageData!, blurView: blurEffect)
            
            (imageData, fromCache) = await apiService.getUnsplashImage(
                urls.regular,
                imageId: imageId,
                isThumb: false
            )
            guard imageData != nil else { return }
            setRegular(imageData!, blurView: blurEffect)
        }
    }
    
    func setImage(
        _ urls: PhotoUrls,
        imageId: String,
        _ apiService: UnsplashApiProtocol = AppAssembly.currentApiService,
        complition: @escaping () -> Void = {}
    ) {
        Task {
            let (imageData, _) = await apiService.getUnsplashImage(
                urls.raw,
                imageId: imageId
            )
            guard imageData != nil else { return }
            image = UIImage(data: imageData!)
            complition()
        }
    }
}
