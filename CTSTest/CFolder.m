//
//  CFolder.m
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CFolder.h"

@implementation CFolder

-(id) initWithName:(NSString*)name{
    if ((self = [super init])) {
        self.Name = name;
    }
    return self;
}

@end
