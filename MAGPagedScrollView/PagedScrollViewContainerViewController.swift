//
//  PagedScrollViewContainerViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 28/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit


/// Base class for implementing ViewController as container
/// If you want owner (ViewController) of PagedScrollView to be a container
/// just make your view controller subclass of PagedScrollViewContainerViewController

public class PagedScrollViewContainerViewController: UIViewController, PagedReusableScrollViewDataSource {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - PagedReusableScrollViewDataSource
    public func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider {
        assertionFailure("have to be implemented in subclass")
        //just have to return something
        return self
    }
    
    public func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        assertionFailure("have to be implemented in subclass")
        return 0
    }
    
    public func scrollView(scrollView scrollView: PagedReusableScrollView, willShowView view:ViewProvider) {
        if let vc = view as? UIViewController {
            self.addChildViewController(vc)
        }
    }
    
    public func scrollView(scrollView scrollView: PagedReusableScrollView, willHideView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.willMoveToParentViewController(nil)
        }
    }
    
    public func scrollView(scrollView scrollView: PagedReusableScrollView, didShowView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.didMoveToParentViewController(self)
        }
    }
    
    public func scrollView(scrollView scrollView: PagedReusableScrollView, didHideView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.removeFromParentViewController()
        }
    }

    

}
