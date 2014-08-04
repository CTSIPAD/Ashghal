//
//  ViewController.h
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UISplitViewControllerDelegate,UITextFieldDelegate,NSURLConnectionDataDelegate>
{
    UIButton* btnLogin;
    UITextField *txtPassword;
    UITextField *txtUsername;
    UIAlertView *alertLicense;
    BOOL recordResults;
    NSMutableData *conWebData;
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;

@end
