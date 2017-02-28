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
    
    private var animatingShapeSize:CGSize = CGSize(width: 10, height: 10)
    private var loadingIndicatorColor:UIColor = UIColor.white
    
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
    private func setupView() -> Void {
        
        let centerViewFrame = CGRect(x: frame.midX - animatingShapeSize.width / 2,
                                         y: frame.midY - animatingShapeSize.height / 2,
                                         width: animatingShapeSize.width,
                                         height: animatingShapeSize.height)
        let centerView = createCircleView(withFrame:centerViewFrame)
        addSubview(centerView)
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.widthAnchor.constraint(equalToConstant: animatingShapeSize.width).isActive = true
        centerView.heightAnchor.constraint(equalToConstant: animatingShapeSize.height).isActive = true
        centerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        var leftViewFrame = centerViewFrame
        leftViewFrame.origin.x = centerViewFrame.origin.x - animatingShapeSize.width - 5
        let leftView = createCircleView(withFrame: leftViewFrame)
        addSubview(leftView)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.widthAnchor.constraint(equalToConstant: animatingShapeSize.width).isActive = true
        leftView.heightAnchor.constraint(equalToConstant: animatingShapeSize.height).isActive = true
        leftView.rightAnchor.constraint(equalTo: centerView.leftAnchor, constant: -5).isActive = true
        leftView.centerYAnchor.constraint(equalTo: centerView.centerYAnchor).isActive = true
        
        var rightViewFrame = centerViewFrame
        rightViewFrame.origin.x = centerViewFrame.origin.x + animatingShapeSize.width + 5
        let rightView = createCircleView(withFrame:rightViewFrame)
        addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.widthAnchor.constraint(equalToConstant: animatingShapeSize.width).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: animatingShapeSize.height).isActive = true
        rightView.leftAnchor.constraint(equalTo: centerView.rightAnchor, constant: 5).isActive = true
        rightView.centerYAnchor.constraint(equalTo: centerView.centerYAnchor).isActive = true
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
