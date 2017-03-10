//
//  RadialGradientLayer.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/7/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {
    
    var defaultGradColors:[CGFloat] = [0, 0, 0, 0.1, 0, 0 , 0, 0.3]
    var locations: [CGFloat] = [0.0, 1.0]
    
    convenience init(gradientColors colors: [CGFloat], gradientLocations locations: [CGFloat]) {
        self.init()
        self.defaultGradColors = colors
        self.locations = locations
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: self.defaultGradColors, locations: self.locations, count: locations.count)
        let gradCenter = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        ctx.drawRadialGradient(gradient!, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
    
}
