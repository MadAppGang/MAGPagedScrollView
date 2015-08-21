//
//  ViewController2.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 22/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var scrollView: MAGPagedReusableScrollView!

    var colors = [
        UIColor.redColor(),
        UIColor.blueColor(),
        UIColor.greenColor(),
        UIColor.magentaColor(),
        UIColor.lightGrayColor()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func styleChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: scrollView.transition = .Slide
        case 2: scrollView.transition = .Dive
        case 3: scrollView.transition = .Roll
        case 4: scrollView.transition = .Cards
        default: scrollView.transition = .None
        }
    }

    @IBAction func goToEnd(sender: AnyObject) {
        self.scrollView.goToPage(3, animated: true)
    }
}


extension ViewController2: MAGPagedReusableScrollViewDataSource {
    
    func scrollView(scrollView: MAGPagedReusableScrollView, viewIndex index: Int) -> UIView {
        var newView = scrollView.dequeueReusableView(tag: index < 5 ? 1 : 2 )
        if newView == nil {
            if index < 5 {
                newView = UIView(frame: CGRectMake(0, 0, 100, 100))
            } else {
                let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
                imageView.contentMode = .ScaleAspectFill
                newView = imageView
            }
            newView?.tag = index < 5 ? 1 : 2
        }

        if index < 5 {
            newView?.backgroundColor = colors[ index ]
        } else {
            let imageIndex:Int = index - 4
            let imageView = newView as! UIImageView
            imageView.image = UIImage(named:"photo\(imageIndex).jpg")
        }
        
        return newView!
    }
    
    func numberOfViews(forScrollView scrollView: MAGPagedReusableScrollView) -> Int {
        return 10
    }
    
}