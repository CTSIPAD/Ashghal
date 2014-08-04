//
//  SignatureViewController.h
//  CTSTest
//
//  Created by DNA on 12/23/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Signature;
@class CUser;

@interface SignatureViewController : UIViewController<UITextFieldDelegate>
{
    Signature *sigView;
    UITextField *txtOldPin;
    UITextField *txtPin;
    UITextField *txtConfirmPin;
}
- (id)initWithFrame:(CGRect)frame;
-(void)show;
-(void)hide;
-(void)save;
@end
