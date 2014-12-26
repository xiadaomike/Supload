//
//  PostViewController.m
//  Supload
//
//  Created by Zhang on 9/2/14.
//  Copyright (c) 2014 supload. All rights reserved.
//

#import "PostViewController.h"
#import "SuploadAppDelegate.h"



@interface PostViewController ()
@property (strong, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSMutableArray *imageList;
@property (weak, nonatomic) IBOutlet UIImageView *backGround;
@property  (strong, nonatomic) NSMutableArray *FBphotIDlist;
@property BOOL FBChosen;
@property BOOL WXChosen;
@property BOOL RenChosen;
@property BOOL WBLoggedIn;
@property BOOL WBChosen;

@end


@implementation PostViewController

-(void) viewDidLoad {
    
    [self updateRenren];
    
    //Setup fields.
    self.FBChosen = true;
    self.WXChosen = true;
    self.RenChosen = true;
    self.WBChosen = true;
    self.WBLoggedIn = false;
    int ROUND_BUTTON_WIDTH_HEIGHT = self.view.frame.size.width/8;
    int OFF_SET = self.view.frame.size.width/16;
    int x = self.view.frame.size.width/4;
    int y = self.view.frame.size.height*3/4;
    int height = self.view.frame.size.height;
    int width = self.view.frame.size.width;
    
    
    //Set up backGround
    [self.backGround setImage:[UIImage imageNamed:@"background.png"]];
    self.backGround.userInteractionEnabled = true;
    
    //Set up Textview;
    self.TextView = [[UITextView alloc] initWithFrame:CGRectMake(width/16, height/5, width*7/8, height/5)];
    self.TextView.layer.cornerRadius = 10.0;
    self.TextView.clipsToBounds = YES;
    self.TextView.alpha = 0.7;
    [self.view addSubview:self.TextView];
    
    
    
    //Set up buttons.
    UIButton *fb = [UIButton buttonWithType:UIButtonTypeCustom];
    [fb setRestorationIdentifier:@"fb"];
    [fb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [fb setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [fb addTarget:self action:@selector(chooseFBButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    fb.frame = CGRectMake(OFF_SET, y, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    fb.clipsToBounds = YES;
    fb.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    [self.view addSubview:fb];
    
    UIButton *wb = [UIButton buttonWithType:UIButtonTypeCustom];
    [wb setRestorationIdentifier:@"wb"];
    [wb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [wb setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    [wb addTarget:self action:@selector(chooseWBButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    wb.frame = CGRectMake(3 * x + OFF_SET, y, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    wb.clipsToBounds = YES;
    wb.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    [self.view addSubview:wb];
    
    
    UIButton *ren = [UIButton buttonWithType:UIButtonTypeCustom];
    [ren setRestorationIdentifier:@"ren"];
    [ren addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [ren setImage:[UIImage imageNamed:@"renren.png"] forState:UIControlStateNormal];
    [ren addTarget:self action:@selector(chooseRenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ren.frame = CGRectMake(x+OFF_SET/2, y-OFF_SET/2, ROUND_BUTTON_WIDTH_HEIGHT*1.5, ROUND_BUTTON_WIDTH_HEIGHT*1.5);
    ren.clipsToBounds = YES;
    ren.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    [self.view addSubview:ren];

    
    UIButton *wx = [UIButton buttonWithType:UIButtonTypeCustom];
    [wx setRestorationIdentifier:@"wx"];
    [wx addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [wx setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(chooseWXButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    wx.frame = CGRectMake( 2 * x + OFF_SET, y, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    wx.clipsToBounds = YES;
    wx.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    [self.view addSubview:wx];
    

    // Setup label
    NSString *s = [NSString stringWithFormat:@"%lu images chosen.", (unsigned long)[self.imageList count]];
    self.label.text = s;
}


- (IBAction)tapBack:(UITapGestureRecognizer *)sender {
    [self.TextView resignFirstResponder];
}

-(void)pan:(UIPanGestureRecognizer *)recognizer {
    int y = self.view.frame.size.height*3/4;
    int OFF_SET = self.view.frame.size.width/16;
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateBegan) {
        
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.view];
        
        CGRect newButtonFrame = draggedButton.frame;
        newButtonFrame.origin.y = MAX(newButtonFrame.origin.y+translation.y, self.view.frame.size.height/2);
        draggedButton.frame = newButtonFrame;
        [recognizer setTranslation:CGPointZero inView:self.view];

    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        UIView *draggedButton = recognizer.view;
        if (draggedButton.frame.origin.y == self.view.frame.size.height/2) {
            if ([draggedButton.restorationIdentifier isEqualToString:@"wb"]) {
                [self logInOutWeibo];
            }
            if ([draggedButton.restorationIdentifier isEqualToString:@"ren"]) {
                [self renLogin];
            }
            if ([draggedButton.restorationIdentifier isEqualToString:@"fb"]) {
                [self fbLogin];
            }
            
        }
        if ([recognizer.view.restorationIdentifier isEqualToString:@"ren"]) {
            y = y-OFF_SET/2;
        }
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect newButtonFrame = draggedButton.frame;
                             newButtonFrame.origin.y = y;
                             draggedButton.frame = newButtonFrame;
                         }
                         completion:^(BOOL fin) {}];

    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.imageList addObject:img];
    NSLog(@"%lu photos in imageList", (unsigned long)[self.imageList count]);
    NSString *s = [NSString stringWithFormat:@"%lu images chosen.", (unsigned long)[self.imageList count]];
    self.label.text = s;
}


#pragma mark properties

-(NSMutableArray *)FBphotIDlist{
    if (!_FBphotIDlist) {
        _FBphotIDlist= [[NSMutableArray alloc] init];
    }
    return _FBphotIDlist;
}

-(NSMutableArray *)imageList{
    if (!_imageList) {
        _imageList=[[NSMutableArray alloc] init];
    }
    return _imageList;
}



#pragma mark button-interactions

- (IBAction)chooseFBButtonPressed:(UIButton *)sender {
    if (self.FBChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"facebook-2.png"] forState:UIControlStateNormal];
        self.FBChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        self.FBChosen = true;
    }
    
}
- (IBAction)chooseRenButtonPressed:(UIButton *)sender {
    if (self.RenChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"renren-2.png"] forState:UIControlStateNormal];
        self.RenChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"renren.png"] forState:UIControlStateNormal];
        self.RenChosen = true;
    }

}

- (IBAction)chooseWXButtonPressed:(UIButton *)sender {
    if (self.WXChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"wechat-2.png"] forState:UIControlStateNormal];
        self.WXChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
        self.WXChosen = true;
    }

}

- (IBAction)chooseWBButtonPressed:(UIButton *)sender {
    if (self.WBChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"weibo-2.png"] forState:UIControlStateNormal];
        self.WBChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
        self.WBChosen = true;
    }
}





- (IBAction)choosePhotoButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)PostButtonPressed:(UIButton *)sender {
    [self publishStory];
    [[self TextView] resignFirstResponder];
    [self.imageList removeAllObjects];
    NSString *s = [NSString stringWithFormat:@"%lu images chosen.", (unsigned long)[self.imageList count]];
    self.label.text = s;


}



-(void)publishStory{

    if ([self.imageList count]==0) {
        if (self.FBChosen) [self updateFBMessageOnlyStatus];
        if (self.WXChosen) [self updateWXStatusOnly];
        if (self.RenChosen) [self updateRennMessageOnlyStatus];
        if (self.WBChosen) {
            [self publishWeiboText];
        }
        
        
    }else {
        if (self.FBChosen) {
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            [self addUploadPhotoRequestsToFBConnection:connection];
            [connection start];
        }
        if (self.WXChosen) {
            [self updateWXWithPhotos];
        }
        if (self.RenChosen) {
            [self updatePhotoToRenn];
        }
        
        if (self.WBChosen) {
            [self publishWeiboPic];
        }
        
 
    }}





#pragma mark FB

-(void) fbLogin {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:true completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        }];
    }
}

