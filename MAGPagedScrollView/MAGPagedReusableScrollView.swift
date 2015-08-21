//
//  MAGPagedReusableScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

@objc protocol MAGPagedReusableScrollViewDataSource {
    func scrollView(scrollView: MAGPagedReusableScrollView, viewIndex index: Int) -> UIView
    func numberOfViews(forScrollView scrollView: MAGPagedReusableScrollView) -> Int
}

class MAGPagedReusableScrollView: MAGPagedScrollView {
    
    @IBOutlet var dataSource:MAGPagedReusableScrollViewDataSource! {
        didSet {
            reload()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reload()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reload()
    }

    
    func reload() {
        clearAllViews()
        if let ds = dataSource {
            viewsCount = ds.numberOfViews(forScrollView: self)
            resizeContent()
            reloadVisisbleViews()
        }
        setNeedsLayout()
    }
    

    var visibleIndexes:[Int] {
        if let viewsCount = viewsCount {
            var result = [Int]()
            let page = pageNumber
            //Add previous page
            if pageNumber > 0 && (pageNumber-1) < viewsCount {
                result.append(pageNumber-1)
            }
            //Add curent page
            if pageNumber < viewsCount {
                result.append(pageNumber)
            }
            //Add next page
            if (pageNumber+1) < viewsCount {
                result.append(pageNumber+1)
            }
            return result
        } else {
            return []
        }
    }
    
    func dequeueReusableView(#tag:Int) -> UIView? {
        for (index, view) in enumerate(dirtyViews) {
            if view.tag == tag {
                dirtyViews.removeAtIndex(index)
                return view
            }
        }
        return nil
    }
    
    func dequeueReusableView(#viewClass:AnyClass) -> UIView? {
        for (index, view) in enumerate(dirtyViews) {
            if view.isKindOfClass(viewClass) {
                dirtyViews.removeAtIndex(index)
                return view
            }
        }
        return nil
    }

  
    override func didMoveToSuperview() {
        super.didMoveToSuperview();
        if superview != nil {
            reload()
        }
    }
//    func willMoveToSuperview(_ newSuperview: UIView?)
    
    //MARK: private data
    private(set) var activeViews:[Int:UIView] = [:]
    private var dirtyViews:[UIView] = []
    private var viewsCount:Int?
    private var itemSize:CGSize = CGSizeZero
    
    private func reloadVisisbleViews() {
        let visibleIdx  = visibleIndexes.sorted{ $0 > $1 }
        let activeIdx = activeViews.keys.array.sorted{ $0 > $1 }
        if visibleIdx != activeIdx {
            //get views to make them dirty
            activeIdx.substract(visibleIdx).map { self.makeViewDirty(index:$0) }
            // add new views
            visibleIdx.substract(activeIdx).map { self.addView(index:$0) }
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        if itemSize != UIEdgeInsetsInsetRect(frame, contentInset).size {
            reload()
            return
        }
        reloadVisisbleViews()
        super.layoutSubviews()
    }

    
    private func makeViewDirty(#index:Int) {
        if let view = activeViews[index] {
            view.removeFromSuperview()
            dirtyViews.append(view)
            activeViews.removeValueForKey(index)
        }
    }
    
    private func addView(#index:Int) {
        
        if let view = dataSource?.scrollView(self, viewIndex: index) {
            view.removeFromSuperview()
            println("frame \(self.frame)")
            println("bounds \(self.bounds)")
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = CGRectGetWidth(frameI)
            let height = CGRectGetHeight(frameI)
            var x:CGFloat = CGFloat(index) * width
            view.frame = CGRectMake(x, 0, width, height)
            view.clipsToBounds = true
            addSubview(view)
            view.layer.transform = CATransform3DIdentity
            activeViews[index] = view
            println("activeViews \(activeViews)")
        }
    }
    
    private func clearAllViews () {
        activeViews.values.map{ $0.removeFromSuperview() }
        activeViews = [:]
        dirtyViews = []
        viewsCount = nil
        itemSize = CGSizeZero
        resizeContent()
    }

    private func resizeContent() {
        if let viewsCount = viewsCount {
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = CGRectGetWidth(frameI)
            let height = CGRectGetHeight(frameI)
            var x:CGFloat = CGFloat(viewsCount) * width
            contentSize = CGSizeMake(x, height)
            itemSize = frameI.size
        } else {
            contentSize = CGSizeZero
            itemSize = CGSizeZero
        }
        contentOffset = CGPointZero
    }
}



extension Array {
    
    func substract <T: Equatable> (values: [T]...) -> [T] {
        var result = [T]()
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //if our internal element is present in substract array
                    //exclude it from result
                    if contains(value, element) {
                        continue elements
                    }
                }
                
                //  element it's only in self, so return it
                result.append(element)
            }
        }
        return result
    }
    
}
