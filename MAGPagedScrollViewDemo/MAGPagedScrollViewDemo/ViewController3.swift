//
//  ViewController3.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 23/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet weak var scrollView: PagedReusableScrollView!
    
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

    
}


extension ViewController3: PagedReusableScrollViewDataSource {
    
    func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider {
        var newView:SimpleCardViewController? = scrollView.dequeueReusableView(tag:  1 ) as? SimpleCardViewController
        if newView == nil {
            newView =  SimpleCardViewController()
        }
        newView?.imageName = "photo\(index%5).jpg"
        return newView!
    }
    
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        return 10
    }
    
}