-(void) addUploadPhotoRequestsToFBConnection: (FBRequestConnection *)connection{
    for (UIImage *img in self.imageList) {
        FBRequest *request=[FBRequest requestForUploadPhoto:img];
        [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"sucessfully request update photo");
                [self.FBphotIDlist addObject:[result objectForKey:@"id"]];
                NSLog(@"%lu photoids in the listh", (unsigned long)[self.FBphotIDlist count]);
                [self addFBLinkMessageToPhoto];
            }else{
                NSLog(@"failed to update photo, error %@",error.description);
            }
            
        }];}

    
}


-(void) addFBLinkMessageToPhoto{
    NSString *message=self.TextView.text;
    NSLog(@"I reached here, %lu photoids in list",(unsigned long)[self.FBphotIDlist count]);
    for (NSString *photoid in self.FBphotIDlist) {
        NSString *graphPath = [NSString stringWithFormat:@"/%@",photoid];
        NSDictionary <FBGraphObject> *params =[FBGraphObject graphObject];
        [params setObject:message forKey:@"name"];

        [FBRequestConnection startForPostWithGraphPath:graphPath graphObject:params completionHandler: ^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"sucessfully link message to photo,%lu ids left",(unsigned long)[self.FBphotIDlist count]);
                

            }else{
                NSLog(@"failed to link message to photo, error %@",error.description);
            }

            
        }];
    }
    [self.FBphotIDlist removeAllObjects];
}


-(void)updateFBMessageOnlyStatus{
    NSString *message=self.TextView.text;
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (!error) {
                                        // Status update posted successfully to Facebook
                                        NSLog(@"update message only status result: %@", result);
                                    } else {
                                        // An error occurred, we need to handle the error
                                        // See: https://developers.facebook.com/docs/ios/errors
                                        NSLog(@"failed to update message-only status %@", error.description);
                                    }
                                }];}

