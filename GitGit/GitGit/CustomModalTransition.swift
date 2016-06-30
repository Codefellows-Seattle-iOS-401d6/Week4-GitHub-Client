//
//  CustomModalTransition.swift
//  GitGit
//
//  Created by Derek Graham on 6/29/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

class CustomModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration = 1.0
    
    init(duration: NSTimeInterval ){
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        
        guard let containerView = transitionContext.containerView() else { return }
        
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame = CGRectOffset(finalFrame, 0.0, screenBounds.size.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext),
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.8,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    toViewController.view.frame = finalFrame
                            }) { (finished) in
                //
                                        transitionContext.completeTransition(true)
        }
        
    }
}