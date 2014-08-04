//
//  CMenu.h
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMenu : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, assign) NSInteger menuId;
@property (nonatomic, retain) NSMutableArray *correspondenceList;

-(id) initWithName:(NSString*)name Id:(NSInteger)menuId Icon:(NSString*)icon;
@end
