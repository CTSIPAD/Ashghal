//
//  CSearchCriteria.m
//  CTSTest
//
//  Created by DNA on 1/21/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "CSearchCriteria.h"

@implementation CSearchCriteria

-(id) initWithId:(NSString*)criteriaId label:(NSString*)label type:(NSString*)type options:(NSMutableDictionary*)options {
    
    if ((self = [super init])) {
        self.id=criteriaId;
        self.label=label;
        self.type=type;
        self.options=options;
	}
    return self;
	
}

@end
