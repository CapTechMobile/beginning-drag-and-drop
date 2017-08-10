# Beginning Drag and Drop in iOS 11
Apple dropped an exciting new feature into iOS this year at WWDC: Drag and Drop! New in iOS 11, moving data between apps is now as simple as dragging your finger across the screen. This will quickly become an essential feature that users will expect in every app. Fortunately it is very simple to support with just a few lines of code. We will start with the basics.

Be sure to follow along with the [sample code](https://github.com/CapTechMobile/beginning-drag-and-drop).

## Becoming a drop target
The easiest way to support dropping data into your app is to leverage the new [`UIPasteConfigurationSupporting`](https://developer.apple.com/documentation/uikit/uipasteconfigurationsupporting) protocol. This is easy because [`UIResponder`](https://developer.apple.com/documentation/uikit/uiresponder) already conforms, so every view and view controller is ready to go. There are only two things you need to do: specify the types of data you want accept and load the data when it is dropped.

Specify the data you want to accept using [`UIPasteConfiguration`](https://developer.apple.com/documentation/uikit/uipasteconfiguration). Create on by passing in an array of type identifier strings and then assign it to the new `pasteConfiguration` property on your view or view controller:

```swift
pasteConfiguration = UIPasteConfiguration(acceptableTypeIdentifiers: ["public.jpeg"])
```

Now override the `paste()`function to load data that gets dropped. It is possible for users to drop multiple at the same time. Each dropped item is represented by an [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider) instance and they all arrive in an array. Ask the item provider to load the data and then put it to use:

```swift
override func paste(itemProviders: [NSItemProvider]) {
    for itemProvider in itemProviders {
        itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (providedImage, error) in
            guard let image = providedImage as? UIImage else {
                print("Invalid image type")
                return
            }
            // Do something with the image
        })
    }
}
```

That's all you need to do to support dropping data onto your views! The paste configuration tells the system which types of data can be dropped and the `paste()` function loads the data. For more control, you can override `canPaste()` to dynamically specify whether particular items can be dropped.

> **Note:** It's worth thinking about where the `pasteConfiguration` will be set and where the `paste()` function will be overridden. You might have one specific view where you intend to accept drops but it would be nice if your view controller could handle loading. Fortunately the responder chain makes that easy. You can assign a paste configuration to that specific view (make sure `isUserInteractionEnabled` is `true`) and override the `paste()` function in the view controller and then everything will “just work”. But this approach breaks down if your view controller contains more than one drop target. The `paste()` function gives no indication of which view the drop came from. If you have multiple views per view controller that can accept drops then each view may need to override `paste()`. Whatever you decide to do just keep in mind that dropped items will be passed up the responder chain until a responder is able to handle them.

## Becoming a drag item
Making draggable items is just as easy accepting drops. Again there are two steps: make views draggable and provide the corresponding data. These two steps are accomplished using a [`UIDragInteraction`](https://developer.apple.com/documentation/uikit/uidraginteraction) and a corresponding delegate.

Views become draggable when a [`UIDragInteraction`](https://developer.apple.com/documentation/uikit/uidraginteraction) is added to the them using the new `addInteraction()` function. The view must have user interaction enabled:

```swift
let dragInteraction = UIDragInteraction(delegate: self)
myDraggableView.addInteraction(dragInteraction)
myDraggableView.isUserInteractionEnabled = true
```

The drag interaction takes a delegate which will provide the actual data. The data will be encapsulated in [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider) instances just like we received in the `paste()` function above. These are created by passing in objects that conform to [`NSItemProviderWriting`](https://developer.apple.com/documentation/foundation/nsitemproviderwriting). When dragging begins the delegate needs to provide any such providers in corresponding instances of [`UIDragItem`](https://developer.apple.com/documentation/uikit/uidragitem):

```swift
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    guard let text = dragLabel.text, text != "" else {
        // The drag will not be performed
        return []
    }

    // Must cast to NSString which conforms to NSItemProviderWriting
    let providableText = text as NSString

    let itemProvider = NSItemProvider(object: providableText)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    return [dragItem]
}
```

[`NSString`](https://developer.apple.com/documentation/foundation/nsstring) conforms to [`NSItemProviderWriting`](https://developer.apple.com/documentation/foundation/nsitemproviderwriting), but [`String`](https://developer.apple.com/documentation/swift/string) doesn't, so we need to cast before creating our [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider).

With this one function we are fulfilling the only requirement of the delegate by providing an array of drag items for the drag interaction. A drag will *not* be performed if that array is empty. There are many other optional functions that the delegate can provide for customization but those are beyond the scope of this post.

## Conclusion
It only takes a few lines of code to become a drop target or to provide a draggable item. With such a low barrier to entry there is little reason not to include drag and drop support in your apps anywhere that it makes sense. Users will quickly come to expect it.
