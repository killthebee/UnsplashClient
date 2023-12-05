import UIKit

extension UIImage {
    func getCropRation() -> CGFloat {
        CGFloat(self.size.width / self.size.height)
    }
    
    func getCropRation2() -> CGFloat {
        return CGFloat(self.size.height / self.size.width)
    }
}
