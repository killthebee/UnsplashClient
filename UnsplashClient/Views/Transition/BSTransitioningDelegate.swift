import UIKit

final class BSTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let transition = BSTransition()
    
    var bottomSheetHeight: CGFloat = 250

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let BSPresentationController = BSPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )
        BSPresentationController.bottomSheetHeight = bottomSheetHeight
        
        return BSPresentationController
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        transition.wantsInteractiveStart = false
        return transition
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
