//
//  HomeViewController.h
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdfThumbScrollView.h"
#import "ReaderViewController.h"

@class CUser;

@interface HomeViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PdfThumbScrollViewDelegate,UIGestureRecognizerDelegate,UISplitViewControllerDelegate,ReaderViewControllerDelegate>
@property (nonatomic, strong) CUser * user;


@end
