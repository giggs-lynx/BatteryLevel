//
//  BatteryLevelLayer.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import Foundation
import UIKit
import CoreGraphics

class BatteryLevelLayer: CALayer {
    
    private static let bodyToBoundsWidthRatio: CGFloat = (131.0 / 135.0)
    private static let headToBodyHeightRatio: CGFloat = (1.0 / 3.0)
    private static let symbolToBoundsWidthRatio: CGFloat = (17.0 / 135.0)
    private static let symbolToBoundsHeightRatio: CGFloat = (24.0 / 41.0)
    
    var lineWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var batteryCornerRadius: CGFloat = 16.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fieldPadding: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var level: CGFloat {
        get {
            return fieldLayer.value
        }
        set {
            fieldLayer.value = newValue
        }
    }
    
    private lazy var fieldLayer = FieldLayer()
    private lazy var symbolLayer = SymbolLayer()
    
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
        addSublayer(fieldLayer)
        addSublayer(symbolLayer)
    }
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        
        var bounds = ctx.boundingBoxOfClipPath
        bounds = bounds.inset(by: insets)
        bounds = bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        
        let bodyWidth = bounds.width * Self.bodyToBoundsWidthRatio
        let bodyHeight = bounds.height
        let bodySize = CGSize(width: bodyWidth, height: bodyHeight)
        let bodyRect = CGRect(origin: bounds.origin, size: bodySize)
        
        let headWidth = bounds.width - bodyRect.width
        let headHeight = bodyRect.height * Self.headToBodyHeightRatio
        let headOrigin = CGPoint(x: bodyRect.maxX, y: bodyRect.midY - (headHeight * 0.5))
        let headSize = CGSize(width: headWidth, height: headHeight)
        let headRect = CGRect(origin: headOrigin, size: headSize)
        
        lineColor.setStroke()
        
        let framePath = createFramePath(headRect: headRect, bodyRect: bodyRect)
        framePath.lineWidth = lineWidth
        framePath.stroke()
        
        let fieldOffset = lineWidth * 0.5 + fieldPadding
        let fieldRect = bodyRect.insetBy(dx: fieldOffset, dy: fieldOffset)
        
        fieldLayer.frame = fieldRect
        fieldLayer.cornerRadius = batteryCornerRadius - fieldOffset
        
        let symbolWidth = bounds.width * Self.symbolToBoundsWidthRatio
        let symbolHeight = bounds.height * Self.symbolToBoundsHeightRatio
        let symbolSize = CGSize(width: symbolWidth, height: symbolHeight)
        let symbolOrigin = bounds.centre - (symbolWidth * 0.5, symbolHeight * 0.5)
        let symbolRect = CGRect(origin: symbolOrigin, size: symbolSize)
        symbolLayer.frame = symbolRect
        symbolLayer.setNeedsDisplay()
        
        UIGraphicsPopContext()
    }
    
    private func createFramePath(headRect head: CGRect, bodyRect body: CGRect) -> UIBezierPath {
        let r = batteryCornerRadius
        
        let path = UIBezierPath()
        
        path.move(to: body.bottomRight + (.zero, -r))
        path.addArc(withCenter: body.bottomRight + (-r , -r), radius: r, startAngle: .radian(by: 0.0), endAngle: .radian(by: 90.0), clockwise: true)
        
        path.addLine(to: body.bottomLeft + (r, .zero))
        path.addArc(withCenter: body.bottomLeft + (r , -r), radius: r, startAngle: .radian(by: 90.0), endAngle: .radian(by: 180.0), clockwise: true)
        
        path.addLine(to: body.topLeft + (.zero, r))
        path.addArc(withCenter: body.topLeft + (r, r), radius: r, startAngle: .radian(by: -180.0), endAngle: .radian(by: -90.0), clockwise: true)
        
        path.addLine(to: body.topRight + (-r, .zero))
        path.addArc(withCenter: body.topRight + (-r , r), radius: r, startAngle: .radian(by: -90.0), endAngle: .radian(by: 0.0), clockwise: true)
        
        path.addLine(to: head.topLeft)
        path.addLine(to: head.topRight)
        path.addLine(to: head.bottomRight)
        path.addLine(to: head.bottomLeft)
        path.close()
        
        return path
    }
    
    private class SymbolLayer: CALayer {
        
        override func draw(in ctx: CGContext) {
            UIGraphicsPushContext(ctx)
            
            let bounds = ctx.boundingBoxOfClipPath
            let l = bounds.width * 2.0 / 3.0
            
            let leftOuter = CGPoint(x: bounds.minX, y: bounds.midY)
            let top = CGPoint(x: bounds.minX + l, y: bounds.midY - l)
            let rightInner = CGPoint(x: bounds.minX + l, y: bounds.midY)
            let rightOuter = CGPoint(x: bounds.maxX, y: bounds.midY)
            let bottom = CGPoint(x: bounds.maxX - l, y: bounds.maxY)
            let leftInner = CGPoint(x: bounds.maxX - l, y: bounds.midY)
            
            let path = UIBezierPath()
            path.move(to: leftOuter)
            path.addLine(to: top)
            path.addLine(to: rightInner)
            path.addLine(to: rightOuter)
            path.addLine(to: bottom)
            path.addLine(to: leftInner)
            path.close()
            
            UIColor.white.setFill()
            path.fill()
            
            UIGraphicsPopContext()
        }
        
        override class func needsDisplay(forKey key: String) -> Bool {
            switch key {
                case "frame":
                    return true
                default:
                    return super.needsDisplay(forKey: key)
            }
        }
        
    }
    
    private class FieldLayer: CALayer {
        
        private static let minValue: CGFloat = 0.0
        private static let maxValue: CGFloat = 100.0
        
        private lazy var pulseLayer: CAGradientLayer = createPulseLayer()
        private lazy var whiteLayer = CALayer()
        
        @NSManaged
        private var _value: CGFloat
        
        var value: CGFloat {
            get {
                return _value
            }
            set {
                _value = min(max(newValue, Self.minValue), Self.maxValue)
            }
        }
        
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
        
        override func layoutSublayers() {
            super.layoutSublayers()
            
            updateWhiteMaskLayer()
        }
        
        private func setup() -> Void {
            whiteLayer.backgroundColor = UIColor.white.cgColor
            whiteLayer.mask = pulseLayer
            addSublayer(whiteLayer)
        }
        
        override func draw(in ctx: CGContext) {
            UIGraphicsPushContext(ctx)
            
            let bounds = ctx.boundingBoxOfClipPath
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            fillColor.setFill()
            path.fill()
            
            self.mask = createMaskLayer(in: bounds)
            whiteLayer.frame = bounds
            
            UIGraphicsPopContext()
        }
        
        override class func needsDisplay(forKey key: String) -> Bool {
            switch key {
                case "_value", "frame", "cornerRadius":
                    return true
                default:
                    return super.needsDisplay(forKey: key)
            }
        }
        
//        override func action(forKey event: String) -> CAAction? {
//            if event == "_value" {
//                print("GGGG")
//
//                let anim = CABasicAnimation(keyPath: event)
//
//                anim.keyPath = event
//                anim.fromValue = presentation()?._value ?? 0.0
//                anim.toValue = 5.0
//                print("ZZZZ")
//                return anim
//            }
//
//            return super.action(forKey: event)
//        }


        
        private func createMaskLayer(in rect: CGRect) -> CALayer {
            let width = rect.size.width * (_value / Self.maxValue)
            let size = CGSize(width: width, height: rect.size.height)
            let frame = CGRect(origin: rect.origin, size: size)
            
            let layer = CALayer()
            layer.frame = frame
            layer.backgroundColor = UIColor.white.cgColor
            
            return layer
        }
        
        private func updateWhiteMaskLayer() {
            pulseLayer.frame = CGRect(x: -bounds.width, y: 0.0, width: bounds.width, height: bounds.height)
            pulseLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.byValue = bounds.width * 2.0
            animation.duration = 1.5
            animation.isRemovedOnCompletion = false
            
            let group = CAAnimationGroup()
            group.animations = [animation]
            group.duration = 3.0
            group.repeatCount = .infinity
            
            pulseLayer.add(group, forKey: nil)
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
        
        var fillColor: UIColor {
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
                    return .systemBlue
            }
        }
        
    }
    
}
