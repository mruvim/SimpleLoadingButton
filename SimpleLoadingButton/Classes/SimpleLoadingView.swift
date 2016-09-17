//
//  SimpleLoadingView.swift
//  SimpleLoadingView
//
//  Created by Ruva on 7/1/16.
//  Copyright (c) 2016 Ruva. All rights reserved.
//

import UIKit
internal class SimpleLoadingView: UIView {
    
    //MARK: - Private
    fileprivate var viewsArray:[UIView] = []
    fileprivate let kLoadingViewAlpha:CGFloat = 0.6
    fileprivate let kScaleFactor:CGFloat = 1.1
    fileprivate var animationDuration:Double = 2.0
    fileprivate var animatingShapeSize:CGSize = CGSize(width: 10, height: 10)
    fileprivate var loadingIndicatorColor:UIColor = UIColor.white
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    convenience init(withFrame frame: CGRect, animationDuration duration:Double = 2.0, animatingShapeSize shapeSize:CGSize = CGSize(width: 10, height: 10), loadingIndicatorColor color:UIColor = UIColor.white) {
        self.init(frame: frame)
        animationDuration = duration
        animatingShapeSize = shapeSize
        loadingIndicatorColor = color
        setupView()
    }
    
    
    /**
     Setup loading view
     */
    fileprivate func setupView() -> Void {
        
        let centerViewFrame = CGRect(x: frame.midX - animatingShapeSize.width / 2,
                                         y: frame.midY - animatingShapeSize.height / 2,
                                         width: animatingShapeSize.width,
                                         height: animatingShapeSize.height)
        let centerView = createCircleView(withFrame:centerViewFrame)
        addSubview(centerView)
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        let centerViewWidthConstraint = NSLayoutConstraint(item:centerView, attribute:.width, relatedBy:.equal, toItem:nil, attribute:.width, multiplier:1, constant:animatingShapeSize.width)
        let centerViewHeightConstraint = NSLayoutConstraint(item:centerView, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.height, multiplier:1, constant:animatingShapeSize.height)
        let centerViewXConstraint = NSLayoutConstraint(item:centerView, attribute:.centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1, constant:0)
        let centerViewYConstraint = NSLayoutConstraint(item:centerView, attribute:.centerY, relatedBy:.equal, toItem:self, attribute:.centerY, multiplier:1, constant: 0)
        addConstraints([centerViewWidthConstraint, centerViewHeightConstraint, centerViewXConstraint, centerViewYConstraint])
        
        var leftViewFrame = centerViewFrame
        leftViewFrame.origin.x = centerViewFrame.origin.x - animatingShapeSize.width - 5
        let leftView = createCircleView(withFrame: leftViewFrame)
        addSubview(leftView)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        let leftViewWidthConstraint = NSLayoutConstraint(item:leftView, attribute:.width, relatedBy:.equal, toItem:nil, attribute:.width, multiplier:1, constant:animatingShapeSize.width)
        let leftViewHeightConstraint = NSLayoutConstraint(item:leftView, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.height, multiplier:1, constant:animatingShapeSize.height)
        let leftViewXConstraint = NSLayoutConstraint(item:leftView, attribute:.right, relatedBy:.equal, toItem:centerView, attribute:.left, multiplier:1, constant:-5)
        let leftViewYConstraint = NSLayoutConstraint(item:leftView, attribute:.centerY, relatedBy:.equal, toItem:centerView, attribute:.centerY, multiplier:1, constant: 0)
        addConstraints([leftViewWidthConstraint, leftViewHeightConstraint, leftViewXConstraint, leftViewYConstraint])
        
        var rightViewFrame = centerViewFrame
        rightViewFrame.origin.x = centerViewFrame.origin.x + animatingShapeSize.width + 5
        let rightView = createCircleView(withFrame:rightViewFrame)
        addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        let rightViewWidthConstraint = NSLayoutConstraint(item:rightView, attribute:.width, relatedBy:.equal, toItem:nil, attribute:.width, multiplier:1, constant:animatingShapeSize.width)
        let rightViewHeightConstraint = NSLayoutConstraint(item:rightView, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.height, multiplier:1, constant:animatingShapeSize.height)
        let rightViewXConstraint = NSLayoutConstraint(item:rightView, attribute:.left, relatedBy:.equal, toItem:centerView, attribute:.right, multiplier:1, constant:5)
        let rightViewYConstraint = NSLayoutConstraint(item:rightView, attribute:.centerY, relatedBy:.equal, toItem:centerView, attribute:.centerY, multiplier:1, constant: 0)
        addConstraints([rightViewWidthConstraint, rightViewHeightConstraint, rightViewXConstraint, rightViewYConstraint])
        viewsArray = [leftView, centerView, rightView]
    }
    
    
    /**
     Factory method to create animating views
     
     - parameter size: Size of the loading circle
     - returns: UIView masked to circle shape
     */
    fileprivate func createCircleView(withFrame circleFrame:CGRect) -> UIView {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:circleFrame.width, height:circleFrame.height)).cgPath
        
        let ovalView = UIView(frame:circleFrame)
        ovalView.backgroundColor = loadingIndicatorColor
        ovalView.layer.mask = shapeLayer
        ovalView.alpha = kLoadingViewAlpha
        return ovalView
    }
}


extension SimpleLoadingView {
    
    //MARK: - Start / Stop animation
    
    /**
     Start loading animation
     */
    func startAnimation() -> Void {
        
        weak var leftView = viewsArray[0]
        weak var centerView = viewsArray[1]
        weak var rightView = viewsArray[2]
        
        UIView.animateKeyframes(withDuration: animationDuration, delay:0, options:[.beginFromCurrentState, .repeat], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration:1/4.0, animations: { [unowned self] in
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                leftView?.alpha = 1
                leftView?.transform = CGAffineTransform.identity.scaledBy(x: self.kScaleFactor, y: self.kScaleFactor)
                rightView?.transform = CGAffineTransform.identity
                centerView?.transform = CGAffineTransform.identity
                })
            
            UIView.addKeyframe(withRelativeStartTime: 1/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                leftView?.transform = CGAffineTransform.identity
                rightView?.transform = CGAffineTransform.identity
                centerView?.transform = CGAffineTransform.identity.scaledBy(x: self.kScaleFactor, y: self.kScaleFactor)
                leftView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = 1
                })
            
            UIView.addKeyframe(withRelativeStartTime: 2/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                rightView?.transform = CGAffineTransform.identity.scaledBy(x: self.kScaleFactor, y: self.kScaleFactor)
                leftView?.transform = CGAffineTransform.identity
                centerView?.transform = CGAffineTransform.identity
                leftView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = 1
                })
            
            UIView.addKeyframe(withRelativeStartTime: 3/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                leftView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                rightView?.transform = CGAffineTransform.identity
                leftView?.transform = CGAffineTransform.identity
                centerView?.transform = CGAffineTransform.identity
                })
            
            }, completion: nil)
    }
    
    
    /**
     Stop loading animation
     */
    func stopAnimation() -> Void {
        _ = viewsArray.map( { $0.removeFromSuperview() } )
    }
}
