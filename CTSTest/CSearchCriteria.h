//
//  CSearchCriteria.h
//  CTSTest
//
//  Created by DNA on 1/21/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSearchCriteria : NSObject

@property(nonatomic,strong)NSString* id;
@property(nonatomic,strong)NSString* label;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSMutableDictionary* options;
-(id) initWithId:(NSString*)criteriaId label:(NSString*)label type:(NSString*)type options:(NSMutableDictionary*)options;
@end
