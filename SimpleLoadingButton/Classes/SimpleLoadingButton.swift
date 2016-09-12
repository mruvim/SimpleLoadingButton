//
//  SimpleLoadingButton.swift
//  SimpleLoadingButton
//
//  Created by Ruva on 7/1/16.
//  Copyright (c) 2016 Ruva. All rights reserved.
//

import UIKit

@IBDesignable
public class SimpleLoadingButton: UIView {
    
    /**
     Button internal states
     
     - Normal:      Title label is displayed, button background color is normalBackgroundColor
     - Highlighted: Title label is displayed, button background color changes to highlightedBackgroundColor
     - Loading:     Loading animation is displayed, background color changes to normalBackgroundColor
     */
    private enum State {
        case Normal
        case Highlighted
        case Loading
    }
    
    
    //MARK: - Private
    private var currentlyVisibleView:UIView?
    private var state:State = .Normal { didSet { if oldValue != state { updateUI(forState:state) } } }
    
    
    /// Font for the title label (IB does not allow UIFont to be inspected therefore font must be set programmatically)
    public var titleFont:UIFont = UIFont.systemFontOfSize(16) {
        didSet {
            guard let titleLabel = currentlyVisibleView as? UILabel else { return }
            titleLabel.font = titleFont
        }
    }
    
    
    //MARK: - Inspectable / Designable properties
    
    /// Button title
    @IBInspectable var title:String = NSLocalizedString("Button", comment:"Button") {
        didSet {
            guard let titleLabel = currentlyVisibleView as? UILabel else { return }
            titleLabel.text = title
        }
    }
    
    /// Title color
    @IBInspectable var titleColor:UIColor = UIColor.whiteColor() {
        didSet {
            guard let titleLabel = currentlyVisibleView as? UILabel else { return }
            titleLabel.textColor = titleColor
        }
    }
    
    /// Loading indicator color
    @IBInspectable var loadingIndicatorColor:UIColor = UIColor.whiteColor()
    
    /// Border width
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet { updateStyle() }
    }
    
    /// Border color
    @IBInspectable var borderColor:UIColor = UIColor.whiteColor() {
        didSet { updateStyle() }
    }
    
    /// Corner radius
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet { updateStyle() }
    }
    
    /// Background color for normal state
    @IBInspectable var normalBackgroundColor:UIColor = UIColor.lightGrayColor() {
        didSet { updateStyle() }
    }
    
    /// Background color for highlighted state
    @IBInspectable var highlightedBackgroundColor:UIColor = UIColor.darkGrayColor() {
        didSet { updateStyle() }
    }
    
    /// Duration of one animation cycle
    @IBInspectable var loadingAnimationDuration:Double = 2.0
    
    /// Size of the animating shape
    @IBInspectable var loadingShapeSize:CGSize = CGSizeMake(10, 10)
    
    
    //MARK: - Action
    public var buttonTappedHandler:(()-> Void)?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        updateStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
        updateStyle()
    }
    
    
    /**
        Setup button to initial state
     */
    private func setupButton() -> Void {
        
        let titleLabel = createTitleLabel(withFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let labelLeftConstraint = NSLayoutConstraint(item:titleLabel, attribute:.Left, relatedBy:.Equal, toItem:self, attribute: .Left, multiplier:1, constant: 0)
        let labelTopConstraint = NSLayoutConstraint(item:titleLabel, attribute:.Top, relatedBy:.Equal, toItem:self, attribute: .Top, multiplier:1, constant: 0)
        let labelRightConstraint = NSLayoutConstraint(item:titleLabel, attribute:.Right, relatedBy:.Equal, toItem:self, attribute: .Right, multiplier:1, constant: 0)
        let labelBottomConstraint = NSLayoutConstraint(item:titleLabel, attribute:.Bottom, relatedBy:.Equal, toItem:self, attribute: .Bottom, multiplier:1, constant: 0)
        addConstraints([labelLeftConstraint, labelTopConstraint, labelRightConstraint, labelBottomConstraint])
        currentlyVisibleView = titleLabel
    }
    
    
    
    /**
        Button style update
     */
    private func updateStyle() -> Void {
        backgroundColor = normalBackgroundColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }
    
    
    
    /**
        Update button UI as a result of state change
     - parameter buttonState: new button state
     */
    private func updateUI(forState buttonState:State) -> Void {
        
        var buttonBackgroundColor:UIColor
        switch buttonState {
        case .Normal:
            buttonBackgroundColor = normalBackgroundColor
            showLabelView()
        case .Highlighted:
            buttonBackgroundColor = highlightedBackgroundColor
        case .Loading:
            buttonBackgroundColor = normalBackgroundColor
            showLoadingView()
        }
        
        UIView.animateWithDuration(0.15) { [unowned self] in self.backgroundColor = buttonBackgroundColor }
    }
    
    
    
    /**
       Create title label
     - parameter frame: Label frame
     - returns: instance of UILabel
     */
    private func createTitleLabel(withFrame frame:CGRect) -> UILabel {
        let titleLabel = UILabel(frame:frame)
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        return titleLabel
    }
}



