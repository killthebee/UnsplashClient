//
//  ImagePlaceholder.swift
//  UnsplashClient
//
//  Created by admin on 10.11.2023.
//

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
        print(bounds.width)
//        spinner.view.frame.origin = CGPoint(
//            x: imagePlaceholderView.frame.width / 2,
//            y: imagePlaceholderView.frame.height / 2
//        )
        addSubview(spinner.view)
    }
}
