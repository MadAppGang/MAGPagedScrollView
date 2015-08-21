//
//  MAGPagedScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

enum MAGPagedScrollViewTransitionType {
    case None
    case Slide
    case Dive
    case Roll
    case Cards
    case Custom
}


class MAGPagedScrollView: UIScrollView {
    
    /// Transition type
    var transition: MAGPagedScrollViewTransitionType = .None {
        didSet {
            setNeedsLayout()
        }
    }
    /// currentPage Number
    var pageNumber:Int   {
        let pageWidth = CGRectGetWidth(self.frame)
        let factionalPage = self.contentOffset.x / pageWidth
        return lround(Double(factionalPage))
    }
    /// Custom transition
    var customTransition = MAGPagedScrollViewTransitionProperties()
    
    private var transitionProperties:[MAGPagedScrollViewTransitionType:MAGPagedScrollViewTransitionProperties]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        pagingEnabled = true
        clipsToBounds = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        transitionProperties = [
            .None:  MAGPagedScrollViewTransitionProperties(),
            .Slide: MAGPagedScrollViewTransitionProperties(angleRatio: 0.0, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D()),
            .Dive:  MAGPagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.0), rotation: Rotation3D(x:-1.0,y:0.0,z:0.0)),
            .Roll:  MAGPagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D(x:-1.0,y:0.0,z:0.0)),
            .Cards: MAGPagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D(x:-1.0,y:-1.0,z:0.0)),
            .Custom:MAGPagedScrollViewTransitionProperties()
        ]
    }

    
    
    func goNext() {
        self.goToPage(self.pageNumber + 1, animated: true)
    }
    
    func goPrevious() {
        self.goToPage(self.pageNumber - 1, animated: true)
    }
    
    func goToPage(page:Int, animated:Bool) {
        var newFrame = frame
        let newX = frame.size.width * CGFloat(page)
        newFrame.origin = CGPoint(x:newX, y:0.0)

        scrollRectToVisible(newFrame, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let tr = transition == .Custom ? customTransition : transitionProperties[transition]!
        
        for view in self.subviews {
            //save tramsform state
            let oldTransform = view.layer?.transform
            view.layer?.transform = CATransform3DIdentity
            
            let centerDX = (view.frame.origin.x - contentOffset.x) * 100 / CGRectGetWidth(frame)
            if let oldTransform = oldTransform {
                view.layer?.transform = oldTransform
            }
            
            let angle = centerDX * tr.angleRatio
            let translateX = CGRectGetWidth(frame) * tr.translation.dx * centerDX / 100.0
            let translateY = CGRectGetWidth(frame) * tr.translation.dy * abs(centerDX) / 100.0
            let transform3D = CATransform3DMakeTranslation(translateX, translateY, 0.0)
            
            view.layer?.transform = CATransform3DRotate(transform3D, angle.degreesToRadians, tr.rotation.x, tr.rotation.y, tr.rotation.z)
        }
    }
    
    
}

struct MAGPagedScrollViewTransitionProperties {
    var angleRatio:     CGFloat = 0.0
    var translation:    CGVector = CGVector(dx:0.0, dy:0.0)
    var rotation:       Rotation3D = Rotation3D()
}

struct Rotation3D {
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var z:CGFloat = 0.0
}


extension CGFloat {
    
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
    
    var radiansToDegrees : CGFloat {
        return CGFloat(self) / CGFloat(M_PI) * 180.0
    }
}