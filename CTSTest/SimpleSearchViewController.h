//
//  SimpleSearchViewController.h
//  CTSTest
//
//  Created by DNA on 1/20/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleSearchViewController : UIViewController<UITextFieldDelegate>
{
    UILabel *lblTitle;
    UITextField *txtKeyword;
    UIButton *btnSearch;
    UIButton *btnAdvanceSearch;
}
@end
