//
//  MAGPagedReusableScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

@objc protocol PagedReusableScrollViewDataSource {
    func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int
    
    optional func scrollView(#scrollView: PagedReusableScrollView, willShowView view:ViewProvider)
    optional func scrollView(#scrollView: PagedReusableScrollView, willHideView view:ViewProvider)
    optional func scrollView(#scrollView: PagedReusableScrollView, didShowView view:ViewProvider)
    optional func scrollView(#scrollView: PagedReusableScrollView, didHideView view:ViewProvider)

}

class PagedReusableScrollView: PagedScrollView {
    
    @IBOutlet weak var dataSource:PagedReusableScrollViewDataSource! {
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
    
    override func viewsOnScreen() -> [UIView] {
        return visibleIndexes.sorted{ $0 > $1 }.map{ self.activeViews[$0]!.view }
    }

    
    func dequeueReusableView(#tag:Int) -> ViewProvider? {
        for (index, view) in enumerate(dirtyViews) {
            if view.view.tag == tag {
                dirtyViews.removeAtIndex(index)
                view.prepareForReuse?()
                return view
            }
        }
        return nil
    }
    
    func dequeueReusableView(#viewClass:AnyClass) -> ViewProvider? {
        for (index, view) in enumerate(dirtyViews) {
            if view.view.isKindOfClass(viewClass) {
                dirtyViews.removeAtIndex(index)
                view.prepareForReuse?()
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
    
    //MARK: private data
    private(set) var activeViews:[Int:ViewProvider] = [:]
    private var dirtyViews:[ViewProvider] = []
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
            dataSource?.scrollView?(scrollView: self, willHideView: view)
            view.view.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: view)
            view.view.layer.transform = CATransform3DIdentity
            dirtyViews.append(view)
            activeViews.removeValueForKey(index)
        }
    }
    
    private func addView(#index:Int) {
        
        if let view = dataSource?.scrollView(self, viewIndex: index) {
            view.view.removeFromSuperview()
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = CGRectGetWidth(frameI)
            let height = CGRectGetHeight(frameI)
            var x:CGFloat = CGFloat(index) * width
            view.view.frame = CGRectMake(x, 0, width, height)
            view.view.clipsToBounds = true
            dataSource?.scrollView?(scrollView: self, willShowView: view)
            addSubview(view.view)
            dataSource?.scrollView?(scrollView: self, didShowView: view)
            view.view.layer.transform = CATransform3DIdentity
            activeViews[index] = view
        }
    }
    
    private func clearAllViews () {
        for (_ , value) in activeViews {
            dataSource?.scrollView?(scrollView: self, willHideView: value)
            value.view.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: value)
        }
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
