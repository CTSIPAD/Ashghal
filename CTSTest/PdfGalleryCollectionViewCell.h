//
//  PdfGalleryCollectionViewCell.h
//  iBoard
//
//  Created by DNA on 10/24/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCorrespondence;
@interface PdfGalleryCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>



@property (nonatomic, strong) NSString *imageThumbnailBase64;

@property (nonatomic, strong) UIImageView *imageViewLock;
@property (nonatomic, strong) UIImageView *imageViewRight1;
@property (nonatomic, strong) UIImageView *imageViewRight2;
@property (nonatomic, strong) NSString *Sender;
@property (nonatomic, strong) NSString *Subject;
@property (nonatomic, strong) NSString *Number;
@property (nonatomic, strong) NSString *Date;

@property (nonatomic, retain) NSString *Priority;
@property (nonatomic, assign) BOOL New;
@property (nonatomic, assign) BOOL Locked;
@property (nonatomic, assign) BOOL showLocked;
@property (nonatomic, assign) BOOL CanOpen;
@property (nonatomic, retain) NSString *LockedBy;
@property (nonatomic,strong)NSString* correspondenceId;
@property (nonatomic,strong)CCorrespondence* correspondence;

-(void)updateCell;
-(void)performLockAction;

@end
