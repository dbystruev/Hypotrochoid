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

    func updateView() {
        let innerRadius = exp(topSlider.value) * outerRadius
        let distance = exp(bottomSlider.value) * innerRadius

        let numberOfRotations = ceil(max(
            outerRadius / innerRadius,
            innerRadius / outerRadius
        ))
        
        let deltaR = outerRadius - innerRadius
        let segment = numberOfRotations * 2 * Float.pi / Float(numberOfPoints)
        
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
        
        labelOuterR.text = "R = \(outerRadius)"
        labelInnerR.text = "r = \(innerRadius)"
        labelDistance.text = "d = \(distance)"
        labelRotations.text = "n = \(Int(numberOfRotations))"
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

}