#pragma mark WX

-(void)updateWXStatusOnly {
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Wechat app is not installed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = self.TextView.text;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

-(void)updateWXWithPhotos {
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Wechat app is not installed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"StatusUpdate";
    message.description = self.TextView.text;
    [message setThumbImage:[UIImage imageNamed:@"pikachu.png"]];

    WXImageObject *ext = [WXImageObject object];
    NSData *data = UIImageJPEGRepresentation(self.imageList[0], 0.8);
    ext.imageData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark Renren


-(void)request:(RennHttpRequest *)request responseWithData:(NSData *)data {
    
}

-(void)request:(RennHttpRequest *)request failWithError:(NSError *)error {
    
}

- (void)updateRenren {
    [RennClient initWithAppId:@"271797"
                       apiKey:@"8cfebb1a709542ac8dd6fe5e6e210185"
                    secretKey:@"66c6723d6e4c4bb99dd729d36534d87f"];
    [RennClient setScope:@"publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed read_user_album"];
    
}

- (IBAction)renLogin {
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
}

- (void)rennLogoutSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Logout Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


-(void) updateRennMessageOnlyStatus {
    PutStatusParam *param = [[PutStatusParam alloc] init];
    param.content = self.TextView.text;
    [RennClient sendAsynRequest:param delegate:self];
}

-(void) updatePhotoToRenn {
    ListAlbumParam *param = [[ListAlbumParam alloc] init];
    param.ownerId = [RennClient uid];
    param.pageNumber = 1;
    param.pageSize = 10;
    [RennClient sendAsynRequest:param delegate:self];
}

- (void) uploadRennPhotoWithAlbum: (NSString *)albumID  {
    for (UIImage *image in self.imageList) {
        UploadPhotoParam *param = [[UploadPhotoParam alloc] init];
        param.albumId = albumID;
        param.description = self.TextView.text;
        param.file = UIImagePNGRepresentation (image);
        [RennClient sendAsynRequest:param delegate:self];
    }

}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{

    if ([service.type isEqualToString:@"ListAlbum"]) {
        [self uploadRennPhotoWithAlbum:[NSString stringWithFormat:@"%@", [[response firstObject] objectForKey:@"id"]]];
        NSLog(@"%@", [[response firstObject] objectForKey:@"id"]);
    } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Publish Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    }

}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Publish failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"renn service failed, %@", error);
}


-(void)requestPublishPermissions{

}

#pragma mark Weibo

-(void)logInOutWeibo {
    if (self.WBLoggedIn) {
        SuploadAppDelegate *myDelegate =(SuploadAppDelegate*)[[UIApplication sharedApplication] delegate];
        [WeiboSDK logOutWithToken:myDelegate.weibotoken delegate:self withTag:@"logout"];
        self.WBLoggedIn = false;
    } else {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = WeiboRedirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"PostViewController",};
        [WeiboSDK sendRequest:request];
        self.WBLoggedIn = true;
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{

    if ([[request tag] isEqualToString:@"logout"] ) {
        NSString *title = nil;
        UIAlertView *alert = nil;
        title = @"成功登出微博账号";
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        [alert show];

    } else if ([[request tag] isEqualToString:@"Text"]) {
        NSString *title = nil;
        UIAlertView *alert = nil;
        title = @"成功发布消息";
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        [alert show];
    }

}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    if ([[request tag] isEqualToString:@"Text"]) {
        NSString *title = nil;
        UIAlertView *alert = nil;
        title = @"发布消息失败";
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:error.description
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        [alert show];
    }

}

-(void)publishWeiboText {
    SuploadAppDelegate *myDelegate =(SuploadAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:myDelegate.weibotoken, @"access_token", self.TextView.text, @"status", nil];
    NSLog(@"Publishing weiboText, %@, %@", [d valueForKey:@"status"], myDelegate.weibotoken);


    [WBHttpRequest requestWithAccessToken:myDelegate.weibotoken url:@"https://api.weibo.com/2/statuses/update.json" httpMethod:@"POST" params:d delegate:self withTag:@"Text"];
}

-(void)publishWeiboPic {
    SuploadAppDelegate *myDelegate =(SuploadAppDelegate*)[[UIApplication sharedApplication] delegate];
    for (UIImage *image in self.imageList) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:myDelegate.weibotoken, @"access_token", data, @"pic", self.TextView.text, @"status", nil];
        NSLog(@"Publishing weiboPhotos, %@, %@", [d valueForKey:@"status"], myDelegate.weibotoken);
        
        
        [WBHttpRequest requestWithAccessToken:myDelegate.weibotoken url:@"https://upload.api.weibo.com/2/statuses/upload.json" httpMethod:@"POST" params:d delegate:self withTag:@"Text"];
    }
}

@end
