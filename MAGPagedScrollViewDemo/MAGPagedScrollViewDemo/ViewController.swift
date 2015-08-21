//
//  ViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: MAGPagedScrollView!
    
    var colors = [
        UIColor.redColor(),
        UIColor.blueColor(),
        UIColor.greenColor(),
        UIColor.magentaColor()
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //alternate way to add subviews
//        createView(0)
//        createView(1)
//        createView(2)
//        createView(3)

        scrollView.addSubviews([
            createView(0),
            createView(1),
            createView(2),
            createView(3)
        ])
    }
    
    @IBAction func goToLast(sender: AnyObject) {
        self.scrollView.goToPage(3, animated: true)
    }
    
    func createView(color: Int) -> UIView {
        var view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = colors[color]
        view.layer.cornerRadius = 10.0
        return view
    }
    
    func createAndAddView(color: Int) {
        let width = CGRectGetWidth(scrollView.frame)
        let height = CGRectGetHeight(scrollView.frame)
        
        let x = CGFloat(scrollView.subviews.count) * width

        var view = UIView(frame: CGRectMake(x, 0, width, height))
        view.backgroundColor = colors[color]
        
        view.layer.cornerRadius = 10.0
        scrollView.addSubview(view)
        scrollView.contentSize = CGSizeMake(x+width, height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func segmentedViewChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: scrollView.transition = .Slide
        case 2: scrollView.transition = .Dive
        case 3: scrollView.transition = .Roll
        case 4: scrollView.transition = .Cards
        default: scrollView.transition = .None
        }
    }
}

