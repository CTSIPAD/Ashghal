//
//  AnnotationsTableViewController.h
//  CTSTest
//
//  Created by DNA on 1/21/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAction.h"
#import "ReaderDocument.h"
@protocol AnnotationsTableDelegate <NSObject>

@required
- (void) performaAnnotation:(int)annotation;
-(void)PopUpCommentDialog:(UITableViewController*)viewcontroller Action:(CAction *)action document:(ReaderDocument*)document1;
@end

@interface AnnotationsTableViewController : UITableViewController
@property (nonatomic, unsafe_unretained, readwrite) id <AnnotationsTableDelegate> delegate;
@property(nonatomic,strong)NSMutableArray* properties;
@end
