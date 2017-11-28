//  The converted code is limited to 4 KB.
//  Upgrade your plan to remove this limitation.

//  Converted to Swift 4 with Swiftify v1.0.6536 - https://objectivec2swift.com/
/*
 * Copyright (c) StreetHawk, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

class SHCarouselLayout: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        //Paper onboarding's animation is 0.5 duration, be consistent and looks good
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            let arrayItems = self.dictCarousel["items"] as! NSArray
            let tipItem : NSDictionary = arrayItems[index] as! NSDictionary
            let backgroundColorStr = tipItem["backgroundColor"] as! String
            self.viewCarouselContainer?.backgroundColor = SHCarouselLayout.color(from: backgroundColorStr)
        })
        sendFeedResult(for: index)

    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        self.layoutButton(for: index)
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    var viewTip: UIView?
    var dictCarousel : NSDictionary
    var viewCarouselContainer: UIView?
    var constraintBottom: NSLayoutConstraint?
    var button: UIButton?
    static let sharedInstance = SHCarouselLayout()
    
    static let AARRGGBB_COLOUR_CODE_LEN = 8
    
    init() {
    }
    
    func layoutCarousel(on viewContent: UIView, forTip dictCarousel: NSDictionary) {
        let arrayItems = dictCarousel["items"] as! NSArray
        //here get something to show
        button = nil
        //clear
        viewTip = viewContent
        self.dictCarousel = dictCarousel
        let viewCarousel = UIView()
        //viewCarousel has shadow
        viewCarouselContainer = UIView()
        //viewCarouselContainer doesn't have shadow
        viewContent.addSubview(viewCarousel)
        viewCarousel.addSubview(viewCarouselContainer!)
        //must have this otherwise constraints cannot work
        viewCarousel.translatesAutoresizingMaskIntoConstraints = false
        viewCarouselContainer?.translatesAutoresizingMaskIntoConstraints = false
        viewContent.sendSubview(toBack: viewCarousel)
        let colorStr = dictCarousel["borderColor"] as? String
        let borderColor: UIColor? = SHCarouselLayout.color(from: colorStr!)
        viewCarousel.layer.borderColor = borderColor?.cgColor
        let borderStr = dictCarousel["borderWidth"] as? String
        viewCarousel.layer.borderWidth = CGFloat((Float(borderStr ?? "") ?? 0.0))
        let cornerRadiusStr = dictCarousel["cornerRadius"] as? String
        let cornerRadius = CGFloat((Float(cornerRadiusStr ?? "") ?? 0.0))
        viewCarousel.layer.cornerRadius = cornerRadius
        let viewOnboarding = PaperOnboarding(itemsCount: arrayItems.count)
        viewOnboarding.dataSource = self
        viewOnboarding.delegate = self
        viewOnboarding.translatesAutoresizingMaskIntoConstraints = false
        viewCarouselContainer?.addSubview(viewOnboarding)
        viewCarouselContainer?.layer.borderWidth = 0
        viewCarouselContainer?.layer.cornerRadius = cornerRadius
        viewCarouselContainer?.clipsToBounds = true //limit content even with shadow
        let boxShadowStr = dictCarousel["boxShadow"] as? String
        let boxShadow = CGFloat((Float(boxShadowStr ?? "") ?? 0.0))
        if boxShadow == 0 {
            //clipsToBounds and masksToBound not co-work well.
            //when masksToBound=NO it doesn't show shadow,
            //however when masksToBound=YES the subviews go out of bound.
            viewCarousel.clipsToBounds = true
        }
        else {
            viewCarousel.layer.shadowOffset = CGSize(width: boxShadow, height: boxShadow)
            viewCarousel.layer.shadowOpacity = 0.5
            viewCarousel.layer.shadowRadius = cornerRadius
        }
        //use constraints to add the paper onboarding view
        let leadingInner = NSLayoutConstraint(item: viewOnboarding,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: viewCarousel,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 0)
        viewCarousel.addConstraint(leadingInner)
        let trailingInner = NSLayoutConstraint(item: viewOnboarding,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: viewCarousel,
                                               attribute: .trailing,
                                               multiplier: 1.0,
                                               constant: 0)
        viewCarousel.addConstraint(trailingInner)
        let topInner = NSLayoutConstraint(item: viewOnboarding,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: viewCarousel,
                                          attribute: .top,
                                          multiplier: 1.0,
                                          constant: 0)
        viewCarousel.addConstraint(topInner)
        let bottomInner = NSLayoutConstraint(item: viewOnboarding,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: viewCarousel,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: 0)
        viewCarousel.addConstraint(bottomInner)
        constraintBottom = bottomInner
        let leadingStr = dictCarousel["margin.left"] as? String
        let leadingVal = CGFloat((Float(leadingStr ?? "") ?? 0.0))
        let leading = NSLayoutConstraint(item: viewCarousel,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: viewContent,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: leadingVal)
        viewContent.addConstraint(leading)
        let trailingStr = dictCarousel["margin.right"] as? String
        let trailingVal = CGFloat((Float(trailingStr ?? "") ?? 0.0))
        let trailing = NSLayoutConstraint(item: viewCarousel,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: viewContent,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: trailingVal)
        viewContent.addConstraint(trailing)
        let topStr = dictCarousel["margin.top"] as? String
        let topVal = CGFloat((Float(topStr ?? "") ?? 0.0))
        let top = NSLayoutConstraint(item: viewCarousel,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: viewContent,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: topVal)
        viewContent.addConstraint(top)
        let bottomStr = dictCarousel["margin.bottom"] as? String
        let bottomVal = CGFloat((Float(bottomStr ?? "") ?? 0.0))
        let bottom = NSLayoutConstraint(item: viewCarousel,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: viewContent,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: bottomVal)
        viewContent.addConstraint(bottom)
        let leadingContainer = NSLayoutConstraint(item: viewCarouselContainer!,
                                                  attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: viewCarousel,
                                                  attribute: .leading,
                                                  multiplier: 1.0,
                                                  constant: 0)
        viewCarousel.addConstraint(leadingContainer)
        let trailingContainer = NSLayoutConstraint(item: viewCarouselContainer!,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: viewCarousel,
                                                   attribute: .trailing,
                                                   multiplier: 1.0,
                                                   constant: 0)
        viewCarousel.addConstraint(trailingContainer)
        let topContainer = NSLayoutConstraint(item: viewCarouselContainer!,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: viewCarousel,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0)
        viewCarousel.addConstraint(topContainer)
        let bottomContainer = NSLayoutConstraint(item: viewCarouselContainer!,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: viewCarousel,
                                                 attribute: .bottom,
                                                 multiplier: 1.0,
                                                 constant: 0)
        viewCarousel.addConstraint(bottomContainer)
        sendFeedResult(for: 0)
        let tipItem : NSDictionary = arrayItems[0] as! NSDictionary
        let backgroundColorStr = tipItem["backgroundColor"] as! String
        let backgroundColor: UIColor? = SHCarouselLayout.color(from: backgroundColorStr)
        viewCarouselContainer?.backgroundColor = backgroundColor
        //layout button in a delay to get parent frame ready
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(__int64_t(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self.layoutButton(for: 0)
        })
    }
    
    func onboardingItemsCount() -> Int {
        let arrayItems = dictCarousel["items"] as! [NSArray]
        return arrayItems.count
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let item = OnboardingItemInfo();
        let arrayItems = dictCarousel["items"] as! NSArray
        let tipItem : NSDictionary = arrayItems[index] as! NSDictionary
        item.shImage = tipItem["image"] as? UIImage
        item.shImageSource = tipItem["imageSource"] as? String
        item.shTitle = tipItem["titleText"] as? String
        item.shDesc = tipItem["contentText"] as? String
        item.shIcon = tipItem["icon"] as? UIImage
        item.shIconSource = tipItem["iconSource"] as? String
        let backgroundColor = tipItem["backgroundColor"] as? String
        item.shColor = SHCarouselLayout.color(from: backgroundColor!)
        let titlesColor = tipItem["titleColor"] as? String
        item.shTitleColor = SHCarouselLayout.color(from: titlesColor!)
        let contentColor = tipItem["contentColor"] as? String
        item.shDescriptionColor = SHCarouselLayout.color(from: contentColor!)
        item.shTitleFont = tipItem["titleFont"] as? UIFont
        item.shDescriptionFont = tipItem["contentFont"] as? UIFont
        return item;
    }

    class func color(from str: String) -> UIColor {
        if (str.lengthOfBytes(using: String.Encoding.utf8) == AARRGGBB_COLOUR_CODE_LEN + 1) {
            var red : CGFloat = -1
            var green : CGFloat = -1
            var blue : CGFloat = -1
            var alpha : CGFloat = -1
            let scanner = Scanner.init(string: str)
            scanner.scanLocation = 1 // bypass '#' character
            var rgbValue : UInt32 = 0
            scanner.scanHexInt32(&rgbValue)
            red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0;
            green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0;
            blue = CGFloat(rgbValue & 0xFF)/255.0;
            alpha = CGFloat((rgbValue & 0xFF000000) >> 24)/255.0;
            if (red >= 0 && red <= 1
                && green >= 0 && green <= 1
                && blue >= 0 && blue <= 1
                && alpha >= 0 && alpha <= 1)
            {
                return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
            }
            else
            {
                return UIColor.clear
            }
        }
        return UIColor.clear
    }
    
    private func sendFeedResult(for index: Int) {
        let arrayItems = dictCarousel["items"] as! NSArray
        let tipItem : NSDictionary = arrayItems[index] as! NSDictionary
        let dict = ["feed_id": dictCarousel["feed_id"]!,
                    "result": 1,
                    "step_id": tipItem["suid"]!,
                    "delete": false,
                    "complete": false]
        NotificationCenter.default.post(name: NSNotification.Name("SH_PointziBridge_FeedResult_Notification"), object: self, userInfo:dict)
    }
    
    private func layoutButton(for index: Int) {
        let tipItem = ((dictCarousel["items"] as? [Any])[index]) as? [AnyHashable: Any]
        let buttonTarget = tipItem["button_obj"] as? UIButton
        if buttonTarget == nil && button != nil {
            button?.removeFromSuperview()
            button = nil
            constraintBottom.constant = 0
        }
        else if buttonTarget != nil {
            assert(buttonTarget.tag == index, "Wrong tag for button")
            if button != nil {
                //tag is index, it's same so nothing to do
                if buttonTarget.tag == button.tag {
                    return
                }
                else {
                    button.removeFromSuperview()
                }
            }
            //add new bottom button
            button = buttonTarget
            var width = CGFloat(Float(tipItem["button_width"]))
            let height = CGFloat(Float(tipItem["button_height"]))
            let marginTop = CGFloat(Float(tipItem["button_margin_top"]))
            let marginBottom = CGFloat(Float(tipItem["button_margin_bottom"]))
            let marginLeft = CGFloat(Float(tipItem["button_margin_left"]))
            let marginRight = CGFloat(Float(tipItem["button_margin_right"]))
            let sizeContain: CGSize = viewCarouselContainer.frame.size
            constraintBottom.constant = -(marginTop + height + marginBottom)
            if width > 0 && width <= 1 {
                width = sizeContain.width * width
            }
            else if width == 0 {
                width = sizeContain.width
            }
            
            viewCarouselContainer.addSubview(buttonTarget)
            if marginLeft == 0 && marginRight == 0 {
                buttonTarget.frame = CGRect(x: (sizeContain.width - width) / 2, y: sizeContain.height - marginBottom - height, width: width, height: height)
            }
            else if marginLeft != 0 {
                buttonTarget.frame = CGRect(x: marginLeft, y: sizeContain.height - marginBottom - height, width: width, height: height)
            }
            else if marginRight != 0 {
                buttonTarget.frame = CGRect(x: sizeContain.width - marginRight - width, y: sizeContain.height - marginBottom - height, width: width, height: height)
            }
        }
    }
}
