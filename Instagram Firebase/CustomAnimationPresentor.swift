//
//  CustomAnimationPresentor.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/30/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

class CustomLeftAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Custom animation transition animation code
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return } // Caller
        guard let toView = transitionContext.view(forKey: .to) else { return } // CameraController
        
        // Adding toView first so when animating 'fromView' and 'toView' shows its already there
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let startingFrame = CGRect(x: -toView.frame.width/4, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        toView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            toView.alpha = 1
        }) { (_) in
            transitionContext.completeTransition(true) // Allows dismissing
        }
    }
}
