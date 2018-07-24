//
//  FSIImagePreviewViewController.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/12/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

fileprivate typealias ConstraintsGaps = (portrait: CGFloat, landscape: CGFloat)
fileprivate typealias OrientationConstraints = (portrait: [NSLayoutConstraint], landscape: [NSLayoutConstraint])
fileprivate typealias AxisConstraints = (portrait: NSLayoutConstraint, landscape: NSLayoutConstraint)

/// ViewController that manage single image page, with UIScrollView and UIImageView on it.
class FSIImagePreviewViewController: UIViewController {
    private weak var fsiController: FSIControllerProtocol?
    private let imageRatio: CGFloat
    private var imageView: UIImageView
    private var scrollView: ScrollView!
    private var shouldAppearAnimated: Bool
    private var pageScrollView: UIScrollView?
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private lazy var initialCenter = CGPoint.zero
    private var dimensionIsLocked = false
    
    private var axisConstraints: AxisConstraints = (NSLayoutConstraint(), NSLayoutConstraint())
    private var realAxisConstraints: AxisConstraints = (NSLayoutConstraint(), NSLayoutConstraint())
    private lazy var orientationConstraints = OrientationConstraints([NSLayoutConstraint](), [NSLayoutConstraint]())
    private lazy var constraintGaps = ConstraintsGaps(0, 0)
    
    init (with image: UIImage, fsiController: FSIControllerProtocol, shouldAppearAnimated: Bool = false) {
        self.imageRatio = image.size.ratio()
        self.fsiController = fsiController
        self.shouldAppearAnimated = shouldAppearAnimated
        self.pageScrollView = fsiController.getPageScrollView()
        self.imageView = UIImageView.getCustomImageView(for: image, initialFrame: shouldAppearAnimated ? fsiController.getInitialImageFrame() : CGRect.zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = UIView()
        
        scrollView = ScrollView.getCustomScrollView()
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        scrollView.addSubview(imageView)
        [imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)].forEach { constraint in
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        computeConstraints()
    }
    
    private func computeConstraints() {
        let sideConstraints = [
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ]
        let topAndBottomConstraints = [
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ]
        
        let screenSize = UIApplication.shared.keyWindow!.frame.size
        let screenHeight = max(screenSize.height, screenSize.width)
        let screenWidth = min(screenSize.height, screenSize.width)
        let screenRatio = screenWidth / screenHeight
        
        realAxisConstraints.portrait = imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        realAxisConstraints.landscape = imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        
        if imageRatio < screenRatio {
            // not typical, image thiner in portrait => side gaps
            constraintGaps.portrait = (screenWidth - screenHeight * imageRatio)/2
            axisConstraints.portrait = realAxisConstraints.portrait
            orientationConstraints.portrait += topAndBottomConstraints
        } else {
            constraintGaps.portrait = (screenHeight - screenWidth / imageRatio)/2
            axisConstraints.portrait = realAxisConstraints.landscape
            orientationConstraints.portrait += sideConstraints
        }
        
        if imageRatio > 1/screenRatio {
            // not typical, image thiner in landscape => top and bottom gaps
            constraintGaps.landscape = (screenWidth - screenHeight / imageRatio)/2
            axisConstraints.landscape = realAxisConstraints.landscape
            orientationConstraints.landscape += sideConstraints
        } else {
            constraintGaps.landscape = (screenHeight - screenWidth * imageRatio)/2
            axisConstraints.landscape = realAxisConstraints.portrait
            orientationConstraints.landscape += topAndBottomConstraints
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldAppearAnimated == false {
            initialLocateView()
        }
        scrollView.delegate = self
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moved(_:)))
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scrollView.zoomScale = 1.0
        axisConstraints.portrait.constant = 0
        axisConstraints.landscape.constant = 0

    }
    
//    update constraints when orientation changed
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.zoomScale = scrollView.minimumZoomScale
        updateImageConstraints(with: size, isInitial: false)
        axisConstraints.portrait.constant = 0
        axisConstraints.landscape.constant = 0
        coordinator.animate(alongsideTransition: nil) { [unowned self] _ in
            self.centerZoomView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard shouldAppearAnimated == false else {
            return
        }
        updateImageConstraints(with: UIScreen.main.bounds.size, isInitial: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard shouldAppearAnimated == false else {
            return
        }
        centerZoomView()
    }
    
    /// Locates constraint for first view
    func initialLocateView() {
        shouldAppearAnimated = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageRatio),
            realAxisConstraints.portrait,
            realAxisConstraints.landscape
        ])
        updateImageConstraints(with: UIScreen.main.bounds.size, isInitial: true)
    }
    
    /// Update constraints of imageView depending on device orientation
    private func updateImageConstraints(with size: CGSize, isInitial: Bool) {
        if size.ratio() > 1 {
            scrollView.removeConstraints(orientationConstraints.portrait)
            NSLayoutConstraint.activate(orientationConstraints.landscape)
        } else {
            scrollView.removeConstraints(orientationConstraints.landscape)
            NSLayoutConstraint.activate(orientationConstraints.portrait)
        }
        if isInitial {
            view.layoutIfNeeded()
        }
    }

    private func centerZoomView() {
        axisConstraints.portrait.constant = 0
        axisConstraints.landscape.constant = 0
        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
            if scrollView.frame.size.ratio() > imageRatio {
                axisConstraints.portrait.constant = max((scrollView.bounds.size.width - imageView.frame.size.width)/2 - constraintGaps.portrait, -constraintGaps.portrait)
            } else {
                axisConstraints.portrait.constant = max((scrollView.bounds.size.height - imageView.frame.size.height)/2 - constraintGaps.portrait, -constraintGaps.portrait)
            }
        } else {
            if scrollView.frame.size.ratio() < imageRatio {
                axisConstraints.landscape.constant = max((scrollView.bounds.size.height - imageView.frame.size.height)/2 - constraintGaps.landscape, -constraintGaps.landscape)
            } else {
                axisConstraints.landscape.constant = max((scrollView.bounds.size.width - imageView.frame.size.width)/2 - constraintGaps.landscape, -constraintGaps.landscape)
            }
        }
        view.layoutIfNeeded()
    }
}

