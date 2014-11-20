//
//  UserDetail.m
//  CTSProduct
//
//  Created by DNA on 7/21/14.
//  Copyright (c) 2014 EVER. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail
-(id)initWithName:(NSString*)title  detail:(NSString*)detail Token:(NSString*)Token{
    self = [super init];
    if (self) {
        self.title=title;
        self.detail=detail;
        self.Token=Token;
    }
    return self;

}

@end
