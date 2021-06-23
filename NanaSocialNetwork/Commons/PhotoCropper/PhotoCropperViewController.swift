//
//  PhotoCropperViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/23/21.
//

import UIKit

final class PhotoCropperViewController: UIViewController, UIScrollViewDelegate {
    /// Finished crop a photo completion.
    var finished: ((PhotoCropperViewController, UIImage?) -> Void)?
    /// Canceled.
    var canceled: ((PhotoCropperViewController) -> Void)?

    // privates
    private let image: UIImage
    private let imageView = UIImageView()
    private let scrollView = UIScrollView(frame: .zero)
    private let cutterView = UIView()

    /// designated initializer
    ///
    /// - Parameter image: Original image will be used for cropping
    init(image: UIImage) {
        if image.imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.image = normalizedImage!
        } else {
            self.image = image
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        view.addSubview(scrollView)
        scrollView.frame = view.bounds//square
        scrollView.delegate = self

        imageView.frame = CGRect(origin: .zero, size: image.size)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size

        // always width is chosen for scaling
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = min(scaleWidth, 1.0)
        scrollView.maximumZoomScale = max(scaleWidth, 1.0)
        scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        // Center vertically
        let croppedRect = self.croppedRect()

        let deltaY = (scrollView.contentSize.height - croppedRect.size.height) / 2 // distance from top image to top crop frame
        let insetY = croppedRect.origin.y + (deltaY < 0 ? -deltaY : 0)
        scrollView.contentInset = UIEdgeInsets(top: insetY, left: 0, bottom: insetY, right: 0)
        if deltaY > 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: -(croppedRect.origin.y - deltaY))
        }

        let overlay = PhotoCropperOverlayView()
        view.addSubview(overlay)
        overlay.frame = view.bounds

        // bottom view
        let cancelButton = UIButton()
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cancelButton.addTarget(self, action: #selector(didPressCancel(_:)), for: .touchUpInside)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true


        let chooseButton = UIButton()
        chooseButton.setTitle(NSLocalizedString("Choose", comment: ""), for: .normal)
        chooseButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        chooseButton.addTarget(self, action: #selector(didPressChoose(_:)), for: .touchUpInside)

        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chooseButton)
        chooseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        navigationController?.isNavigationBarHidden = true
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - actions
    @objc func didPressCancel(_ sender: Any?) {
        self.canceled?(self)
    }

    @objc func didPressChoose(_ sender: Any?) {
        self.finished?(self, croppedImage())
    }

    // MARK: - scrollview
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // MARK: - privates
    private func croppedImage() -> UIImage? {
        let newSize = CGSize(width: image.size.width * scrollView.zoomScale, height: image.size.height * scrollView.zoomScale)
        let offset = scrollView.contentOffset

        let croppedRect = self.croppedRect()

        UIGraphicsBeginImageContextWithOptions(croppedRect.size, false, 0)
        var drawRect = CGRect(x: -(offset.x + croppedRect.origin.x), y: -(offset.y + croppedRect.origin.y),
                              width: newSize.width, height: newSize.height)
        drawRect = drawRect.integral

        image.draw(in: drawRect)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    private func croppedRect() -> CGRect {
        let bounds = view.bounds
        let width = bounds.width
        let height: CGFloat = bounds.height
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if width > height {
            dx = (width - height) * 0.5
        } else {
            dy = (height - width) * 0.5
        }
        let rect = bounds.insetBy(dx: dx, dy: dy)
        return rect
    }
}
