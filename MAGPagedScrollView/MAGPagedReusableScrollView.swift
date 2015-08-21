//
//  MAGPagedReusableScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

protocol MAGPagedReusableScrollViewDataSource {
    func scrollView(scrollView: MAGPagedReusableScrollView, viewIndex index: Int) -> UIView
    func scrollView(scrollView: MAGPagedReusableScrollView, numberOfViews count: Int) -> Int
}

class MAGPagedReusableScrollView: MAGPagedScrollView {
    
    var dataSource:MAGPagedReusableScrollViewDataSource?
    
    
    
    func reload() {
        
    }
    
    private var previousVoisibleCells:[Int] = [];
}


