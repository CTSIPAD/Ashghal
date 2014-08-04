//
//  CFolder.h
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFolder : NSObject

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSMutableArray *attachments;
-(id) initWithName:(NSString*)name;
@end
