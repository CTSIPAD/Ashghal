//
//  CFUser.m
//  iBoard
//
//  Created by DNA on 11/5/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CUser.h"
#import "CFPendingAction.h"
#import "GDataXMLNode.h"


@implementation CUser

-(id) initWithName:(NSString*)firstName LastName:(NSString*)lastName UserId:(NSString*)userId Token:(NSString *)token Language:(NSString*)language{
    
    if ((self = [super init])) {
        self.lastName = lastName;
		self.firstName = firstName;
        self.userId = userId;
        self.token=token;
        self.language=language;
        self.actions = [[NSMutableArray alloc] init];
	}
    return self;
	
}

-(BOOL)processSingleAction:(CFPendingAction*)pa
{
	

	@try {
        NSString *post =[NSString stringWithFormat:@"%@",pa.actionUrl];
        
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        
    	NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    

        NSString* fullUrl=[NSString stringWithFormat:@"http://%@",serverUrl];
        
        [request setURL:[NSURL URLWithString:fullUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSError *requestError;
        
        NSData *response = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &requestError ];
        
        
        
        if(response == nil )
        {
            if(requestError != nil)
            {
                NSLog(@"error in pending process, retry later");
            }
            
            //not processed so add it to queue
            [self addPendingAction:pa];
            
            
            return NO;
            //save local xml file now?
            
        }
        else {
            NSString * bigString2 = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
            NSLog(@"request: %@",post);
            NSLog(@"url: %@",request);
            NSLog(@"response to post %@",bigString2);
            
            
//            if([pa.type caseInsensitiveCompare:@"ROUTE"] == NSOrderedSame || [pa.type caseInsensitiveCompare:@"SUBMIT"] == NSOrderedSame )
//                [self updateUserAfterAction:pa];
            
        }
        
        
        
        return YES;
        
        
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
}

-(void)addPendingAction:(CFPendingAction*) actionToAdd
{
	//actionToAdd.taskId=[self.currentTask.tid intValue];
	[self.actions addObject:actionToAdd];
	//[self savePendingActions];
	
//	AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	RootViewController* rvc = mainDelegate.rootViewController;
//	[rvc.tableView reloadData];
//    
	
	return;
}


- (NSString *)dataFilePath:(BOOL)forSave {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
							   stringByAppendingPathComponent:[NSString stringWithFormat:@"%@pending.xml",self.userId]];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
	{
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@pending",self.userId] ofType:@"xml"];
    }
	
}
-(BOOL)processPendingActions
{
    //static URL where pending are saved
	
    //loop in actions
	BOOL success =YES;
	
	NSMutableArray* actionToKeep = [[NSMutableArray alloc] init];
    
	
	for( CFPendingAction* pa in self.actions)
	{
		//and send action url request
		//add token value to url
		
		
		if(![self processSingleAction:pa])
		{
			//pending action to keep
			[actionToKeep addObject:pa];
			
		}
        
		
	}
	
	
	//delete all action && pendingfile.xml
	[self.actions removeAllObjects];
	if(actionToKeep.count >0)
	{
		[self.actions setArray:actionToKeep];
		success = NO;
	}
	NSLog(@"%d actions left to process",self.actions.count);
	
	//AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//RootViewController* rvc = mainDelegate.rootViewController;
	
	//[rvc.tableView reloadData];
	
	
	return success;
	
}


//-(void)updateUserAfterAction:(CFPendingAction*)pa
//{
//	
//	
//	//remove task from basket
//	
//	int IndextoRemove=-1;
//	for( CFBasket* b in  self.basketList.baskets)
//	{
//		uint index =0;
//		for( CFTask* task in b.taskList)
//		{
//			
//			if([task.tid intValue] == pa.taskId)
//			{
//				//remove later when not iterating
//				IndextoRemove =index;
//				break;
//			}
//			index++;
//		}
//		
//		if(IndextoRemove >=0)
//		{
//			[b.taskList  removeObjectAtIndex:index];
//			IndextoRemove = -1;
//			//careful with variable currentTask
//			
//			//need to pushView
//			
//			
//			break;
//		}
//	}
//	
//	
//	
//	//reload rootView for consistency (task removed...)
//	cfsPadAppDelegate *mainDelegate = (cfsPadAppDelegate *)[[UIApplication sharedApplication] delegate];
//	RootViewController* rvc = mainDelegate.rootViewController;
//	
//	
//	[rvc.tableView reloadData];
//	//move elsewhere for optimization ? : problem called by processAllPendings
//	
//	
//	//delete PDF in cache and reload
//	NSFileManager *fm = [NSFileManager defaultManager];
//	NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//	NSError *error = nil;
//	BOOL success = NO;
//	
//	NSMutableArray* annotToKeep = [[NSMutableArray alloc] init];
//	
//	
//	
//	
//	
//	for (CFDocument* doc in self.currentTask.docs) {
//		success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@%@", directory,doc.did, doc.title] error:&error];
//		
//		
//		if (!success || error) {
//			// it failed.
//			NSLog(@"it failed to delete!!! %@ %@", error, [error userInfo]);
//		} else {
//			//delete user annots object for this doc
//			
//			for (CFAnnotationView* aview in self.annotList) {
//				if(aview.docId != doc.did)
//					[annotToKeep addObject:aview];
//			}
//			
//			NSLog(@"Deleted... yipee... !!!");
//		}
//	}
//	
//	[self.annotList setArray:annotToKeep];
//	
//	
//}


@end
