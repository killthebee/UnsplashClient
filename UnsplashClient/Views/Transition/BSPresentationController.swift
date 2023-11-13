import UIKit

final class BSPresentationController: UIPresentationController {
    
    private let cornerRadius: CGFloat = 16
    private let dismissThreshold: CGFloat = 0.3
    
    private var transitioningDelegate: BSTransitioningDelegate? {
        presentedViewController.transitioningDelegate as? BSTransitioningDelegate
    }
    
    override var shouldPresentInFullscreen: Bool {
        false
        // ? xD
    }
    
    private lazy var panGesture = UIPanGestureRecognizer(
        target: self,
        action: #selector(pannedPresentedView)
    )
                                        
    private let pullBarView: UIView = {
        let view = UIView()
        view.bounds.size = CGSize(width: 32, height: 4)
        view.backgroundColor = .systemFill
    
        return view
    }()
    
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let tapGR = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapDimmView)
        )
        view.addGestureRecognizer(tapGR)
        return view
    }()
    
    // MARK: - PresentationController
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        presentedView?.addSubview(pullBarView)
        
        dimmView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                guard let self = self else { return }
                self.presentedView?.layer.cornerRadius = self.cornerRadius
                dimmView.alpha = 1
            })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                guard let self = self else { return }
                
                self.presentedView?.layer.cornerRadius = .zero
                dimmView.alpha = 0
            })
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        setupLayout()
        setupPresentedViewInteraction()
    }
    
    private func updateTransitionProgress(for translation: CGPoint) {
        guard
            let transitioningDelegate = transitioningDelegate,
            let presentedView = presentedView
        else {
            return
        }
        
        let adjustedHeight = presentedView.frame.height - translation.y
        let progress = 1 - (adjustedHeight / presentedView.frame.height)
        transitioningDelegate.transition.update(progress)
    }
    
    private func handelEndedinteraction() {
        guard let transitioningDelegate = transitioningDelegate else {
            return
        }
        
        if transitioningDelegate.transition.dismissFractionComplete > dismissThreshold {
            transitioningDelegate.transition.finish()
        } else {
            transitioningDelegate.transition.cancel()
        }
    }
    
    private func setupLayout() {
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return
        }
        pullBarView.frame.origin.y = 8
        pullBarView.center.x = presentedView.center.x
        pullBarView.layer.cornerRadius = pullBarView.frame.height / 2
        presentedView.layer.cornerCurve = .continuous
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.additionalSafeAreaInsets.top = pullBarView.frame.maxY
        
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        dimmView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dimmView)
        containerView.addSubview(presentedView)

        NSLayoutConstraint.activate(
            [
                dimmView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dimmView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                dimmView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                dimmView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                presentedView.heightAnchor.constraint(
                    equalToConstant: 250),
            ]
        )
    }
    
    private func setupPresentedViewInteraction() {
        guard let presentedView = presentedView else { return }
        presentedView.addGestureRecognizer(panGesture)
    }
    
    private func dismiss(interactively isInteractively: Bool) {
        transitioningDelegate?.transition.wantsInteractiveStart = isInteractively
        presentedViewController.dismiss(animated: true)
    }
    
    @objc
    private func pannedPresentedView(_ recognizer: UIPanGestureRecognizer) {
        guard let presentedView = presentedView else { return }
        
        switch recognizer.state {
        case .began:
            dismiss(interactively: true)
        case .changed:
            let translation = recognizer.translation(in: presentedView)
            updateTransitionProgress(for: translation)
        case .ended, .cancelled, .failed:
            handelEndedinteraction()
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    @objc
    private func didTapDimmView() {
        dismiss(interactively: false)
    }
}
