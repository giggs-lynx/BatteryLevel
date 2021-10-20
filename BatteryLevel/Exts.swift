//
//  Exts.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import Foundation
import UIKit

public extension UIColor {
    // https://stackoverflow.com/questions/22868182/uicolor-transition-based-on-progress-value
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor {
        let f = min(max(0, fraction), 1)

        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return .clear }

        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

public extension CGFloat {
    
    static func radian(by degrees: Self) -> Self {
        return .pi * degrees / 180.0
    }
    
}

public extension CGPoint {
    
    static func - (l: Self, r: Self) -> Self {
        Self(x: l.x - r.x, y: l.y - r.y)
    }
    
    static func -= (l: inout Self, r: Self) -> Void {
        l = l - r
    }
    
    static func + (l: Self, r: Self) -> Self {
        Self(x: l.x + r.x, y: l.y + r.y)
    }
    
    static func += (l: inout Self, r: Self) -> Void {
        l = l + r
    }
    
    static func - (l: Self, r: CGVector) -> Self {
        Self(x: l.x - r.dx, y: l.y - r.dy)
    }
    
    static func -= (l: inout Self, r: CGVector) -> Void {
        l = l - r
    }
    
    static func + (l: Self, r: CGVector) -> Self {
        Self(x: l.x + r.dx, y: l.y + r.dy)
    }
    
    static func += (l: inout Self, r: CGVector) -> Void {
        l = l + r
    }
    
    static func + (l: Self, r: (dx: CGFloat, dy: CGFloat)) -> Self {
        Self(x: l.x + r.dx, y: l.y + r.dy)
    }
    
    static func += (l: inout Self, r: (dx: CGFloat, dy: CGFloat)) -> Void {
        l = l + r
    }
    
    static func - (l: Self, r: (dx: CGFloat, dy: CGFloat)) -> Self {
        Self(x: l.x - r.dx, y: l.y - r.dy)
    }
    
    static func -= (l: inout Self, r: (dx: CGFloat, dy: CGFloat)) -> Void {
        l = l - r
    }
    
}

public extension CGRect {
    
    var topLeft: CGPoint {
        return origin
    }
    
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    
    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    
    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    var centre: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
}

public extension UIColor {

    convenience init(rgb: UInt32) {
        let argb = 0xFF << (8 * 3) + rgb
        
        self.init(argb: argb)
    }
    
    convenience init(argb: UInt32) {
        let a: UInt32 = argb >> (8 * 3) & 0xFF
        let r: UInt32 = argb >> (8 * 2) & 0xFF
        let g: UInt32 = argb >> (8 * 1) & 0xFF
        let b: UInt32 = argb >> (8 * 0) & 0xFF

        self.init(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: CGFloat(a) / 0xFF)
    }

    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let scanner = Scanner(string: hex)

        guard
            let u64 = scanner.scanUInt64(representation: .hexadecimal),
            let val = UInt32(exactly: u64)
        else {
            return nil
        }

        switch hex.count {
        case 3:
            let a = 0xFF
            let r = val >> (4 * 2) & 0xF * 0x11
            let g = val >> (4 * 1) & 0xF * 0x11
            let b = val >> (4 * 0) & 0xF * 0x11
            self.init(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: CGFloat(a) / 0xFF)
        case 6:
            self.init(rgb: val)
        case 8:
            self.init(argb: val)
        default:
            return nil
        }
    }

    class var random: UIColor {
        // use 256 to get full range from 0.0 to 1.0
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256

        // from 0.5 to 1.0 to stay away from white
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5

        // from 0.5 to 1.0 to stay away from black
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var r: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getHue(&(r.0), saturation: &(r.1), brightness: &(r.2), alpha: &(r.3))
        return r
    }

    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.5, resultAlpha: -1)
    }
    
    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        else {return self}
        
        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
    
}
