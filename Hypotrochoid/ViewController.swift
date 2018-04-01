//
//  ViewController.swift
//  Hypotrochoid
//
//  Created by Denis Bystruev on 01/04/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelOuterR: UILabel!
    @IBOutlet weak var labelInnerR: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelRotations: UILabel!
    @IBOutlet weak var topSlider: UISlider!
    @IBOutlet weak var bottomSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func topSliderMoved(_ sender: UISlider) {
        updateView()
    }
    
    @IBAction func bottomSliderMoved(_ sender: UISlider) {
        updateView()
    }
    
    let numberOfPoints = 250
    let outerRadius: Float = 100

    // Greatest Common Divisor
    // The greatest common divisor (or Greatest Common Factor) of two numbers a and b is the largest positive integer that divides both a and b without a remainder
    // from https://github.com/raywenderlich/swift-algorithm-club/tree/master/GCD
    func gcd(_ m: Int, _ n: Int) -> Int {
        var a = 0
        var b = max(m, n)
        var r = min(m, n)
        
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }
    
    // Least Common Multiple
    // The least common multiple of two numbers a and b is the smallest positive integer that is a multiple of both. In other words, the LCM is evenly divisible by a and b
    // from https://github.com/raywenderlich/swift-algorithm-club/tree/master/GCD
    func lcm(_ m: Int, _ n: Int) -> Int {
        return m / gcd(m, n) * n
    }
    
    func updateView() {
        let innerRadius = ceil(exp(topSlider.value) * outerRadius)
        let distance = ceil(exp(bottomSlider.value) * innerRadius)

        let commonMultiple = lcm(Int(outerRadius), Int(innerRadius))
        
        
        let numberOfRotations = max(
            commonMultiple / Int(outerRadius),
            commonMultiple / Int(innerRadius)
        )
        
        let deltaR = outerRadius - innerRadius
        let segment = Float(numberOfRotations) * 2 * Float.pi / Float(numberOfPoints)
        
        var x: Float = deltaR + distance
        var y: Float = 0.0
        
        let size = CGSize(width: 1024, height: 1024)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let maxXY = abs(deltaR) + abs(distance)
            let scale = CGFloat(500 / maxXY)

            context.cgContext.translateBy(x: 512, y: 512)
            context.cgContext.scaleBy(x: scale, y: scale)
            context.cgContext.move(to: CGPoint(x: Double(x), y: Double(y)))
            context.cgContext.setLineWidth(5 / scale)

            for i in 1 ... numberOfPoints {
                let theta = Float(i) * segment
                let phi = deltaR * theta / innerRadius
                
                x = deltaR * cos(theta) + distance * cos(phi)
                y = deltaR * sin(theta) - distance * sin(phi)
                
                let point = CGPoint(x: Double(x), y: Double(y))
                context.cgContext.addLine(to: point)
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        labelOuterR.text = "R = \(Int(outerRadius))"
        labelInnerR.text = "r = \(Int(innerRadius))"
        labelDistance.text = "d = \(Int(distance))"
        labelRotations.text = "n = \(Int(numberOfRotations))"
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

}

