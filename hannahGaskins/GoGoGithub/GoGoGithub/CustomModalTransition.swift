//
//  CustomModalTransition.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/29/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
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
        
        // pointer to view controller that we are navigating to, that to view controllers view
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        
        // containter view is where your animations should be happening --> this is the container view
        guard let containerView = transitionContext.containerView() else { return }
        
        // what will be the final frame for the transition. final frame will be bounds of screen
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame = CGRectOffset(finalFrame, 0.0, screenBounds.size.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext),
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.8,
                                   options: .CurveEaseInOut, animations: {
                                    
            toViewController.view.frame = finalFrame
            
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}










