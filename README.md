MB_Button
=========

`MB_Button` is a customizable button for iOS 15.0+ swift applications.
It supports differents types of styles according to iOS 15.0 button's configuration.
The main goal is to save time without dealing with native button's configuration property.

## Screenshot

![Example](https://github.com/Bejil/MB_Button/blob/main/Screenshot.png)

## Installation

### Installation via Swift Package Manager

`MB_Button` is available through [Swift Package Manager](https://github.com/Bejil/MB_Button).

To add `MB_Button` as a dependency of your Swift package, simply add the following line to your `Package.swift` file:

```swift
.package(url: "https://github.com/Bejil/MB_Button", from: "1.0.0")
```

## Usage

In order to use `MB_Button` simply add `import MB_Button` at the top of your swift file then use it like this:
```swift
var button:MB_Button = .init()
button.style = .solid
button.tintColor = .systemBlue
button.title = String(key: "Solid button")
button.subtitle = String(key: "with subtitle")
button.image = UIImage(systemName: "car")
button.imagePlacement = .leading
button.isLoading = true
button.cornerStyle = .dynamic
button.cornerRadius = 7
button.titleFont = .boldSystemFont(ofSize: 14)
button.subtitleFont = .systemFont(ofSize: 12)
button.action = { button in
	
}
button.isTouchEffectEnabled = true
...
```

Or you can use it with this simple init method:
```swift
init(style:MB_Button_Style = .solid, title:String? = nil, subtitle:String? = nil, image:UIImage? = nil, andCompletion action:((MB_Button?)->Void)? = nil)
```

## Events handlers
`MB_Button` use one to handle button main touch event `.touchUpInside`
```swift
button.action = { button in
	
}
```
## Customization
`MB_Button` can be customized with these properties:

- `style` affect the general style of the button (`.solid`, `.tinted`, `.gray`, `.bordered`, `.transparent`)
- `tintColor` affect the general tint of the button (background or title, subtitle and border color)
- `alignment` affect the alignment of the first and second lines
- `title` affect the first line of the button (generally the main action)
- `titleFont` affect the font of the title
- `titleColor` affect the color of the title
- `subtitle` affect the second line of the button (genrally a precision for the main action)
- `subtitleFont` affect the font of the subtitle
- `subtitleColor` affect the color of the subtitle
- `image` add a contextual image to illustrate the action
- `imagePadding` defines the padding between the image and the titles
- `imageSize` defines the size of the image/icon of the button
- `imagePlacement` affect the position of the image (`.leading`, `.trailing`, `.bottom`, `.top`)
- `isLoading` add a UIActivityIndicatorView in place of the image
- `cornerStyle` affect the corners of the button (`.dynamic`, `.capsule`, `.fixed`...)
- `cornerRadius` affect the cornerRadius if the `cornerStyle` is set to `.fixed`
- `contentInsets` affect the insets all around the content of the button
- `isTouchEffectEnabled` add an haptic and visual feedback at touch

If you want more customizations options, you can directly get access to button's `configuration` property.

## Override
You can override `MB_Button` and set all of your custom valeurs in the `setUp()` function

```swift
public class CustomButton : MB_Button {
	
	public override func setUp() {
		
		super.setUp()
		
		...
	}
}
```