extension SimpleLoadingButton {
    
    //MARK: - Touch handling
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard state == .Normal, let touchLocation = touches.first?.locationInView(self) where CGRectContainsPoint(self.bounds, touchLocation) else {
            super.touchesBegan(touches, withEvent: event)
            return
        }
        state = .Highlighted
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard state != .Loading, let touchLocation = touches.first?.locationInView(self) else {
            super.touchesMoved(touches, withEvent: event)
            return
        }
        state = CGRectContainsPoint(self.bounds, touchLocation) ? .Highlighted : .Normal
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard state == .Highlighted, let touchLocation = touches.first?.locationInView(self) where CGRectContainsPoint(self.bounds, touchLocation) else {
            super.touchesEnded(touches, withEvent: event)
            return
        }
        state = .Loading
        if let handler = buttonTappedHandler { handler() }
    }
}




extension SimpleLoadingButton {
    
    //MARK: - View transitions
    
    /**
        Transition to title label
     */
    private func showLabelView() -> Void {
        
        guard let loadingView = currentlyVisibleView as? SimpleLoadingView else { return }
        let titleLabel = createTitleLabel(withFrame:loadingView.frame)
        addSubview(titleLabel)
        currentlyVisibleView = titleLabel
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: titleLabel, attribute:.Left, relatedBy:.Equal, toItem:self, attribute:.Left, multiplier:1, constant:0)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute:.Top, relatedBy:.Equal, toItem:self, attribute:.Top, multiplier:1, constant:0)
        let rightConstraint = NSLayoutConstraint(item: titleLabel, attribute:.Right, relatedBy:.Equal, toItem:self, attribute:.Right, multiplier:1, constant:0)
        let bottomConstraint = NSLayoutConstraint(item: titleLabel, attribute:.Bottom, relatedBy:.Equal, toItem:self, attribute:.Bottom, multiplier:1, constant:0)
        addConstraints([leftConstraint, topConstraint, bottomConstraint, rightConstraint])
        
        UIView.transitionFromView(loadingView, toView:titleLabel, duration:0.15, options:.TransitionCrossDissolve) { (_) in
            loadingView.removeFromSuperview()
        }
    }
    
    /**
        Transition to loading animation
     */
    private func showLoadingView() -> Void {
        
        guard let titleLabel = currentlyVisibleView as? UILabel else { return }
        let loadingView = SimpleLoadingView(withFrame:titleLabel.frame, animationDuration: loadingAnimationDuration, animatingShapeSize:loadingShapeSize, loadingIndicatorColor:loadingIndicatorColor)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        currentlyVisibleView = loadingView
        
        let leftConstraint = NSLayoutConstraint(item: loadingView, attribute:.Left, relatedBy:.Equal, toItem:self, attribute:.Left, multiplier:1, constant:0)
        let topConstraint = NSLayoutConstraint(item: loadingView, attribute:.Top, relatedBy:.Equal, toItem:self, attribute:.Top, multiplier:1, constant:0)
        let rightConstraint = NSLayoutConstraint(item: loadingView, attribute:.Right, relatedBy:.Equal, toItem:self, attribute:.Right, multiplier:1, constant:0)
        let bottomConstraint = NSLayoutConstraint(item: loadingView, attribute:.Bottom, relatedBy:.Equal, toItem:self, attribute:.Bottom, multiplier:1, constant:0)
        addConstraints([leftConstraint, topConstraint, bottomConstraint, rightConstraint])
        loadingView.startAnimation()
        
        UIView.transitionFromView(titleLabel, toView: loadingView, duration:0.15, options:.TransitionCrossDissolve) { (_) in
            titleLabel.removeFromSuperview()
        }
    }
}


extension SimpleLoadingButton {
    
    /**
        Start loading animation
     */
    public func animate() -> Void {
        state = .Loading
    }
    
    /**
        Stop loading animation
     */
    public func stop() -> Void {
        state = .Normal
    }
}

