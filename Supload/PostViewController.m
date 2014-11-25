//
//  PostViewController.m
//  Supload
//
//  Created by Zhang on 9/2/14.
//  Copyright (c) 2014 supload. All rights reserved.
//

#import "PostViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RennSDK/RennSDK.h"

@interface PostViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, RennHttpRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UIButton *wbButton;

@property (strong, nonatomic) NSMutableArray *imageList;
@property  (strong, nonatomic) NSMutableArray *FBphotIDlist;
@property BOOL FBChosen;
@property BOOL WXChosen;
@property BOOL RenChosen;


@end




@implementation PostViewController

-(void) viewDidLoad {
    self.FBChosen = true;
    self.WXChosen = true;
    self.RenChosen = true;
}

- (IBAction)dragButton:(UIPanGestureRecognizer *)sender {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TextView resignFirstResponder];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.imageList addObject:img];
    NSLog(@"%lu photos in imageList", (unsigned long)[self.imageList count]);
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
        [sender setImage:[UIImage imageNamed:@"pikachu"] forState:UIControlStateNormal];
        self.FBChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"fblogo"] forState:UIControlStateNormal];
        self.FBChosen = true;
    }
    
}
- (IBAction)chooseRenButtonPressed:(UIButton *)sender {
    if (self.RenChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"pikachu"] forState:UIControlStateNormal];
        self.RenChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"renlogo"] forState:UIControlStateNormal];
        self.RenChosen = true;
    }

}

- (IBAction)chooseWXButtonPressed:(UIButton *)sender {
    if (self.WXChosen) {
        sender.highlighted = false;
        [sender setImage:[UIImage imageNamed:@"pikachu"] forState:UIControlStateNormal];
        self.WXChosen = false;
    } else {
        [sender setHighlighted:true];
        [sender setImage:[UIImage imageNamed:@"wxlogo"] forState:UIControlStateNormal];
        self.WXChosen = true;
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


}



-(void)publishStory{

    if ([self.imageList count]==0) {
        if (self.FBChosen) [self updateFBMessageOnlyStatus];
        if (self.WXChosen) [self updateWXMessageOnlyStatus];
        if (self.RenChosen) [self updateRennMessageOnlyStatus];
        [self.imageList removeAllObjects];
        
    }else {
        if (self.FBChosen) {
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        [self addUploadPhotoRequestsToFBConnection:connection];
            [connection start];
        }
        if (self.WXChosen) {
            
        }
        if (self.RenChosen) {
            [self updatePhotoToRenn];
        }
 
    }}





#pragma mark FB



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

-(void)updateWXMessageOnlyStatus {
    
}


#pragma mark Renren


-(void)request:(RennHttpRequest *)request responseWithData:(NSData *)data {
    
}

-(void)request:(RennHttpRequest *)request failWithError:(NSError *)error {
    
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





@end
