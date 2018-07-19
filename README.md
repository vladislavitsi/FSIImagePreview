# FSIImagePreview

An easy-to-use, lightweight framework that allows you to implement fullscreen image opening in every iOS application.

To implement it, you just need to add this code in subclass of UIViewController.

For Swift:
``` 
let fsiVC = FSIViewController()
fsiVC.initialView = self.imageView  // To enable a beautiful animation of image opening
fsiVC.images = self.imagesArray     // You need to pass an array of images you want to show
present(fsiVC, animated: false)     // Just present this object modaly, without animations
```
For Objective-C:
``` 
FSIViewController *fsiVC = [[FSIViewController alloc] init];
fsiVC.initialView = self.imageView;      // To enable a beautiful animation of image opening
fsiVC.images = self.imageArray;       // You need to pass an array of images you want to show
[self presentViewController:fsiVC animated:false completion:nil];       // Just present this object modaly, without animations
```
