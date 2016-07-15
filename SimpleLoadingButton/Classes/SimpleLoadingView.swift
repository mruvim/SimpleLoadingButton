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
    private var viewsArray:[UIView] = []
    private let kLoadingViewAlpha:CGFloat = 0.6
    private let kScaleFactor:CGFloat = 1.1
    private var animationDuration:Double = 2.0
    private var animatingShapeSize:CGSize = CGSizeMake(10, 10)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    convenience init(withFrame frame: CGRect, animationDuration duration:Double = 2.0, animatingShapeSize shapeSize:CGSize = CGSizeMake(10, 10)) {
        self.init(frame: frame)
        animationDuration = duration
        animatingShapeSize = shapeSize
        setupView()
    }
    
    
    /**
     Setup loading view
     */
    private func setupView() -> Void {
        
        let centerViewFrame = CGRectMake(CGRectGetMidX(frame) - animatingShapeSize.width / 2,
                                         CGRectGetMidY(frame) - animatingShapeSize.height / 2,
                                         animatingShapeSize.width,
                                         animatingShapeSize.height)
        let centerView = createCircleView(withFrame:centerViewFrame)
        addSubview(centerView)
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        let centerViewWidthConstraint = NSLayoutConstraint(item:centerView, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute:.Width, multiplier:1, constant:animatingShapeSize.width)
        let centerViewHeightConstraint = NSLayoutConstraint(item:centerView, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute:.Height, multiplier:1, constant:animatingShapeSize.height)
        let centerViewXConstraint = NSLayoutConstraint(item:centerView, attribute:.CenterX, relatedBy:.Equal, toItem:self, attribute:.CenterX, multiplier:1, constant:0)
        let centerViewYConstraint = NSLayoutConstraint(item:centerView, attribute:.CenterY, relatedBy:.Equal, toItem:self, attribute:.CenterY, multiplier:1, constant: 0)
        addConstraints([centerViewWidthConstraint, centerViewHeightConstraint, centerViewXConstraint, centerViewYConstraint])
        
        var leftViewFrame = centerViewFrame
        leftViewFrame.origin.x = centerViewFrame.origin.x - animatingShapeSize.width - 5
        let leftView = createCircleView(withFrame: leftViewFrame)
        addSubview(leftView)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        let leftViewWidthConstraint = NSLayoutConstraint(item:leftView, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute:.Width, multiplier:1, constant:animatingShapeSize.width)
        let leftViewHeightConstraint = NSLayoutConstraint(item:leftView, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute:.Height, multiplier:1, constant:animatingShapeSize.height)
        let leftViewXConstraint = NSLayoutConstraint(item:leftView, attribute:.Right, relatedBy:.Equal, toItem:centerView, attribute:.Left, multiplier:1, constant:-5)
        let leftViewYConstraint = NSLayoutConstraint(item:leftView, attribute:.CenterY, relatedBy:.Equal, toItem:centerView, attribute:.CenterY, multiplier:1, constant: 0)
        addConstraints([leftViewWidthConstraint, leftViewHeightConstraint, leftViewXConstraint, leftViewYConstraint])
        
        var rightViewFrame = centerViewFrame
        rightViewFrame.origin.x = centerViewFrame.origin.x + animatingShapeSize.width + 5
        let rightView = createCircleView(withFrame:rightViewFrame)
        addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        let rightViewWidthConstraint = NSLayoutConstraint(item:rightView, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute:.Width, multiplier:1, constant:animatingShapeSize.width)
        let rightViewHeightConstraint = NSLayoutConstraint(item:rightView, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute:.Height, multiplier:1, constant:animatingShapeSize.height)
        let rightViewXConstraint = NSLayoutConstraint(item:rightView, attribute:.Left, relatedBy:.Equal, toItem:centerView, attribute:.Right, multiplier:1, constant:5)
        let rightViewYConstraint = NSLayoutConstraint(item:rightView, attribute:.CenterY, relatedBy:.Equal, toItem:centerView, attribute:.CenterY, multiplier:1, constant: 0)
        addConstraints([rightViewWidthConstraint, rightViewHeightConstraint, rightViewXConstraint, rightViewYConstraint])
        viewsArray = [leftView, centerView, rightView]
    }
    
    
    /**
     Factory method to create animating views
     
     - parameter size: Size of the loading circle
     - returns: UIView masked to circle shape
     */
    private func createCircleView(withFrame circleFrame:CGRect) -> UIView {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalInRect: CGRect(x:0, y:0, width:CGRectGetWidth(circleFrame), height:CGRectGetHeight(circleFrame))).CGPath
        
        let ovalView = UIView(frame:circleFrame)
        ovalView.backgroundColor = UIColor.whiteColor()
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
        
        UIView.animateKeyframesWithDuration(animationDuration, delay:0, options:[.BeginFromCurrentState, .Repeat], animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration:1/4.0, animations: { [unowned self] in
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                leftView?.alpha = 1
                leftView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.kScaleFactor, self.kScaleFactor)
                rightView?.transform = CGAffineTransformIdentity
                centerView?.transform = CGAffineTransformIdentity
                })
            
            UIView.addKeyframeWithRelativeStartTime(1/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                leftView?.transform = CGAffineTransformIdentity
                rightView?.transform = CGAffineTransformIdentity
                centerView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.kScaleFactor, self.kScaleFactor)
                leftView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = 1
                })
            
            UIView.addKeyframeWithRelativeStartTime(2/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                rightView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.kScaleFactor, self.kScaleFactor)
                leftView?.transform = CGAffineTransformIdentity
                centerView?.transform = CGAffineTransformIdentity
                leftView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = 1
                })
            
            UIView.addKeyframeWithRelativeStartTime(3/4.0, relativeDuration:1/4.0, animations: {  [unowned self] in
                leftView?.alpha = self.kLoadingViewAlpha
                centerView?.alpha = self.kLoadingViewAlpha
                rightView?.alpha = self.kLoadingViewAlpha
                rightView?.transform = CGAffineTransformIdentity
                leftView?.transform = CGAffineTransformIdentity
                centerView?.transform = CGAffineTransformIdentity
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