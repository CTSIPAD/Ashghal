//
//  ManageSignatureViewController.h
//  CTSIpad
//
//  Created by DNA on 2/5/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageSignatureViewDelegate <NSObject>

@required // Delegate protocols

- (void)tappedSaveSignatureWithWidth:(NSString*)width withHeight:(NSString*)height withRed:(NSString*)red withGreen:(NSString*)green withBlue:(NSString*)blue;

@end
@interface ManageSignatureViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, unsafe_unretained, readwrite) id <ManageSignatureViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
@end
