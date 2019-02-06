//
//  SimpleLoadingButton.swift
//  SimpleLoadingButton
//
//  Created by Ruva on 7/1/16.
//  Copyright (c) 2016 Ruva. All rights reserved.
//

import UIKit

@IBDesignable
public class SimpleLoadingButton: UIControl {
    
    /**
     Button internal states
     
     - Normal:      Title label is displayed, button background color is normalBackgroundColor
     - Highlighted: Title label is displayed, button background color changes to highlightedBackgroundColor
     - Loading:     Loading animation is displayed, background color changes to normalBackgroundColor
     */
    fileprivate enum ButtonState {
        case normal
        case highlighted
        case loading
        
        
    }
    
    
    //MARK: - Private
    fileprivate var currentlyVisibleView:UIView?
    fileprivate var buttonState:ButtonState = .normal { didSet { if oldValue != buttonState { updateUI(forState:buttonState) } } }
    
    
    /// Font for the title label (IB does not allow UIFont to be inspected therefore font must be set programmatically)
    public var titleFont:UIFont = UIFont.systemFont(ofSize: 16) {
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
    @IBInspectable var titleColor:UIColor = UIColor.white {
        didSet {
            guard let titleLabel = currentlyVisibleView as? UILabel else { return }
            titleLabel.textColor = titleColor
        }
    }
    
    /// Loading indicator color
    @IBInspectable var loadingIndicatorColor:UIColor = UIColor.white {
        
        didSet{
            updateUI(forState: buttonState)
        }
    }
    
    /// Border width
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet { updateStyle() }
    }
    
    /// Border color
    @IBInspectable var borderColor:UIColor = UIColor.white {
        didSet { updateStyle() }
    }
    
    /// Corner radius
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet { updateStyle() }
    }
    
    /// Background color for normal state
    @IBInspectable var normalBackgroundColor:UIColor = UIColor.lightGray {
        didSet { updateStyle() }
    }
    
    /// Background color for highlighted state
    @IBInspectable var highlightedBackgroundColor:UIColor = UIColor.darkGray {
        didSet { updateStyle() }
    }
    
    /// Duration of one animation cycle
    @IBInspectable var loadingAnimationDuration:Double = 2.0
    
    /// Size of the animating shape
    @IBInspectable var loadingShapeSize:CGSize = CGSize(width: 10, height: 10)
    
    
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
        
        let titleLabel = createTitleLabel(withFrame:CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
        layer.borderColor = borderColor.cgColor
    }
    
    
    
    /**
        Update button UI as a result of state change
     - parameter buttonState: new button state
     */
    private func updateUI(forState buttonState:ButtonState) -> Void {
        
        var buttonBackgroundColor:UIColor
        switch buttonState {
        case .normal:
            buttonBackgroundColor = normalBackgroundColor
            showLabelView()
        case .highlighted:
            buttonBackgroundColor = highlightedBackgroundColor
        case .loading:
            buttonBackgroundColor = normalBackgroundColor
            showLoadingView()
        }
        
        UIView.animate(withDuration: 0.15, animations: { [unowned self] in self.backgroundColor = buttonBackgroundColor }) 
    }
    
    
    
    /**
       Create title label
     - parameter frame: Label frame
     - returns: instance of UILabel
     */
    fileprivate func createTitleLabel(withFrame frame:CGRect) -> UILabel {
        let titleLabel = UILabel(frame:frame)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        return titleLabel
    }
}



extension SimpleLoadingButton {
    
    //MARK: - Touch handling
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard buttonState == .normal,
            let touchLocation = touches.first?.location(in: self),
            bounds.contains(touchLocation) else {
            super.touchesBegan(touches, with: event)
            return
        }
        buttonState = .highlighted
    }
    
     override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard buttonState != .loading,
            let touchLocation = touches.first?.location(in: self) else {
            super.touchesMoved(touches, with: event)
            return
        }
        
        buttonState = bounds.contains(touchLocation) ? .highlighted : .normal
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard buttonState == .highlighted,
            let touchLocation = touches.first?.location(in: self),
            bounds.contains(touchLocation) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        buttonState = .loading
        sendActions(for: .touchUpInside)
    }
}




extension SimpleLoadingButton {
    
    //MARK: - View transitions
    
    /**
        Transition to title label
     */
    fileprivate func showLabelView() -> Void {
        
        guard let loadingView = currentlyVisibleView as? SimpleLoadingView else { return }
        let titleLabel = createTitleLabel(withFrame:loadingView.frame)
        addSubview(titleLabel)
        currentlyVisibleView = titleLabel
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        UIView.transition(from: loadingView, to:titleLabel, duration:0.15, options:.transitionCrossDissolve) { (_) in
            loadingView.removeFromSuperview()
        }
    }
    
    /**
        Transition to loading animation
     */
    fileprivate func showLoadingView() -> Void {
        
        guard let titleLabel = currentlyVisibleView as? UILabel else { return }
        let loadingView = SimpleLoadingView(withFrame:titleLabel.frame, animationDuration: loadingAnimationDuration, animatingShapeSize:loadingShapeSize, loadingIndicatorColor:loadingIndicatorColor)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        currentlyVisibleView = loadingView
        
        loadingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadingView.startAnimation()
        
        UIView.transition(from: titleLabel, to: loadingView, duration:0.15, options:.transitionCrossDissolve) { (_) in
            titleLabel.removeFromSuperview()
        }
    }
}


extension SimpleLoadingButton {
    
    /**
        Start loading animation
     */
    public func animate() -> Void {
        buttonState = .loading
    }
    
    /**
        Stop loading animation
     */
    public func stop() -> Void {
        buttonState = .normal
    }
}

