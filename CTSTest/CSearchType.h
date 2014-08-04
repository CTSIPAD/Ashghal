//
//  CSearchType.h
//  CTSTest
//
//  Created by DNA on 1/26/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSearchType : NSObject
@property(nonatomic,assign)NSInteger typeId;
@property(nonatomic,strong)NSString* label;
@property(nonatomic,strong)NSString* icon;
-(id) initWithId:(NSInteger)typeId label:(NSString*)label icon:(NSString*)icon;
@end
