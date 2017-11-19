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

#import "SHCarouselLayout.h"
//header from PaperOnboarding
#import <PaperOnboarding/PaperOnboarding-Swift.h>

@interface SHCarouselLayout () <PaperOnboardingDataSource, PaperOnboardingDelegate>

@property (nonatomic, strong) UIView *viewTip;
@property (nonatomic, strong) NSDictionary *dictCarousel;

@property (nonatomic, strong) UIView *viewCarouselContainer;
@property (nonatomic, strong) NSLayoutConstraint *constraintBottom;
@property (nonatomic, strong) UIButton *button;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)sendFeedResultForIndex:(NSInteger)index;
- (void)layoutButtonForIndex:(NSInteger)index;

@end

@implementation SHCarouselLayout

+ (SHCarouselLayout *)sharedInstance
{
    static SHCarouselLayout *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SHCarouselLayout alloc] init];
    });
    return sharedInstance;
}

- (void)layoutCarouselOnView:(UIView *)viewContent forTip:(NSDictionary *)dictCarousel
{
    //not have any carousel to show
    if (viewContent == nil
        || dictCarousel == nil)
    {
        return;
    }
    NSAssert([dictCarousel isKindOfClass:[NSDictionary class]], @"Expect dictionary.");
    if (![dictCarousel isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSArray *arrayItems = dictCarousel[@"items"];
    if (arrayItems == nil)
    {
        return;
    }
    NSAssert([arrayItems isKindOfClass:[NSArray class]], @"Expect array.");
    if (![arrayItems isKindOfClass:[NSArray class]])
    {
        return;
    }
    if (arrayItems.count == 0)
    {
        return;
    }
    //here get something to show
    self.viewTip = viewContent;
    self.dictCarousel = dictCarousel;
    UIView *viewCarousel = [[UIView alloc] init];
    self.viewCarouselContainer = viewCarousel;
    [viewContent addSubview:viewCarousel];
    //must have this otherwise constraints cannot work
    viewCarousel.translatesAutoresizingMaskIntoConstraints = NO;
    [viewContent sendSubviewToBack:viewCarousel];
    UIColor *borderColor = [SHCarouselLayout colorFromHexString:dictCarousel[@"borderColor"]];
    viewContent.layer.borderColor = borderColor.CGColor;
    viewContent.layer.borderWidth = [dictCarousel[@"borderWidth"] floatValue];
    CGFloat cornerRadius = [dictCarousel[@"cornerRadius"] floatValue];
    viewContent.layer.cornerRadius = cornerRadius;
    PaperOnboarding *viewOnboarding = [[PaperOnboarding alloc] initWithItemsCount:arrayItems.count];
    viewOnboarding.dataSource = self;
    viewOnboarding.delegate = self;
    viewOnboarding.translatesAutoresizingMaskIntoConstraints = NO;
    [viewCarousel addSubview:viewOnboarding];
    viewOnboarding.layer.borderWidth = 0;
    viewOnboarding.layer.cornerRadius = cornerRadius;
    viewOnboarding.clipsToBounds = YES; //limit content even with shadow
    CGFloat boxShadow = [dictCarousel[@"boxShadow"] floatValue];
    if (boxShadow == 0) //no shadow
    {
        //clipsToBounds and masksToBound not co-work well.
        //when masksToBound=NO it doesn't show shadow,
        //however when masksToBound=YES the subviews go out of bound.
        viewCarousel.clipsToBounds = YES;
    }
    else
    {
        viewCarousel.layer.shadowOffset = CGSizeMake(boxShadow, boxShadow);
        viewCarousel.layer.shadowOpacity = 0.5f;
        viewCarousel.layer.shadowRadius = cornerRadius;
    }
    //use constraints to add the paper onboarding view
    NSLayoutConstraint *leadingInner = [NSLayoutConstraint
                                        constraintWithItem:viewOnboarding
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:viewCarousel
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.0f
                                        constant:0];
    [viewCarousel addConstraint:leadingInner];
    NSLayoutConstraint *trailingInner =[NSLayoutConstraint
                                        constraintWithItem:viewOnboarding
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:viewCarousel
                                        attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0f
                                        constant:0];
    [viewCarousel addConstraint:trailingInner];
    NSLayoutConstraint *topInner =[NSLayoutConstraint
                                   constraintWithItem:viewOnboarding
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:viewCarousel
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:0];
    [viewCarousel addConstraint:topInner];
    NSLayoutConstraint *bottomInner =[NSLayoutConstraint
                                      constraintWithItem:viewOnboarding
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:viewCarousel
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:0];
    [viewCarousel addConstraint:bottomInner];
    self.constraintBottom = bottomInner;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:viewCarousel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:viewContent
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:[dictCarousel[@"margin.left"] floatValue]];
    [viewContent addConstraint:leading];
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                   constraintWithItem:viewCarousel
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:viewContent
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:-[dictCarousel[@"margin.right"] floatValue]];
    [viewContent addConstraint:trailing];
    NSLayoutConstraint *top =[NSLayoutConstraint
                              constraintWithItem:viewCarousel
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:viewContent
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:[dictCarousel[@"margin.top"] floatValue]];
    [viewContent addConstraint:top];
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:viewCarousel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:viewContent
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:-[dictCarousel[@"margin.bottom"] floatValue]];
    [viewContent addConstraint:bottom];
    //first item doesn't trigger onboardingWillTransitonToIndex or onboardingDidTransitonToIndex.
    //so send feed result when carousel display.
    //next when swiping forward or backward, the delegates are triggered to send feed result.
    [self sendFeedResultForIndex:0];
    //layout button in a delay to get parent frame ready
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutButtonForIndex:0];
    });
}

