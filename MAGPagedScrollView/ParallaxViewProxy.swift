//
//  ParallaxViewProxy.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 26/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

public class ParallaxViewProxy: UIView, PagedScrollViewParallaxDelegate {


    @IBOutlet public weak var parallaxController:PagedScrollViewParallaxDelegate? = nil
    
    public func parallaxProgressChanged(progress:Int) {
        if let pc = parallaxController {
            pc.parallaxProgressChanged(progress)
        }
    }
}
