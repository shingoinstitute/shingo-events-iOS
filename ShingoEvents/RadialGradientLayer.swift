//
//  RadialGradientLayer.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/7/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let locations:[CGFloat] = [0.0, 1.0]
        let gradColors: [CGFloat] = [0, 0, 0, 0.1, 0, 0 , 0, 0.3]
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: gradColors, locations: locations, count: locations.count)
        let gradCenter = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        ctx.drawRadialGradient(gradient!, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
    
}
