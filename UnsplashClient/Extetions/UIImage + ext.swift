import UIKit

extension UIImage {
    func getCropRation() -> CGFloat {
        CGFloat(self.size.width / self.size.height)
    }
}
