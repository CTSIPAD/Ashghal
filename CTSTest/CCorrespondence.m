//
//  CCorrespondence.m
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CCorrespondence.h"
#import "CParser.h"
#import "CFPendingAction.h"
#import "CUser.h"

@implementation CCorrespondence

-(id) initWithId:(NSString*)correspondenceId Priority:(NSString*)priority New:(BOOL)isNew Locked:(BOOL)isLocked lockedByUser:(NSString*)lockedBy canOpenCorrespondence:(BOOL)canOpen{
    if ((self = [super init])) {
        self.Id=correspondenceId;
//        self.Sender=sender;
//        self.Subject=subject;
//        self.Number=number;
//        self.Date=date;
        self.Priority=priority;
        self.New=isNew;
        self.Locked=isLocked;
        self.LockedBy=lockedBy;
        self.CanOpen=canOpen;
    }
    return self;
}

-(id) initWithId:(NSString*)correspondenceId Priority:(NSString*)priority New:(BOOL)isNew Locked:(BOOL)isLocked lockedByUser:(NSString*)lockedBy SHOWLOCK:(BOOL)showlock canOpenCorrespondence:(BOOL)canOpen{
    if ((self = [super init])) {
        self.Id=correspondenceId;
        //        self.Sender=sender;
        //        self.Subject=subject;
        //        self.Number=number;
        //        self.Date=date;
        self.Priority=priority;
        self.New=isNew;
        self.Locked=isLocked;
        self.LockedBy=lockedBy;
        self.CanOpen=canOpen;
        self.ShowLocked = showlock;
    }
    return self;
}


-(BOOL)performCorrespondenceAction:(NSString*)action{
    
    BOOL isPerformed=NO;
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
//    NSString* url=[NSString stringWithFormat:@"action=%@&token=%@&correspondenceId=%@",action,appDelegate.user.token,self.Id];
    NSString* url=[NSString stringWithFormat:@"action=%@&token=%@&transferId=%@",action,appDelegate.user.token,self.TransferId];

    NSString* lockUrl = [NSString stringWithFormat:@"http://%@?%@",serverUrl,url];
    NSURL *xmlUrl = [NSURL URLWithString:lockUrl];
    NSData *lockXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
    
    NSString *validationResult=[CParser ValidateWithData:lockXmlData];
    if(![validationResult isEqualToString:@"OK"]){
        if([validationResult isEqualToString:@"Cannot access to the server"])
        {isPerformed=YES;
            
            CFPendingAction*pa = [[CFPendingAction alloc] initWithActionUrl:url];
            [appDelegate.user addPendingAction:pa];
        }
    }
    else isPerformed=YES;
    
    return isPerformed;
}


@end
