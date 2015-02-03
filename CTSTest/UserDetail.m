//
//  UserDetail.m
//  CTSProduct
//
//  Created by DNA on 7/21/14.
//  Copyright (c) 2014 EVER. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail
-(id)initWithName:(NSString*)title  FirstName:(NSString*)FirstName LastName:(NSString*)LastName  Token:(NSString*)Token{
    self = [super init];
    if (self) {
        self.title=title;
        self.FirstName=FirstName;
        self.LastName=LastName;
        self.Token=Token;
    }
    return self;

}

@end
