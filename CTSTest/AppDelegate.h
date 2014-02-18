//
//  AppDelegate.h
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CUser;
@class CSearch;
@class MainMenuViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)UISplitViewController *splitViewController;
@property (strong, nonatomic) CUser *user;
@property (strong, nonatomic) CSearch *searchModule;
@property (nonatomic, strong) MainMenuViewController *masterView;
@property (assign, nonatomic) NSInteger selectedInbox;
@property(nonatomic,assign)NSInteger menuSelectedItem;
@property (strong, nonatomic) NSString* userLanguage;
@property (strong, nonatomic) NSString* ipadLanguage;
@property(nonatomic,assign)BOOL isSharepoint;
@property(nonatomic,assign)BOOL isAnnotated;
@property(nonatomic,assign)BOOL isAnnotationSaved;
@end
