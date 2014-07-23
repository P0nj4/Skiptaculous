//
//  RTUIColorExtensions.swift
//  RTUtils
//
//  Created by Oleh Filipchuk on 15/06/2014.
//  Copyright (c) 2014 Oleh Filipchuk. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func blend(startColor:UIColor, endColor:UIColor, location:CGFloat) -> UIColor
    {
        let rgba1 = startColor.rgba();
        let rgba2 = endColor.rgba();
        
        let red:CGFloat = location * (rgba1.red + rgba2.red);
        let green:CGFloat = location * (rgba1.green + rgba2.green);
        let blue:CGFloat = location * (rgba1.blue + rgba2.blue);
        let alpha:CGFloat = location * (rgba1.alpha + rgba2.alpha);
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha);
    }
    
    convenience init(hex:UInt)
    {
        let red:CGFloat = CGFloat((hex & 0xFF0000) >> 16)/255.0;
        let green:CGFloat = CGFloat((hex & 0xFF00) >> 8)/255.0;
        let blue:CGFloat = CGFloat(hex & 0xFF)/255.0;
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0);
    }
    
    func hsba()->(hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat)
    {
        var h:CGFloat = 0.0;
        var s:CGFloat = 0.0;
        var b:CGFloat = 0.0;
        var a:CGFloat = 1.0;
        self.getHue(&h, saturation:&s, brightness:&b, alpha:&a);
        
        return (hue:h, saturation:s, brightness:b, alpha:a);
    }
    
    func rgba()->(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)
    {
        var r:CGFloat = 0.0;
        var g:CGFloat = 0.0;
        var b:CGFloat = 0.0;
        var a:CGFloat = 0.0;
        self.getRed(&r, green: &g, blue: &b, alpha: &a);
        
        return (red:r, green:g, blue:b, alpha:a);
    }
    
    func darkerColor(step:Float = 0.25)->UIColor!
    {
        let (hue, saturation, brightness, alpha) = self.hsba();
        let addedBrightness = 1.0 - CGFloat(step);
        let newBrightness = brightness * addedBrightness;
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha);
        
    }
    
    func lighterColor(step:Float = 0.25)->UIColor!
    {
        let (hue, saturation, brightness, alpha) = self.hsba();
        let addedBrightness = 1.0 + CGFloat(step);
        let newBrightness = min(brightness * addedBrightness, 1.0);
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha);
    }
}