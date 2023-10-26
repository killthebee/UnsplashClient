import UIKit

final class BSTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let transition = BSTransition()

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BSPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )
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
