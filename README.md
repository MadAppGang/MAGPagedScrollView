# MAGPagedScrollView 
MAGPagedScrollView is collection of some scroll classes that orginise views and view controllers as horizontall scroll flow

Here is video demo:

[![youtube](http://img.youtube.com/vi/HgSKxQVIOq0/0.jpg)](http://www.youtube.com/watch?v=HgSKxQVIOq0)

### Installation

add this line to Podfile:
```
    pod 'MAGPagedScrollView'
```

## PagedScrollView
Subclass of UIScrollVeiw, that will orginise it's subviews as scrolled cards.
And it's base class for other guys as well: **PagedReusableScrollView** and **PagedParallaxScrollView**.

the result looks like that:

![ScreenShot](resources/Basic\ Cards.gif)

to do it, just use this function:

```swift
    func addSubviews(aSubviews: [ViewProvider])
```

and add couple lines of code, here is example of code that demonstrate, how to do it:

```swift

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        scrollView.addSubviews([
            createView(0),
            createView(1),
            createView(2),
            createView(3)
        ])
    }
    

    func createView(color: Int) -> UIView {
        var view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.randomColor
        view.layer.cornerRadius = 10.0
        return view
    }

```

So the **PagedScrollView** operate with **ViewProvider** :

```swift
@objc protocol ViewProvider {
    var view: UIView! { get }
}
```

so **ViewProvider** is the class that can provide view. **UIViewController** is already could be used, providing it's own view.
**UIView** itself is also a **ViewProvider**, providing itself.

> Keep in mind, **PagedScrollView** don't keep reference to ViewProviders, so you have to handle ownership of this objects by yourself. But the views, that were provided by ViewProviders will be added as subview, so they will be reverenced by **PagedScrollView**

## Transition

You can use 5 build in transform classes for views sliding

### None

![ScreenShot](resources/Basic\ Cards.gif)

```swift
scrollView.transition = .None
```

### Slide

![ScreenShot](resources/SlideDemo.gif)

```swift
scrollView.transition = .Slide
```

### Dive

![ScreenShot](resources/DiveDemo.gif)

```swift
scrollView.transition = .Dive
```

### Roll

![ScreenShot](resources/RollDemo.gif)

```swift
scrollView.transition = .Roll
```

### Cards

![ScreenShot](resources/CardsDemo.gif)

```swift
scrollView.transition = .Cards
```


## PagedReusableScrollView
That class works a UITabelViewController, it reuse **ViewProvider**. So you have to implement **PagedReusableScrollViewDataSource** protocol. This class owns  the ViewProvider objects and provide two functions for reuse:

```swift
    func dequeueReusableView(#tag:Int) -> ViewProvider?
    func dequeueReusableView(#viewClass:AnyClass) -> ViewProvider? 
```

so **ViewProvider** could be reused by tag or class

**PagedReusableScrollViewDataSource** require that functions:

```swift
    func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int
```

so putting all together, the example implementation could be like that:

```swift
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
```

the result will be like that:

![ScreenShot](resources/ReusableDemo.gif)
