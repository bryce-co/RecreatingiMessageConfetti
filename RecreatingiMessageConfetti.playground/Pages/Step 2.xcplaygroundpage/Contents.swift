//: [Previous](@previous)

import PlaygroundSupport
import UIKit

// Step 0: Playground Setup
let view = UIView()
view.backgroundColor = .white
view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

// Step 1: Creating Confetti Images

/**
 Represents a single type of confetti piece.
 */
class ConfettiType {
    let color: UIColor
    let shape: ConfettiShape
    let position: ConfettiPosition

    init(color: UIColor, shape: ConfettiShape, position: ConfettiPosition) {
        self.color = color
        self.shape = shape
        self.position = position
    }
    
    lazy var image: UIImage = {
        let imageRect: CGRect = {
            switch shape {
            case .rectangle:
                return CGRect(x: 0, y: 0, width: 20, height: 13)
            case .circle:
                return CGRect(x: 0, y: 0, width: 10, height: 10)
            }
        }()

        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)

        switch shape {
        case .rectangle:
            context.fill(imageRect)
        case .circle:
            context.fillEllipse(in: imageRect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }()
}

enum ConfettiShape {
    case rectangle
    case circle
}

enum ConfettiPosition {
    case foreground
    case background
}

var confettiTypes: [ConfettiType] = {
    let confettiColors = [
        (r:149,g:58,b:255), (r:255,g:195,b:41), (r:255,g:101,b:26),
        (r:123,g:92,b:255), (r:76,g:126,b:255), (r:71,g:192,b:255),
        (r:255,g:47,b:39), (r:255,g:91,b:134), (r:233,g:122,b:208)
        ].map { UIColor(red: $0.r / 255.0, green: $0.g / 255.0, blue: $0.b / 255.0, alpha: 1) }

    // For each position x shape x color, construct an image
    return [ConfettiPosition.foreground, ConfettiPosition.background].flatMap { position in
        return [ConfettiShape.rectangle, ConfettiShape.circle].flatMap { shape in
            return confettiColors.map { color in
                return ConfettiType(color: color, shape: shape, position: position)
            }
        }
    }
}()

// Step 2: Basic Emitter Layer Setup

var confettiCells: [CAEmitterCell] = {
    return confettiTypes.map { confettiType in
        let cell = CAEmitterCell()
        
        cell.beginTime = 0.1
        cell.birthRate = 10
        cell.contents = confettiType.image.cgImage
        cell.emissionRange = CGFloat(Double.pi)
        cell.lifetime = 10
        cell.spin = 4
        cell.spinRange = 8
        cell.velocityRange = 100
        cell.yAcceleration = 150
        
        return cell
    }
}()

var confettiLayer: CAEmitterLayer = {
    let emitterLayer = CAEmitterLayer()

    emitterLayer.emitterCells = confettiCells
    emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.minY - 500)
    emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 500)
    emitterLayer.emitterShape = .rectangle
    emitterLayer.frame = view.bounds

    emitterLayer.beginTime = CACurrentMediaTime()
    return emitterLayer
}()

// And finally...

view.layer.addSublayer(confettiLayer)
PlaygroundPage.current.liveView = view

//: [Next](@next)
