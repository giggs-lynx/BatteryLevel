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
    
    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var padding: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 2.0 {
        didSet {
            frameLayer.lineWidth = lineWidth
        }
    }
    
    var lineColor: UIColor = .label {
        didSet {
            frameLayer.strokeColor = lineColor.cgColor
        }
    }
    
    var batteryCornerRadius: CGFloat = 16.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var symbolColor: UIColor = .label {
        didSet {
            symbolLayer.fillColor = symbolColor.cgColor
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
    
    private lazy var frameLayer = CAShapeLayer()
    private lazy var fieldLayer = FieldLayer()
    private lazy var symbolLayer = CAShapeLayer()
    
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
        self.needsDisplayOnBoundsChange = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
     
        addSublayer(frameLayer)
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
        
        let fieldOffset = lineWidth * 0.5 + padding
        let fieldRect = bodyRect.insetBy(dx: fieldOffset, dy: fieldOffset)
        let fieldCornerRadius = batteryCornerRadius - fieldOffset
        
        let symbolWidth = bounds.width * Self.symbolToBoundsWidthRatio
        let symbolHeight = bounds.height * Self.symbolToBoundsHeightRatio
        let symbolSize = CGSize(width: symbolWidth, height: symbolHeight)
        let symbolOrigin = bounds.centre - (symbolWidth * 0.5, symbolHeight * 0.5)
        let symbolRect = CGRect(origin: symbolOrigin, size: symbolSize)
        
        frameLayer.backgroundColor = UIColor.clear.cgColor
        frameLayer.fillColor = UIColor.clear.cgColor
        frameLayer.strokeColor = lineColor.cgColor
        frameLayer.lineWidth = lineWidth
        frameLayer.path = createFramePath(headRect: headRect, bodyRect: bodyRect).cgPath
        
        fieldLayer.frame = fieldRect
        fieldLayer.cornerRadius = fieldCornerRadius
        
        symbolLayer.frame = symbolRect
        symbolLayer.backgroundColor = UIColor.clear.cgColor
        symbolLayer.fillColor = symbolColor.cgColor
        symbolLayer.path = createSymbolPath(in: symbolRect).cgPath
        
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
    
    private func createSymbolPath(in rect: CGRect) -> UIBezierPath {
        let _boundsTransform = CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y)
        let _bounds = rect.applying(_boundsTransform)
        
        let l = _bounds.width * 2.0 / 3.0
        
        let leftOuter = CGPoint(x: _bounds.minX, y: _bounds.midY)
        let top = CGPoint(x: _bounds.minX + l, y: _bounds.midY - l)
        let rightInner = CGPoint(x: _bounds.minX + l, y: _bounds.midY)
        let rightOuter = CGPoint(x: _bounds.maxX, y: _bounds.midY)
        let bottom = CGPoint(x: _bounds.maxX - l, y: _bounds.midY + l)
        let leftInner = CGPoint(x: _bounds.maxX - l, y: _bounds.midY)
        
        let path = UIBezierPath()
        path.move(to: leftOuter)
        path.addLine(to: top)
        path.addLine(to: rightInner)
        path.addLine(to: rightOuter)
        path.addLine(to: bottom)
        path.addLine(to: leftInner)
        path.close()
        
        return path
    }
    
    private class FieldLayer: CALayer {
        
        private struct ColorStop {
            let range: Range<Int>
            let startColor: UIColor
            let endColor: UIColor
        }
        
        private let stops: [ColorStop] = [
            ColorStop(range: 0..<20, startColor: .systemRed, endColor: .systemRed),
            ColorStop(range: 20..<60, startColor: .systemOrange, endColor: .systemOrange),
            ColorStop(range: 60..<80, startColor: .systemYellow, endColor: .systemYellow),
            ColorStop(range: 80..<101, startColor: .systemGreen, endColor: .systemGreen)
        ]
        
        private var fillColor: UIColor {
            let stop = stops.first(where: { $0.range ~= Int(_value) })
            
            guard let _stop = stop else {
                return .clear
            }
            
            return _stop.startColor.interpolateRGBColorTo(_stop.endColor, fraction: CGFloat(_stop.range.count))
        }
        
        private static let minValue: CGFloat = 0.0
        private static let maxValue: CGFloat = 100.0
        
        private lazy var pulseLayer: CAGradientLayer = createPulseLayer()
        
        private lazy var whiteLayer: CALayer = {
            let l = CALayer()
            l.backgroundColor = UIColor.white.cgColor
            l.mask = pulseLayer
            return l
        }()
        
        private lazy var maskLayer: CALayer = {
            let layer = CALayer()
            layer.backgroundColor = UIColor.white.cgColor
            return layer
        }()
        
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
        
        private func setup() -> Void {
            self.needsDisplayOnBoundsChange = true
        }
        
        override func layoutSublayers() {
            super.layoutSublayers()
            
            whiteLayer.frame = bounds
            addSublayer(whiteLayer)
            updateWhiteMaskLayer()
            mask = maskLayer
        }
        
        override func draw(in ctx: CGContext) {
            UIGraphicsPushContext(ctx)
            
            let bounds = ctx.boundingBoxOfClipPath
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            fillColor.setFill()
            path.fill()
            
            let width = bounds.size.width * (_value / Self.maxValue)
            let size = CGSize(width: width, height: bounds.size.height)
            let frame = CGRect(origin: bounds.origin, size: size)
            maskLayer.frame = frame
            
            UIGraphicsPopContext()
        }
        
        override class func needsDisplay(forKey key: String) -> Bool {
            switch key {
                case "_value", "cornerRadius":
                    return true
                default:
                    return super.needsDisplay(forKey: key)
            }
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
        
    }
    
}
