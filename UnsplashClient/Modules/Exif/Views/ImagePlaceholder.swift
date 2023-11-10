import UIKit

class ImagePlaceholder: UIView {
    
    private let spinner = SpinnerViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSpinner()
    }
    
    private func addSpinner() {
        spinner.view.frame = bounds
        addSubview(spinner.view)
    }
}
