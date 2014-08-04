//
//  CCorrespondence.h
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCorrespondence : NSObject

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *TransferId;
@property (nonatomic, retain) NSString *Priority;
@property (nonatomic, assign) BOOL New;
@property (nonatomic, assign) BOOL Locked;
@property (nonatomic, assign) BOOL ShowLocked;
@property (nonatomic, retain) NSString *LockedBy;
@property (nonatomic, assign) BOOL CanOpen;
@property (nonatomic, retain) NSMutableDictionary *systemProperties;
@property (nonatomic, retain) NSMutableDictionary *properties;
@property (nonatomic, retain) NSMutableArray *attachmentsList;

@property (nonatomic, retain) NSMutableDictionary *toolbar;
@property (nonatomic, retain) NSMutableArray *actions;

-(id) initWithId:(NSString*)correspondenceId Priority:(NSString*)priority New:(BOOL)isNew Locked:(BOOL)isLocked lockedByUser:(NSString*)lockedBy canOpenCorrespondence:(BOOL)canOpen;

-(id) initWithId:(NSString*)correspondenceId Priority:(NSString*)priority New:(BOOL)isNew Locked:(BOOL)isLocked lockedByUser:(NSString*)lockedBy SHOWLOCK:(BOOL)showlock canOpenCorrespondence:(BOOL)canOpen;

-(BOOL)performCorrespondenceAction:(NSString*)action;
@end
