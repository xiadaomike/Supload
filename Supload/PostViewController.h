//
//  PostViewController.h
//  Supload
//
//  Created by Zhang on 9/2/14.
//  Copyright (c) 2014 supload. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RennSDK/RennSDK.h"
#import "WeiboSDK.h"
@interface PostViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, RennHttpRequestDelegate, WBHttpRequestDelegate>

@end
