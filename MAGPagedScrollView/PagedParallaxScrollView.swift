//
//  PagedParallaxScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 26/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit


@objc public protocol PagedScrollViewParallaxDelegate: class {
    //parallax from -100 to 100. 0 is central position.
     func parallaxProgressChanged(progress:Int)
}

public class PagedParallaxScrollView: PagedReusableScrollView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        for view in viewsOnScreen() {
            if let parallaxView = view as? PagedScrollViewParallaxDelegate {
                let oldTransform = view.layer.transform
                view.layer.transform = CATransform3DIdentity
                let centerDX = Int((view.frame.origin.x - contentOffset.x) * 100 / CGRectGetWidth(frame))
                view.layer.transform = oldTransform
                parallaxView.parallaxProgressChanged(centerDX)
            }
        }
    }
}
