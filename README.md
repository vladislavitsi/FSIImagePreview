# FSIImagePreview

An easy-to-use, lightweight framework that allows you to implement a fullscreen image opening in every iOS application. Supports for multi images, zoom, double-tap zoom, rotation, all kind of screens. Also you can extend functionality as you like. 

<p align="center">
      <img src="Demonstration/image_preview.gif">
      <img src="Demonstration/image_preview_2.gif">
      <img src="Demonstration/image_preview_3.gif">
</p>

Usage
------

To implement it, you just need to follow steps:

1. Create an instance of FSIViewController class.
2. Set initial view (a view that was tapped usually). 
3. Set array of images, that should be open full screen.
4. Just show it:)

Some examples below.

For Swift:
```swift
let fsiVC = FSIViewController()
fsiVC.initialView = self.imageView  
fsiVC.images = self.imagesArray     
fsiVC.show(on: self)
```
For Objective-C:
```objective-c
FSIViewController *fsiVC = [[FSIViewController alloc] init];
fsiVC.initialView = self.imageView;
fsiVC.images = self.imageArray; 
[fsiVC showOn:self];   
```

## Installation

#### Cocoapods

FSIImagePreview is available through CocoaPods. To install it, simply add the following line to your `Podfile`:
```ruby
pod 'FSIImagePreview', :git => 'https://github.com/vladislavitsi/FSIImagePreview.git'
```


## Requirements

This library requires a deployment target of iOS 10.0 or greater.

## License

FSIImagePreview is available under the MIT license. See [`LICENSE`](https://github.com/vladislavitsi/FSIImagePreview/blob/master/LICENSE) for more information.
