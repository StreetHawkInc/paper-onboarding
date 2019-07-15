![header](./header.png)

# paper-onboarding
[![Twitter](https://img.shields.io/badge/Twitter-%40usepointzi-blue.svg)](https://twitter.com/usepointzi)

## About
This project is maintained by Pointzi from the original creation by Ramotion Inc.<br>
This fork of the popular Paper Onboarding carousel (or slider) allows you to update the images, design and content WITHOUT re-releasing the App.<br>

The code has been modified to remove hard-coded JSON and instead create an account at https://dashboard.pointzi.com and change the content/design there. 

## Requirements

- iOS 10.0+
- Xcode 8

## Installation

Open pod file, add pod dependency.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
platform :ios, '8.0'

use_frameworks! # This line is compulsory, as "paper-onboarding-pointzi" since it is a swift pod

target 'PointziDemo' do # Replace with your target if you have one

pod "pointzi"
pod "paper-onboarding-pointzi"  # Add this pod if you wish to use carousel

end

```
Run pod update.

Now you can design your beautiful carousels.  

#### Without CocoaPod

Download pointzi paper onboarding source code from https://gitlab.com/pointzi/sdks/paper-onboarding-ios.git

Drag & drop source folder into your app project.

Now you are ready to design your beautiful carousels.


## Usage

#### Storyboard

1) Create a new UIView inheriting from ```PaperOnboarding```

2) Set dataSource in attribute inspector

#### or Code

``` swift
override func viewDidLoad() {
  super.viewDidLoad()

  let onboarding = PaperOnboarding(itemsCount: 3)
  onboarding.dataSource = self
  onboarding.translatesAutoresizingMaskIntoConstraints = false
  view.addSubview(onboarding)

  // add constraints
  for attribute: NSLayoutAttribute in [.Left, .Right, .Top, .Bottom] {
    let constraint = NSLayoutConstraint(item: onboarding,
                                        attribute: attribute,
                                        relatedBy: .Equal,
                                        toItem: view,
                                        attribute: attribute,
                                        multiplier: 1,
                                        constant: 0)
    view.addConstraint(constraint)
  }
}
```

#### For adding content use dataSource methods:

``` swift
func onboardingItemAtIndex(index: Int) -> OnboardingItemInfo {
   return [
     ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", textColor, DescriptionColor, textFont, DescriptionFont),
     ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", textColor, DescriptionColor, textFont, DescriptionFont),
     ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", textColor, DescriptionColor, textFont, DescriptionFont)
   ][index]
 }

 func onboardingItemsCount() -> Int {
    return 3
  }

```

#### configuration contant item:

``` swift
func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {

//    item.titleLabel?.backgroundColor = .redColor()
//    item.descriptionLabel?.backgroundColor = .redColor()
//    item.imageView = ...
  }
```

## Demo
![animation](./preview.gif)

## License

paper-onboarding is released under the MIT license.
See [LICENSE](./LICENSE) for details.

<br>

Follow us for the latest updates<br>
[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://gitlab.com/pointzi/sdks/paper-onboarding-ios)
[![Twitter Follow](https://img.shields.io/twitter/follow/usepointzi.svg?label=%40usepointzi&style=social)](https://twitter.com/usepointzi)


## Keywords
iOS Swift Slider Infoslider Introslider Whatfix NPS Feedback Goal Goals Analytics Segment Segments Appcues Native Tools Tips 

Tours Tips Modals Tool Tipcarousel Tooltips Walkthrough Walkme Guide Bridge  Module Pointzi StreetHawk TipsModals Paper onBoard  

Tooltiptooltip   Tooltip