// MARK: -
// MARK: GestureRecognizers action handlers
extension FSIImagePreviewViewController {
    @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
        fsiController?.didTap()
    }
    
    @objc private func doubleTapped(_ recognizer: UITapGestureRecognizer) {
        scrollView.zoomWithAnimation()
        fsiController?.didDoubleTap()
    }
    
    /// Prevents two dimensional scroll.
    private func checkDimensionToLock(_ translation: CGPoint, _ gestureRecognizer: UIPanGestureRecognizer) {
        guard dimensionIsLocked != true else { return }
        let translationX = abs(translation.x)
        let translationY = abs(translation.y)
        if translationX > 10 && translationY < 21 {
            gestureRecognizer.isEnabled = false
            dimensionIsLocked = true
        }
        if translationY > 10 && translationX < 21 {
            pageScrollView?.isScrollEnabled = false
            dimensionIsLocked = true
        }
    }
    
    private func swipeGestureCompletion(_ gestureRecognizer: UIPanGestureRecognizer, _ piece: UIView) {
        gestureRecognizer.isEnabled = true
        pageScrollView?.isScrollEnabled = true
        dimensionIsLocked = false
        UIView.animate(withDuration: AnimationDuration.short.rawValue) { [unowned self] in
            piece.center = self.initialCenter
            self.fsiController?.apply(alpha: 1.0)
        }
    }
    
    private func swipeGestureHandleProgress(_ piece: UIView, _ translation: CGPoint) {
        piece.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
        let yOffset = abs(translation.y)
        let alpha = 1 - 0.003 * (yOffset < 150 ? yOffset : 150)
        fsiController?.apply(alpha: alpha)
        if alpha < 1.0 {
            fsiController?.didSwipe()
        }
    }
    
    private func didSwipeToDismiss(_ piece: UIView, _ translation: CGPoint, _ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return abs(gestureRecognizer.velocity(in: piece.superview).y) > 700 || abs(translation.y) > 150
    }
    
    /// Called when user doing pan gesture on imageView.
    @objc func moved(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let piece = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }
        checkDimensionToLock(translation, gestureRecognizer)
        
        if gestureRecognizer.state != .cancelled {
            swipeGestureHandleProgress(piece, translation)
        }
        if gestureRecognizer.state == .ended && didSwipeToDismiss(piece, translation, gestureRecognizer){
            fsiController?.didSwipeBack()
            return
        }
        if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
            swipeGestureCompletion(gestureRecognizer, piece)
        }
    }
}

// MARK: -
// MARK: UIScrollViewDelegate
extension FSIImagePreviewViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        panGestureRecognizer.isEnabled = scrollView.zoomScale == scrollView.minimumZoomScale
        centerZoomView()
    }
}

// MARK: -
// MARK: UIGestureRecognizerDelegate
extension FSIImagePreviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

