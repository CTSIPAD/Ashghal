//
//  ActionTaskController.h
//  cfsPad
//
//  Created by marc balas on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDestination;
@class CRouteLabel;

@protocol ActionTaskDelegate
- (void)actionSelectedDirection:(CRouteLabel*)route;
- (void)actionSelectedDestination:(CDestination*)destination;
@end

@interface ActionTaskController : UITableViewController<UITextViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
	NSMutableArray *actions;
    NSMutableArray *searchData;
	BOOL displayingLabel;
	UISearchBar * searchBar;
    UISearchDisplayController *searchDisplayController;
	UIActionSheet* sheet;
}
@property (nonatomic, assign)CGRect rectFrame;
@property (nonatomic, assign)BOOL isDirection;
@property (nonatomic, retain) NSMutableArray *actions;
@property (nonatomic, assign) id<ActionTaskDelegate> delegate;
@property (nonatomic, readwrite) BOOL displayingLabel;

@property (nonatomic, retain)UIActionSheet* sheet;


@end
