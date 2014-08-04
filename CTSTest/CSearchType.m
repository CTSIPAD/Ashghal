//
//  CSearchType.m
//  CTSTest
//
//  Created by DNA on 1/26/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "CSearchType.h"

@implementation CSearchType
-(id) initWithId:(NSInteger)typeId label:(NSString*)label icon:(NSString*)icon{
    
    if ((self = [super init])) {
        self.typeId=typeId;
        self.label=label;
        self.icon=icon;
	}
    return self;
	
}
@end
