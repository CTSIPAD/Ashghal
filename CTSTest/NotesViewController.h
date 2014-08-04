//
//  NotesViewController.h
//  iBoard
//
//  Created by DNA on 11/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "NotesTableViewCell.h"
#import "CUser.h"
#import "NoteAlertView.h"
#import <UIKit/UIKit.h>

@interface NotesViewController : UITableViewController<NoteAlertViewDelegate,UIAlertViewDelegate>

@property(nonatomic,assign) NSInteger attachmentId;
@property(nonatomic,assign) NSInteger correspondenceId;
@property(nonatomic,assign) NSInteger menuId;
@property(strong)NotesTableViewCell *cell;
@property(strong)CUser *currentUser;
@property(nonatomic,assign) CGFloat tableHeight;
@property (nonatomic, assign) NSInteger currentPage;
@property(nonatomic,strong) NSString* pageName;
@end
