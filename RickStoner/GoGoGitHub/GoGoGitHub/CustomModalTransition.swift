//
//  CustomModalTransition.swift
//  GoGoGitHub
//
//  Created by Rick  on 6/29/16.
//  Copyright © 2016 Rick . All rights reserved.
//

import UIKit

class CustomModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.5
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        guard let containerView = transitionContext.containerView() else { return }
        let screenBound = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.frame = CGRectOffset(finalFrame, 0.0, screenBound.size.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .CurveEaseIn, animations: {
            toViewController.view.frame = finalFrame
            }) { (finished) in
                transitionContext.completeTransition(finished)
        }
    }


}