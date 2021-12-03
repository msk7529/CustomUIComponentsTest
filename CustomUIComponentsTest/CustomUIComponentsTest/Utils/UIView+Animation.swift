//
//  UIView+Animation.swift
//  CustomUIComponentsTest
//
//  Created on 2021/12/03.
//

import UIKit

public extension UIView {
    private var kRotationAnimationKey: String {
        get {
            return "rotationanimationkey"
        }
    }
    private var kStopRotationAnimationKey: String {
        get {
            return "stopRotationanimationkey"
        }
    }
    
    func popAnimation(duration: Double = 0.5) {
        self.transform = self.transform.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: {
                        self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func zoomInAndPop(duration: Double = 0.5, from scale: CGFloat = 0.001, completion: @escaping (() -> Swift.Void)) {
        self.transform = self.transform.scaledBy(x: scale, y: scale)
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: {
                        self.alpha = 1
                        self.transform = CGAffineTransform.identity
        }) { _ in
            completion()
        }
    }
    
    func zoomIn(duration: TimeInterval = 0.25, completion: @escaping (() -> Swift.Void)) {
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion()
        }
    }
    
    func zoomOut(duration: TimeInterval = 0.15, completion: @escaping (() -> Swift.Void)) {
        self.alpha = 1
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { _ in
            completion()
        }
    }
    
    @objc func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-8, 8, -8, 8, -5, 5, -2, 2, 0]
        layer.add(animation, forKey: "shake")
    }
    
    func startRotate(duration: TimeInterval = 1.0, repeatCount: Float) {
        self.layer.speed = 1.0
        if self.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = repeatCount
            self.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        } else {
            self.resumeWith(layer: self.layer)
        }
    }

    func stopRotate(formerPlaceAnimation: Bool = false, duration: TimeInterval = 1.0) {
        guard let _ = self.layer.animation(forKey: kRotationAnimationKey) as? CABasicAnimation else { return }
        self.layer.removeAnimation(forKey: kRotationAnimationKey)

        if formerPlaceAnimation == true {
            guard var currentAngle = (self.layer.presentation()?.value(forKeyPath: "transform.rotation") as? NSNumber)?.floatValue else { return }
            if currentAngle < 0 {
                currentAngle = currentAngle + (Float.pi * 2.0)
            }
            
            var duration2 = 0.0
            duration2 = duration * Double((Float.pi * 2.0 - currentAngle) / (Float.pi * 2.0))
            
            if self.layer.animation(forKey: kStopRotationAnimationKey) == nil {
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.fromValue = currentAngle
                rotationAnimation.toValue = Float.pi * 2.0
                rotationAnimation.duration = duration2
                rotationAnimation.repeatCount = 0
                rotationAnimation.isRemovedOnCompletion = true
                self.layer.add(rotationAnimation, forKey: kStopRotationAnimationKey)
            }
        }
    }
    
    func pauseRotate() {
        self.pauseWith(layer: self.layer)
    }
    
    func pauseWith(layer: CALayer) {
        if layer.speed == 0 { return }
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeWith(layer: CALayer) {
        if layer.speed == 1.0 { return }
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let pausedTime = layer.timeOffset
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func animateCornerRadius(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.cornerRadius = to
        }
        layer.add(animation, forKey: "cornerRadius")
        CATransaction.commit()
    }
}

