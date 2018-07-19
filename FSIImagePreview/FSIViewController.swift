//
//  FSIViewController.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jun/26/18.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

public class FSIViewController: UIPageViewController {
    @objc public var initialView: UIView?
    @objc public var actionSheet: UIAlertController?
    @objc public var images: [UIImage]? {
        didSet {
            updateImagePreviewViewControllers(for: images!)
        }
    }
    @objc public weak var fsiDelegate: FSIViewControllerDelegate?
    private var previewBars: PreviewBars!
    private var statusBarShouldBeHidden = false {
        didSet {
            UIApplication.shared.isStatusBarHidden = statusBarShouldBeHidden
        }
    }
    private var imagePreviewViewControllers = [FSIImagePreviewViewController]()
    private let initialStatusBarStyle = UIApplication.shared.statusBarStyle
    //    MARK: Initializers
    public init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: [UIPageViewControllerOptionInterPageSpacingKey: 20])
        UIApplication.shared.statusBarStyle = .lightContent
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
        dataSource = self
        delegate = self
        previewBars = PreviewBars(on: self.view)
        previewBars?.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImagePreviewViewControllers(for images: [UIImage]) {
        var imagePreviewViewControllers = [FSIImagePreviewViewController]()
        for (number, image) in images.enumerated() {
            imagePreviewViewControllers.append(FSIImagePreviewViewController(with: image, delegate: self, shouldAppearAnimated: number == 0))
        }
        self.imagePreviewViewControllers = imagePreviewViewControllers
        setViewControllers([imagePreviewViewControllers.first!], direction: .forward, animated: false)
        previewBars.topBar.pageCounter.setAll(number: imagePreviewViewControllers.count)
        previewBars.topBar.pageCounter.setCurrent(number: currentImageNumber())
    }
    
    
    func didChangePage() {
        previewBars.topBar.pageCounter.setCurrent(number: currentImageNumber())
        fsiDelegate?.didChangePage()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        self.initialView?.alpha = 0.01
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.backgroundColor = .black
            self.previewBars?.showBars()
        }
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 5,
                       options: [.allowAnimatedContent],
                       animations: { [unowned self] in
            self.imagePreviewViewControllers.first!.initialLocateView()
        })
    }
    
    func currentImageNumber() -> Int {
        guard let previewViewController = viewControllers?.first as? FSIImagePreviewViewController,
            let index = imagePreviewViewControllers.index(of: previewViewController) else {
                return 0
        }
        return index+1
    }
    
    func dissmiss() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowAnimatedContent], animations: { [unowned self] in
            self.initialView?.alpha = 1
            self.view.alpha = 0.0
            self.statusBar(shouldBeHidden: false)
            self.setNeedsStatusBarAppearanceUpdate()
            }, completion: { [unowned self] _ in
                UIApplication.shared.statusBarStyle = self.initialStatusBarStyle
                self.presentingViewController?.dismiss(animated: false)
        })
    }
    
    
}

//    MARK: Status Bar settings
extension FSIViewController {
    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override public var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    private func statusBar(shouldBeHidden: Bool) {
        statusBarShouldBeHidden = shouldBeHidden
        setNeedsStatusBarAppearanceUpdate()
    }
}

//    MARK: FullScreenControllerProtocol
extension FSIViewController: FSIControllerProtocol {
    func getInitialImageFrame() -> CGRect? {
        return initialView?.globalFrame
    }
    
    func didTap() {
        previewBars?.changeState()
        fsiDelegate?.didTap()
    }
    
    func didDoubleTap() {
        fsiDelegate?.didDoubleTap()
    }
    
    func apply(alpha: CGFloat) {
        view.backgroundColor = view.backgroundColor?.withAlphaComponent(alpha)
    }
    
    func didSwipeBack() {
        fsiDelegate?.didSwipeBack()
        dissmiss()
    }
    
    func getPageScrollView() -> UIScrollView! {
        for view in view.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }
    
    func didSwipe() {
        statusBar(shouldBeHidden: false)
    }
}

//    MARK: UIPageViewControllerDataSource
extension FSIViewController: UIPageViewControllerDataSource {
    private enum Direction {
        case next
        case back
    }
    
    private func getViewController(for direction: Direction, current viewController: UIViewController) -> UIViewController? {
        guard let imagePreviewViewController = viewController as? FSIImagePreviewViewController,
              let newIndex = imagePreviewViewControllers.index(of: imagePreviewViewController) else {
            return nil
        }
        switch direction {
            case .back:
                guard newIndex != 0 else {
                        return nil
                }
                return imagePreviewViewControllers[newIndex - 1]
            case .next:
                guard newIndex != imagePreviewViewControllers.count-1 else {
                        return nil
                }
                return imagePreviewViewControllers[newIndex + 1]
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getViewController(for: .back, current: viewController)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getViewController(for: .next, current: viewController)
    }
}

extension FSIViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        didChangePage()
    }
}

extension FSIViewController: PreviewBarDelegate {
    func backButtonPressed() {
        dissmiss()
    }
    
    func actionButtonPressed() {
        if let actionSheet = actionSheet {
            present(actionSheet, animated: true)
        }
    }
    
    func setStatusBar(isHidden: Bool) {
        statusBar(shouldBeHidden: isHidden)
    }
}

extension FSIViewController: FSIPublicInteface {
    public var topBarView: UIView {
        return previewBars.topBar.view
    }
    
    public var bottomBarView: UIView {
        return previewBars.bottomBar.view
    }
    
    public var currentCounterLabel: UILabel {
        return previewBars.topBar.pageCounter.currentLabel
    }
    
    public var ofCounterLabel: UILabel {
        return previewBars.topBar.pageCounter.ofLabel
    }
    
    public var toCounterLabel: UILabel {
        return previewBars.topBar.pageCounter.allNumberLabel
    }
    
    public var backButton: UIButton {
        return previewBars.topBar.backButton
    }
    
    public var actionButton: UIButton {
        return previewBars.topBar.actionButton
    }
    
    public func setPreviewBar(isHidden: Bool) {
        previewBars.isHidden ? previewBars.hideBars() : previewBars.showBars()
    }
    
}
