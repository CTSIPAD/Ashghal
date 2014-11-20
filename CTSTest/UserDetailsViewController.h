//
//  UserDetailsViewController.h
//  CTSProduct
//
//  Created by DNA on 8/25/14.
//  Copyright (c) 2014 EVER. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserDelegate <NSObject>
-(void)dismissPopUp:(UITableViewController*)viewcontroller;
-(void)refreshDelegate;
@required

@end
@interface UserDetailsViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray* UserDetail;
@property(nonatomic,unsafe_unretained,readwrite) id <UserDelegate> delegate;
@end

