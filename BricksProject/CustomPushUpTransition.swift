import UIKit

class CustomPushUpTransition: NSObject, UIViewControllerAnimatedTransitioning{
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screen   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        switch transitionType {
        case .presenting:
            toView.frame.origin.y = screen.bounds.height
            toView.alpha = 0.8
            screen.addSubview(toView)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {

                fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                toView.frame.origin.y -= screen.bounds.height
                toView.alpha = 1

            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            screen.insertSubview(toView, belowSubview: fromView)

//            var contentView: UIView!
//            if let order = fromViewController as? OrderDetailsVC {
//                contentView = order.contentView
//            }
//            
//            if let address = fromViewController as? AddressVC {
//                contentView = address.contentView
//            }
//            
//            if let creditCard = fromViewController as? CreditCardVC {
//                contentView = creditCard.contentView
//            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
//                contentView.frame.origin.y += contentView.frame.height
                
                fromView.frame.origin.y = screen.bounds.height
                fromView.alpha = 0
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1

            }, completion: { finished in
//                contentView.frame.origin.y -= contentView.frame.height
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
}

class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushUpTransition(transitionType: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushUpTransition(transitionType: .dismissing)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
