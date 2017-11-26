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
    var viewTip: UIView?
    var dictCarousel = [AnyHashable: Any]()
    var viewCarouselContainer: UIView?
    var constraintBottom: NSLayoutConstraint?
    var button: UIButton?
    
    class func color(from str: String) -> UIColor {
        if !(str is String) {
            return nil
        }
        if (str.count ?? 0) == RGB_COLOUR_CODE_LEN + 1 || (str.count ?? 0) == RRGGBB_COLOUR_CODE_LEN + 1 || (str.count ?? 0) == AARRGGBB_COLOUR_CODE_LEN + 1 {
            return self.color(fromHexString: str)
        }
        else {
            return self.color(fromRGBString: str)
        }
        return nil
    }
    
    private func sendFeedResult(for index: Int) {
        let tipItem = ((dictCarousel["items"] as? [Any])[index]) as? [AnyHashable: Any]
        let dict = ["feed_id": dictCarousel["feed_id"], "result": 1, "step_id": tipItem["suid"], "delete": false, "complete": false]
        NotificationCenter.default.post(name: NSNotification.Name("SH_PointziBridge_FeedResult_Notification"), object: self, userInfo: dict)
    }
    
    private     func layoutButton(for index: Int) {
        let tipItem = ((dictCarousel["items"] as? [Any])[index]) as? [AnyHashable: Any]
        let buttonTarget = tipItem["button_obj"] as? UIButton
        if buttonTarget == nil && button != nil {
            button.removeFromSuperview()
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
