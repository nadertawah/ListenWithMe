//
//  ArcSlider.swift
//  ListenWithMe
//
//  Created by nader said on 23/08/2022.
//

import UIKit

class ArcSlider: UIControl
{
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        
        //draw back slider
        unfilledColor.set()
        drawArc(ctx!)
        
        //draw front slider
        filledColor.set()
        drawArc(ctx!, maximumAngle: angle)
        
        //Get the point on the circle for this angle
        var offset = CGPoint()
        offset.y = computedRadius * sin(angle)
        offset.x = computedRadius * cos(angle)
        
        //draw dragabble dot
        let handleCenter =  CGPoint(x: centerPoint.x + offset.x, y: centerPoint.y + offset.y)
        circularSliderHandle.frame = drawHandle(ctx!, atPoint: handleCenter)
    }
    
    static var maxAngle: CGFloat = 5.9341
    static var minAngle: CGFloat = 3.4906

    var centerPoint: CGPoint
    {
        return CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 1.2)
    }
    
    var angle: CGFloat = 3.4906
    var percentage : CGFloat
    {
        return (angle - ArcSlider.minAngle) / (ArcSlider.maxAngle - ArcSlider.minAngle)
    }
    
    // Color of unfilled portion of line
    var unfilledColor: UIColor = .black
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    // Color of filled portion of line
    var filledColor: UIColor = .red
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    // MARK: Private Variables
    fileprivate var radius: CGFloat = -1.0
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    var computedRadius: CGFloat
    {
        if (radius == -1.0)
        {
            return bounds.size.width / 2
        }
        return radius
    }
    
    
    
    // MARK: Handle
    let circularSliderHandle = CALayer()
    
    var handleColor: UIColor?
    {
        didSet
        {
            setNeedsDisplay()
        }
    }

    
    func drawHandle(_ ctx: CGContext, atPoint handleCenter: CGPoint) -> CGRect
    {
        ctx.saveGState()
        var frame: CGRect!
        
        // Ensure that handle is drawn in the correct color
        handleColor = filledColor
        handleColor!.set()
        
        frame = CGRect(x: handleCenter.x - 4, y: handleCenter.y - 4, width: 8, height: 8)
        ctx.fillEllipse(in: frame)
        
        ctx.saveGState()
        return frame
      }
    
    func moveHandle(_ newAngleFromNorth: CGFloat)
    {
        angle = newAngleFromNorth > ArcSlider.maxAngle ||  newAngleFromNorth < ArcSlider.minAngle ? ArcSlider.minAngle : newAngleFromNorth
        setNeedsDisplay()
    }
}


extension ArcSlider
{
    func drawArc(_ ctx: CGContext, maximumAngle: CGFloat = ArcSlider.maxAngle)
    {
        ctx.addArc(
            center: centerPoint,
            radius: computedRadius,
            startAngle: maximumAngle,
            endAngle: ArcSlider.minAngle,
            clockwise: true)
        
        ctx.setLineWidth(5)
        ctx.setLineCap(.butt)
        ctx.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        let lastPoint = touch.location(in: self)
        let lastAngle = getRadAngleFromPoint(point: lastPoint)

        moveHandle(lastAngle)
        sendActions(for: UIControl.Event.valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?)
    {
        sendActions(for: UIControl.Event.editingDidEnd)
    }
    
    
    func changeProgress(percentage : CGFloat)
    {
        let newAngle = ArcSlider.minAngle + ((ArcSlider.maxAngle - ArcSlider.minAngle) * percentage)
        moveHandle(newAngle)
    }
}

// MARK: Trig
extension ArcSlider
{
    static func getAngleRadFromPercentage(percent: CGFloat) ->  CGFloat
    {
        if percent >= 0 && percent <= 100
        {
            return ArcSlider.minAngle + ((ArcSlider.maxAngle - ArcSlider.minAngle) * (percent / 100) )
        }
        return ArcSlider.maxAngle
    }
    
    func getRadAngleFromPoint(point: CGPoint) -> CGFloat
    {
        let v = CGPoint(x: point.x - centerPoint.x, y: point.y - centerPoint.y)
        var rad = atan2(v.y, v.x)
        if rad < 0
        {
            rad += Double.pi * 2
        }
        return rad
    }
    
    func square(_ num:CGFloat) -> CGFloat
    {
        return num * num
    }
}
