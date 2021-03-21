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

@objc(SHCarouselBridge)
class SHCarouselBridge : NSObject
{
    //for layout carousel in the given view.
    //notification name: SH_CarouselBridge_LayoutCarousel; user info: @{@"view": view_content, @"tip": dictTip}].
    
    @objc class func layoutCarouselHandler(_ notification: Notification) {
        let viewContent = notification.userInfo!["view"] as! UIView
        //tip controller's content view
        let dictTip = notification.userInfo!["tip"] as! NSDictionary
        let stepId  = notification.userInfo!["stepId"] as! NSString
        SHCarouselLayout.sharedInstance.previousIndex = 0
        SHCarouselLayout.sharedInstance.stepId = stepId as String
        SHCarouselLayout.sharedInstance.layoutCarousel(on: viewContent, forTip: dictTip)
    }
    
    @objc class func nextCarousel(_ notification: Notification) {
        let stepId  = notification.userInfo!["stepId"] as! NSString
        let index  =  stepId.intValue
        SHCarouselLayout.sharedInstance.viewOnboarding.currentIndex(Int(index), animated: true)
       
    }
    
    @objc class func bridgeHandler(_ notification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.layoutCarouselHandler),
                                               name: NSNotification.Name(rawValue: "SH_CarouselBridge_LayoutCarousel"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextCarousel),
                                               name: NSNotification.Name(rawValue: "SH_CarouselBridge_Next"),
                                               object: nil)
    }
    
    // MARK: - private functions
}
