//
//  ProgressView.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/21.
//

import Foundation
import UIKit

//class ProgressView: UIView {
//
//    /// The progress bar which adjusts width based on progress.
//    private var progressBar: UIView!
//
//    /// Progress on the track [0.0, 1.0]. Animatable.
//    @objc dynamic var progress: CGFloat {
//        set { progressLayer.progress = newValue }
//        get { return progressLayer.progress }
//    }
//
//    /// Display color of the progress bar. Animatable.
//    @objc dynamic var color: UIColor {
//        set { progressLayer.color = newValue.cgColor }
//        get { return UIColor(cgColor: progressLayer.color) }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        self.progress = 0.0
//        self.color = .black
//
//        progressBar = UIView(frame: .zero)
//        progressBar.backgroundColor = color
//        addSubview(progressBar)
//    }
//
//    override class var layerClass: AnyClass {
//        return ProgressLayer.self
//    }
//
//    private var progressLayer: ProgressLayer {
//        return layer as! ProgressLayer
//    }
//
//    override func display(_ layer: CALayer) {
//        guard let presentationLayer = layer.presentation() as? ProgressLayer else {
//            return
//        }
//
//        // Use presentationLayer's interpolated property value(s) to update UI components.
//        let clampedProgress = max(0.0, min(1.0, presentationLayer.progress))
//        let newWidth = layer.bounds.width * clampedProgress
//        progressBar.frame = CGRect(x: 0, y: 0, width: newWidth, height: bounds.height)
//        progressBar.backgroundColor = UIColor(cgColor: presentationLayer.color)
//    }
//}

class ProgressView: UIView {
    
    /// The progress bar which adjusts width based on progress.
//    private var progressBar: UIView!
    
    /// Progress on the track [0.0, 1.0]. Animatable.
    @objc dynamic var progress: CGFloat {
        set { progressLayer.progress = newValue }
        get { return progressLayer.progress }
    }
    
    /// Display color of the progress bar. Animatable.
    @objc dynamic var color: UIColor {
        set { progressLayer.color = newValue.cgColor }
        get { return UIColor(cgColor: progressLayer.color) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        print("zzzkljfldks")
        self.progress = 0.0
        self.color = .black
        
        contentScaleFactor = UIScreen.main.scale
        contentMode = UIView.ContentMode.redraw
//        progressBar = UIView(frame: .zero)
//        progressBar.backgroundColor = color
//        addSubview(progressBar)
    }
    
    override class var layerClass: AnyClass {
        return ProgressLayer.self
    }
    
    private var progressLayer: ProgressLayer {
        return layer as! ProgressLayer
    }
    
//    override func display(_ layer: CALayer) {
//        guard let presentationLayer = layer.presentation() as? ProgressLayer else {
//            return
//        }
//
//        // Use presentationLayer's interpolated property value(s) to update UI components.
//        let clampedProgress = max(0.0, min(1.0, presentationLayer.progress))
//        let newWidth = layer.bounds.width * clampedProgress
//        progressBar.frame = CGRect(x: 0, y: 0, width: newWidth, height: bounds.height)
//        progressBar.backgroundColor = UIColor(cgColor: presentationLayer.color)
//    }
}

/// A backing layer for ProgressView which supports certain animatable values.
fileprivate class ProgressLayer: CALayer {
    @NSManaged var progress: CGFloat
    @NSManaged var color: CGColor
    
    // Whenever a new presentation layer is created, this function is called and makes a COPY of the object.
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? ProgressLayer {
            progress = layer.progress
            color = layer.color
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if isAnimationKeySupported(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if ProgressLayer.isAnimationKeySupported(event) {
            // Copy animation context and mutate as needed
            guard let animation = currentAnimationContext(in: self)?.copy() as? CABasicAnimation else {
                setNeedsDisplay()
                return nil
            }
            
            animation.keyPath = event
            if let presentation = presentation() {
                animation.fromValue = presentation.value(forKeyPath: event)
            }
            animation.toValue = nil
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    private class func isAnimationKeySupported(_ key: String) -> Bool {
        return key == #keyPath(progress) || key == #keyPath(color)
    }
    
    private func currentAnimationContext(in layer: CALayer) -> CABasicAnimation? {
        /// The UIView animation implementation is private, so to check if the view is animating and
        /// get its property keys we can use the key "backgroundColor" since its been a property of
        /// UIView which has been forever and returns a CABasicAnimation.
        return action(forKey: #keyPath(backgroundColor)) as? CABasicAnimation
    }
}
