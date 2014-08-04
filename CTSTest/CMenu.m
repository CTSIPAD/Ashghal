//
//  CMenu.m
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CMenu.h"

@implementation CMenu

-(id) initWithName:(NSString*)name Id:(NSInteger)menuId Icon:(NSString*)icon{
    if ((self = [super init])) {
        self.name = name;
		self.icon = icon;
        self.menuId=menuId;
	}
    return self;
}
@end
