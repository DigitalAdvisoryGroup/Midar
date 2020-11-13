//
//  SwipeInteractionController.swift
//  ProtechDNA
//
//  Created by Nyusoft on 17/01/19.
//  Copyright © 2019 Nyusoft. All rights reserved.
//

import UIKit

class SwipeDismissViewController: UIViewController, UIViewControllerTransitioningDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        transitioningDelegate = self
        
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / Screen.width)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began: self.dismiss(animated: true, completion: nil)
            
        case .changed: interactiveTransition.update(progress)
            
        case .cancelled: interactiveTransition.cancel()
            
        case .ended:
            let velocity = gestureRecognizer.velocity(in: view).x
            
            if progress > 0.5 || velocity > 1000 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            
        default:
            break
        }
    }
    
    private var isTappedToClose = false
    func swipeBack() {
        isTappedToClose = true
        self.dismiss(animated: true, completion: nil)
    }
    
    var animateOnPresent: Bool { return false }
    
    private var interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animateOnPresent ? SlidePresentAnimationController() : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDismissAnimationController()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isTappedToClose ? nil : interactiveTransition
    }
}

class SlideDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toView = transitionContext.viewController(forKey: .to)?.view else { return }
        
        let width = containerView.frame.width
        
        var offsetLeft = fromView.frame
        offsetLeft.origin.x = width
        
        var offscreenRight = toView.frame
        offscreenRight.origin.x = -width / 3.33;
        
        toView.frame = offscreenRight
        
        fromView.layer.shadowRadius = 5.0
        fromView.layer.shadowOpacity = 1.0
        toView.layer.opacity = 0.9
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, options:.curveLinear, animations:{
            
            toView.frame = fromView.frame
            fromView.frame = offsetLeft
            
            toView.layer.opacity = 1.0
            fromView.layer.shadowOpacity = 0.1
            
        }, completion: { finished in
            toView.layer.opacity = 1.0
            toView.layer.shadowOpacity = 0
            fromView.layer.opacity = 1.0
            fromView.layer.shadowOpacity = 0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class SlidePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toView = transitionContext.viewController(forKey: .to)?.view else { return }
        let width = containerView.frame.width
        var offsetLeft = fromView.frame
        offsetLeft.origin.x = -width / 3.33;
        
        var offscreenRight = toView.frame
        offscreenRight.origin.x = width
        toView.frame = offscreenRight;
        
        toView.layer.shadowRadius = 0.8
        toView.layer.shadowOpacity = 1.0
        fromView.layer.opacity = 0.9
        
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, options:.curveLinear, animations: {
            toView.frame.origin.x = 0
            fromView.frame = offsetLeft
            
            toView.layer.opacity = 1.0
            fromView.layer.shadowOpacity = 0.1
            
        }, completion: { finished in
            toView.layer.opacity = 1.0
            toView.layer.shadowOpacity = 0
            fromView.layer.opacity = 1.0
            fromView.layer.shadowOpacity = 0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

