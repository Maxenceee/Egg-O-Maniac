//
//  progressBar.swift
//  EggTimer
//
//  Created by Maxence Gama on 19/10/2020.
//

import UIKit

@available(iOS 14.0, *)
class ProgressBar: UIView {
    
    @IBInspectable public var backgroundCircleColor: UIColor = UIColor(hexString: "#FFFFFF", alpha: 0.1)
    @IBInspectable public var startGradientColor: UIColor = UIColor.red
    @IBInspectable public var endGradientColor: UIColor = UIColor.yellow
    @IBInspectable public var textColor: UIColor = UIColor.black

    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var gradientLayer: CAGradientLayer!
    
    public var progress: CGFloat = 0 {
        didSet {
            didProgessUpdated()
        }
    }
    public var timerText: String = "" {
        didSet {
            didTextUpdated()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        guard layer.sublayers == nil else {
            return
        }
        
        let width = rect.width
        let height = rect.height
        
        let lineWidth = 0.05 * min(width, height)
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: backgroundCircleColor.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.red.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
        
        textLayer = createTextLayer(rect: rect, textColor: textColor.cgColor)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(textLayer)
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width/2, y: height/2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = CGFloat.pi/2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
    
    }
    
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 5
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress))"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 3, width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        
        return layer
    }
    
    private func didProgessUpdated() {
        //textLayer?.string = "\(Int(progress * 100))"
        foregroundLayer?.strokeEnd = progress
        
        let isColorCustom = UserDefaults.standard.object(forKey: "isColorCustom") as? Bool
        
        if isColorCustom != nil && isColorCustom == true {
            let customColor1 = UserDefaults.standard.colorForKey(key: "customColor1")
            let customColor2 = UserDefaults.standard.colorForKey(key: "customColor2")
            
            gradientLayer.colors = [customColor1!.cgColor, customColor2!.cgColor]
        } else {
            let savedrow = UserDefaults.standard.object(forKey: "PBrow") as? Int
            
            //print("newrow : ", savedrow!)
            if savedrow != nil {
                gradientLayer.colors = [ColorList.firstColorList[savedrow!].cgColor, ColorList.secondColorList[savedrow!].cgColor]
            }
        }
    }
    
    private func didTextUpdated() {
        let (_,m,s) = secondsToHoursMinutesSeconds(seconds: Int(timerText)!)
        textLayer?.string = String(m) + ":" + String(s)
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
      }

}

