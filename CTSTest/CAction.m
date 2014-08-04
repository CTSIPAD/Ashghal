//
//  CAction.m
//  CTSTest
//
//  Created by DNA on 1/17/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "CAction.h"

@implementation CAction
@synthesize label,action,icon;
-(id)initWithLabel:(NSString*)actionLabel  icon:(NSString*)actionIcon  action:(NSString*)actionName{
     if ((self = [super init])) {
         self.label=actionLabel;
         self.icon=actionIcon;
         self.action=actionName;
         
     }
    return self;
}
@end
