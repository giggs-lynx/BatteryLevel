//
//  BatteryLevelView.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import Foundation
import UIKit

class BatteryLevelView: UIView {
    
    var level: CGFloat {
        get {
            batteryLayer.level
        }
        set {
            batteryLayer.level = newValue
        }
    }
    
    var lineWidth: CGFloat {
        get {
            batteryLayer.lineWidth
        }
        set {
            batteryLayer.lineWidth = newValue
        }
    }
    
    var lineColor: UIColor {
        get {
            batteryLayer.lineColor
        }
        set {
            batteryLayer.lineColor = newValue
        }
    }
    
    var batteryInsets: UIEdgeInsets {
        get {
            batteryLayer.insets
        }
        set {
            batteryLayer.insets = newValue
        }
    }
    
    var batteryCornerRadius: CGFloat {
        get {
            batteryLayer.batteryCornerRadius
        }
        set {
            batteryLayer.batteryCornerRadius = newValue
        }
    }
    
    var batteryLayer: BatteryLevelLayer {
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
        contentScaleFactor = UIScreen.main.scale
        contentMode = UIView.ContentMode.redraw
    }
    
}
