//
//  BatteryLevelView.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import Foundation
import UIKit

@IBDesignable
class BatteryLevelView: UIView {
    
    var insets: UIEdgeInsets {
        get {
            batteryLayer.insets
        }
        set {
            batteryLayer.insets = newValue
        }
    }
    
    @IBInspectable
    var padding: CGFloat {
        get {
            batteryLayer.padding
        }
        set {
            batteryLayer.padding = newValue
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat {
        get {
            batteryLayer.lineWidth
        }
        set {
            batteryLayer.lineWidth = newValue
        }
    }
    
    @IBInspectable
    var lineColor: UIColor {
        get {
            batteryLayer.lineColor
        }
        set {
            batteryLayer.lineColor = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            batteryLayer.batteryCornerRadius
        }
        set {
            batteryLayer.batteryCornerRadius = newValue
        }
    }
    
    @IBInspectable
    var symbolColor: UIColor {
        get {
            batteryLayer.symbolColor
        }
        set {
            batteryLayer.symbolColor = newValue
        }
    }
    
    @IBInspectable
    var level: CGFloat {
        get {
            batteryLayer.level
        }
        set {
            batteryLayer.level = newValue
        }
    }
    
    var isCharging: Bool {
        get {
            batteryLayer.isCharging
        }
        set {
            batteryLayer.isCharging = newValue
        }
    }
    
    private var batteryLayer: BatteryLevelLayer {
        return layer as! BatteryLevelLayer
    }
    
    override class var layerClass: AnyClass {
        return BatteryLevelLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        contentScaleFactor = UIScreen.main.scale
        contentMode = UIView.ContentMode.redraw
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        layer.setNeedsDisplay()
    }
    
}
