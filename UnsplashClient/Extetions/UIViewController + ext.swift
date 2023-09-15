import UIKit

protocol Presentable: AnyObject {

    func toVC() -> UIViewController
    
    func present(_ destination: Presentable)
    func dismiss()
    
    func push(_ destination: Presentable)
    func pop()
}

extension UIViewController: Presentable {
    
    func toVC() -> UIViewController {
        self
    }
    
    func present(_ destination: Presentable) {
        self.present(destination.toVC(), animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func push(_ destination: Presentable) {
        if let navigationController {
            navigationController.pushViewController(destination.toVC(), animated: true)
        } else {
            present(destination)
        }
    }
    
    func pop() {
        if let navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss()
        }
    }
}
