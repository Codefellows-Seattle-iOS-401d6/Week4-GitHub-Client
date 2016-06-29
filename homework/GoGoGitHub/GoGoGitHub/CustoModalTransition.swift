//
//  CustoModalTransition.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/29/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

class CustomModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 1.0
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        //this animation needs to occur in a container view
        guard let containerView = transitionContext.containerView() else { return }
        
        //the actual visual screen is where the toViewController needs to go
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let screenBounds = UIScreen.mainScreen().bounds
        //0.0 is the bottom of the screen where it starts, screenBounds.size.height is the top where it ends
        toViewController.view.frame = CGRectOffset(finalFrame, 0.0, screenBounds.size.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.8,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    toViewController.view.frame = finalFrame
            }) { (finished) in
                transitionContext.completeTransition(finished)
        }
    }
}
