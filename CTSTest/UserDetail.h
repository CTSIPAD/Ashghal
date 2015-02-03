//
//  UserDetail.h
//  CTSProduct
//
//  Created by DNA on 7/21/14.
//  Copyright (c) 2014 EVER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *FirstName;
@property (nonatomic, retain) NSString *LastName;

@property (nonatomic, retain) NSString *Token;

-(id)initWithName:(NSString*)title  FirstName:(NSString*)FirstName LastName:(NSString*)LastName  Token:(NSString*)Token;

@end
