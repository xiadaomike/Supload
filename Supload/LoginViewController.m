//
//  LoginViewController.m
//  Supload
//
//  Created by Zhang on 9/2/14.
//  Copyright (c) 2014 supload. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RennSDK/RennSDK.h"
#import "WXApi.h"

@interface LoginViewController () <RennLoginDelegate, WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIView *fbLoginView;
@property (weak, nonatomic) IBOutlet UIButton *RenrenLoginButton;

@end


@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateRenren];
    [self updateFBView];
    // Do any additional setup after loading the view.
}



- (void)updateFBView{
    FBLoginView *loginView=[[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"publish_actions",@"user_photos"]];
    [self.fbLoginView addSubview:loginView];
}

- (void)updateRenren {
    [RennClient initWithAppId:@"271797"
                       apiKey:@"8cfebb1a709542ac8dd6fe5e6e210185"
                    secretKey:@"66c6723d6e4c4bb99dd729d36534d87f"];
    [RennClient setScope:@"publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed read_user_album"];
    [self updateRenrenButton];

}

-(void)updateRenrenButton {
    if ([RennClient isLogin]) {
        [self.RenrenLoginButton setTitle: @"Logout Renren" forState:UIControlStateNormal];
    }
    else {
        [self.RenrenLoginButton setTitle:@"Login Renren" forState:UIControlStateNormal];
    }
}



- (IBAction)renreLoginPressed:(UIButton *)sender {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    } else {
        [RennClient loginWithDelegate:self];
    }
}


- (void)rennLoginSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Login Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [self updateRenrenButton];
}

- (void)rennLogoutSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Logout Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [self updateRenrenButton];
}


@end
