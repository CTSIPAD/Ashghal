//
//  CAction.h
//  CTSTest
//
//  Created by DNA on 1/17/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAction : NSObject
{

NSString* label;
NSString* icon;
NSString* action;

}
@property (nonatomic, retain) NSString* label;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* action;


-(id)initWithLabel:(NSString*)label  icon:(NSString*)icon  action:(NSString*)action;
@end