#pragma mark - delegate and datasource

- (NSInteger)onboardingItemsCount SWIFT_WARN_UNUSED_RESULT
{
    return ((NSArray *)self.dictCarousel[@"items"]).count;
}

- (OnboardingItemInfo * _Nonnull)onboardingItemAtIndex:(NSInteger)index SWIFT_WARN_UNUSED_RESULT
{
    OnboardingItemInfo *item = [OnboardingItemInfo new];
    NSDictionary *tipItem = ((NSArray *)self.dictCarousel[@"items"])[index];
    item.shImage = tipItem[@"image"];
    item.shImageSource = tipItem[@"imageSource"];
    item.shTitle = tipItem[@"titleText"];
    item.shDesc = tipItem[@"contentText"];
    item.shIcon = tipItem[@"icon"];
    item.shIconSource = tipItem[@"iconSource"];
    item.shColor = [SHCarouselLayout colorFromHexString:tipItem[@"backgroundColor"]];
    item.shTitleColor = [SHCarouselLayout colorFromHexString:tipItem[@"titleColor"]];
    item.shDescriptionColor = [SHCarouselLayout colorFromHexString:tipItem[@"contentColor"]];
    item.shTitleFont = tipItem[@"titleFont"];
    item.shDescriptionFont = tipItem[@"contentFont"];
    return item;
}

- (void)onboardingWillTransitonToIndex:(NSInteger)index
{
    [self sendFeedResultForIndex:index];
}

- (void)onboardingDidTransitonToIndex:(NSInteger)index
{
    [self layoutButtonForIndex:index];
}

- (void)onboardingConfigurationItem:(OnboardingContentViewItem * _Nonnull)item index:(NSInteger)index
{
}

#pragma mark - private functions

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (![hexString isKindOfClass:[NSString class]])
    {
        return nil;
    }
    if (hexString.length != 7 && hexString.length != 9)
    {
        return nil;
    }
    if (![hexString hasPrefix:@"#"])
    {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    unsigned rgbValue = 0;
    [scanner scanHexInt:&rgbValue];
    CGFloat red, green, blue, alpha;
    red = ((rgbValue & 0xFF0000) >> 16)/255.0;
    green = ((rgbValue & 0xFF00) >> 8)/255.0;
    blue = (rgbValue & 0xFF)/255.0;
    if (hexString.length == 7)
    {
        alpha = 1.0;
    }
    else
    {
        alpha = ((rgbValue & 0xFF000000) >> 24)/255.0;
    }
    if (red >= 0 && red <= 1 && green >= 0 && green <= 1 && blue >= 0 && blue <= 1 && alpha >= 0 && alpha <= 1)
    {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    else
    {
        return nil;
    }
}

- (void)sendFeedResultForIndex:(NSInteger)index
{
    NSDictionary *tipItem = ((NSArray *)self.dictCarousel[@"items"])[index];
    NSDictionary *dict = @{@"feed_id": self.dictCarousel[@"feed_id"],
                           @"result": @(1),
                           @"step_id": tipItem[@"suid"],
                           @"delete": @(NO),
                           @"complete": @(NO)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SH_PointziBridge_FeedResult_Notification"
                                                        object:self
                                                      userInfo:dict];
}

- (void)layoutButtonForIndex:(NSInteger)index
{
    UIButton *buttonTarget = self.dictCarousel[@"button_obj"];
    if (buttonTarget == nil //remove button
        && self.button != nil)
    {
        [self.button removeFromSuperview];
        self.button = nil;
        self.constraintBottom.constant = 0;
    }
    else if (buttonTarget != nil)
    {
        if (self.button != nil)
        {
            //tag is index, it's same so nothing to do
            if (buttonTarget.tag == self.button.tag)
            {
                return;
            }
            else //different one, remove current
            {
                [self.button removeFromSuperview];
            }
        }
        //add new bottom button
        self.button = buttonTarget;
        CGFloat width = [self.dictCarousel[@"button_width"] floatValue];
        CGFloat height = [self.dictCarousel[@"button_height"] floatValue];
        CGFloat marginTop = [self.dictCarousel[@"button_margin_top"] floatValue];
        CGFloat marginBottom = [self.dictCarousel[@"button_margin_bottom"] floatValue];
        CGFloat marginLeft = [self.dictCarousel[@"button_margin_left"] floatValue];
        CGFloat marginRight = [self.dictCarousel[@"button_margin_right"] floatValue];
        CGSize sizeContain = self.viewCarouselContainer.frame.size;
        self.constraintBottom.constant = marginTop + height + marginBottom;
        if (width > 0 && width <= 1)
        {
            width = sizeContain.width * width;
        }
        else if (width == 0)
        {
            width = sizeContain.width;
        }
        [self.viewCarouselContainer addSubview:buttonTarget];
        if (marginLeft == 0
            && marginRight == 0) //put in center
        {
            buttonTarget.frame = CGRectMake((sizeContain.width - width) / 2,
                                            sizeContain.height - marginBottom - height,
                                            width,
                                            height);
        }
        else if (marginLeft != 0) //use left first
        {
            buttonTarget.frame = CGRectMake(marginLeft,
                                            sizeContain.height - marginBottom - height,
                                            width,
                                            height);
        }
        else if (marginRight != 0) //use right if exist
        {
            buttonTarget.frame = CGRectMake(sizeContain.width - marginRight - width,
                                            sizeContain.height - marginBottom - height,
                                            width,
                                            height);
        }
    }
}

@end
