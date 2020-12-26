//
//  SlideInTransition.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    var isPresenting = false // true when showing menu and false when hiding menu
    let dimmingView = UIView() // makes current view controller appear dimmed when showing menu
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        // menu width and height
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // add dim effect
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            // initialize menu off screen
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        // moves menu on screen
        let show = {
            self.dimmingView.alpha = 0.5
            print(finalWidth)
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        // moves menu off screen
        let hide = {
            self.dimmingView.alpha = 0
            fromViewController.view.transform = .identity // returns menu to original state
        }
        
        // animates menu moving on/off screen
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? show() : hide()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
        
    }
    
}
