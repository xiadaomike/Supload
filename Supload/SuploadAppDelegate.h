//
//  SuploadAppDelegate.h
//  Supload
//
//  Created by Zhang on 9/2/14.
//  Copyright (c) 2014 supload. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeiboSDK.h"

@interface SuploadAppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *weibotoken;

@end
