# MAGPagedScrollView 
MAGPagedScrollView is collection of some scroll classes that orginise views and view controllers as horizontall scroll flow

## PagedScrollView
Subclass of UIScrollVeiw, that will orginise it's subviews as scrolled cards.

the result looks like that:

![ScreenShot](resources/Basic\ Cards.gif)

to do it, just use  function:

```swift
    func addSubviews(aSubviews: [ViewProvider])
```

here is example of code that demonstrate, how to do it:

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









UIScrollView that works as container for other ViewControllers

[![ScreenShot](resources/MAGPagedScrollViewDemo.gif)](https://raw.githubusercontent.com/MadAppGang/MAGPagedScrollView/master/resources/MAGPagedScrollViewDemo.mov)

### YouTube:
[![youtube](http://img.youtube.com/vi/4xZoOypS128/0.jpg)](http://www.youtube.com/watch?v=4xZoOypS128)


### Installation

add this line to Podfile:

    pod 'MAGPagedScrollView'

