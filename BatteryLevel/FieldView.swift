//
//  FieldView.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/22.
//

import Foundation
import UIKit

class FieldView: UIView {
    
    var level: CGFloat {
        get {
            batteryLayer.value
        }
        set {
            batteryLayer.value = newValue
        }
    }
    
    var fieldBackgroundColor: UIColor = .clear {
        didSet {
            batteryLayer.setNeedsDisplay()
        }
    }
    
    var cornerRadius: CGFloat = 20.0 {
        didSet {
            batteryLayer.setNeedsDisplay()
        }
    }
    
    var batteryLayer: FieldLayer {
        return layer as! FieldLayer
    }
    
    override class var layerClass: AnyClass {
        return FieldLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentScaleFactor = UIScreen.main.scale
        contentMode = UIView.ContentMode.redraw
        backgroundColor = .clear
        
        setupBatteryLayer()
    }
    
    private func setupBatteryLayer() -> Void {
        batteryLayer.cornerRadius = cornerRadius
        batteryLayer.backgroundColor = fieldBackgroundColor.cgColor
    }
    
}

//class FieldLayer: CALayer {
//
//    var value: CGFloat {
//        get {
//            maskLayer.value
//        }
//        set {
//            maskLayer.value = newValue
//        }
//    }
//
//    private lazy var gradientLayer: CAGradientLayer = {
//        let l = CAGradientLayer()
//        l.mask = maskLayer
//        l.locations = [0.35, 0.5, 0.65]
//        l.startPoint = CGPoint(x: 0, y: 0.5)
//        return l
//    }()
//
//    private lazy var maskLayer: _FieldLayer = {
//        let l = _FieldLayer()
//        l.frame = bounds
//        return l
//    }()
//
//    override init() {
//        super.init()
//
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        setup()
//    }
//
//    override init(layer: Any) {
//        super.init(layer: layer)
//
//        setup()
//    }
//
//    private func setup() -> Void {
//        masksToBounds = true
//    }
//
//    override func layoutSublayers() {
//        super.layoutSublayers()
//
//        print("layoutSublayers: 1. \(bounds)")
//        print("layoutSublayers: 2. \(maskLayer.bounds)")
//        print("layoutSublayers: 3. \(maskLayer.frame)")
//
//        addSublayer(gradientLayer)
////        maskLayer.frame = bounds
////        addSublayer(maskLayer)
//    }
//
//    override func draw(in ctx: CGContext) {
//        UIGraphicsPushContext(ctx)
//
//        let bounds = ctx.boundingBoxOfClipPath
//
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
//        gradientLayer.endPoint = CGPoint(x: value / 100.0, y: 0.5)
//
//        print("draw(in ctx: 0. \(bounds)")
//        UIGraphicsPopContext()
//    }
//
//}

class FieldLayer: CALayer {

    private static let minValue: CGFloat = 0.0
    private static let maxValue: CGFloat = 100.0
    
    @NSManaged
    private var _value: CGFloat
    
    @NSManaged
    private var _color: CGColor
    
    var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = min(max(newValue, Self.minValue), Self.maxValue)
            _color = fillColor.cgColor
        }
    }
    
    private var fillColor: UIColor {
        switch _value {
            case 0..<10:
                return .systemRed.interpolateRGBColorTo(.systemRed, fraction: _value / 10.0)
            case 10..<25:
                return .systemRed.interpolateRGBColorTo(.systemRed, fraction: (_value - 10.0) / 15.0)
            case 25..<50:
                return .systemOrange.interpolateRGBColorTo(.systemOrange, fraction: (_value - 25.0) / 25.0)
            case 50..<75:
                return .systemYellow.interpolateRGBColorTo(.systemYellow, fraction: (_value - 50.0) / 25.0)
            case 75...100:
                return .systemGreen.interpolateRGBColorTo(.systemGreen, fraction: (_value - 75.0) / 25.0)
            default:
                return .clear
        }
    }
    
    private lazy var pulseLayer: CAGradientLayer = createPulseLayer()
    
    private lazy var maskLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.backgroundColor = UIColor.black.cgColor
        return l
    }()
    
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        setup()
    }
    
    private func setup() -> Void {
        masksToBounds = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        mask  = maskLayer
        
        pulseLayer.frame = bounds
        addSublayer(pulseLayer)
        
        print("Qoo")
        
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        switch key {
            case "_value":
                return true
            default:
                return super.needsDisplay(forKey: key)
        }
    }
    
    override func action(forKey event: String) -> CAAction? {
        switch event {
            case "_value":
                let valAnim = CABasicAnimation()
                valAnim.keyPath = "_value"
                valAnim.fromValue = presentation()?._value
                valAnim.toValue = nil
                return valAnim
            case "_color":
                let colorAnim = CABasicAnimation()
                colorAnim.keyPath = "_color"
                colorAnim.fromValue = presentation()?._color
                colorAnim.toValue = nil
                return colorAnim
            default:
                return super.action(forKey: event)
        }
    }
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        
        let bounds = ctx.boundingBoxOfClipPath
        
        let fieldSize = CGSize(width: bounds.size.width * (_value / 100.0), height: bounds.size.height)
        let fieldRect = CGRect(origin: bounds.origin, size: fieldSize)
        let fieldPath = UIBezierPath(rect: fieldRect)
        
        ctx.setFillColor(_color)
        ctx.fill(bounds)
//        fieldPath.fill()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.isRemovedOnCompletion = true
        animation.keyPath = "path"
        animation.duration = 0.25
        animation.fromValue = maskLayer.path
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskLayer.add(animation, forKey: "path")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.path = fieldPath.cgPath
        CATransaction.commit()
        
        UIGraphicsPopContext()
    }
    
    private func createPulseLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.clear.cgColor,
        ]
        
        layer.locations = [0.0, 0.45, 0.5, 0.55, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 0.05)
        
        return layer
    }
    
}
