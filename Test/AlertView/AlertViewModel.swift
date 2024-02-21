//
//  AlertViewModel.swift
//  Test
//
//  Created by Gamid Gapizov on 21.02.2024.
//

import Foundation
import UIKit

protocol AlertViewModel {
    
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var backgroundView: UIView {get set}
    var containerView: UIView {get set}
}


enum AnimationOption: Int {
    case zoomInOut
}

extension AlertViewModel where Self: UIView {
    
    //MARK: Showing Alert
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        if var topController = UIApplication.shared.windows.last?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let subviewsList = topController.view.subviews
            for view in subviewsList where view is AlertView {
                view.removeFromSuperview()
                break
            }
            topController.view.addSubview(self)
        }
        
        if animated {
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 1.0
                self.containerView.transform = .identity
            }, completion: { (_) in
                self.backgroundView.alpha = 1.0

            })
        }
    }
    
    //MARK: Hiding alert from View
    func dismiss(animated: Bool) {
        if animated {
            self.backgroundView.alpha = 1.0
            self.containerView.transform = .identity
            UIView.animate(withDuration: 0.11, animations: {
                self.backgroundView.alpha = 0.0
                self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { (_) in
                self.backgroundView.alpha = 0.0
                self.removeFromSuperview()
            })
        } else {
            self.backgroundView.alpha = 0.0
            self.removeFromSuperview()
        }
    }
}
