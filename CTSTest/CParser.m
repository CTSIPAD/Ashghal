//
//  CParser.m
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CParser.h"
#import "GDataXMLNode.h"
#import "CUser.h"
#import "CMenu.h"
#import "CCorrespondence.h"
#import "CFolder.h"
#import "CAttachment.h"
#import "CDestination.h"
#import "CRouteLabel.h"
#import "CAction.h"
#import "CAnnotation.h"
#import "CSearchCriteria.h"
#import "CSearch.h"
#import "CSearchType.h"
#import "note.h"
#import "HighlightClass.h"
@implementation CParser{
    AppDelegate *mainDelegate;
    NSString* error;
}

-(void)jess : (NSString *)path{
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.docUrl = [mainDelegate.docUrl stringByReplacingOccurrencesOfString:@"%5C" withString:@"\\"];
    
    for(CMenu* inbox in mainDelegate.user.menu)
    {
        if (inbox.correspondenceList.count>0)
        {
            for(CCorrespondence* correspondence in inbox.correspondenceList)
            {
                if (correspondence.attachmentsList.count>0)
                {
                    for(CAttachment* doc in correspondence.attachmentsList)
                    {
                        if([doc.url isEqualToString:mainDelegate.docUrl]){
                            doc.url = path;
                        }
                    }
                }
                // NSLog(@"task name : %@ id : %@ ",task.name,task.tid);
            }
        }
    }
}

-(void)john:(NSData *)xmlData{
    NSLog(@"I");
    NSError *error;
    NSLog(@"%@",xmlData);
    GDataXMLDocument *doc= [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    
    NSArray *signedfileinfo = [doc nodesForXPath:@"//signedfileinfo" error:nil];
    GDataXMLElement *signedfileinfoXML =  [signedfileinfo objectAtIndex:0];
    NSString* path=[(GDataXMLElement *) [signedfileinfoXML attributeForName:@"path"] stringValue];
    
    [self jess:path];
    
}



+(NSString*)ValidateWithData:(NSData *)xmlData{
    NSLog(@"I");
    NSError *error;
    NSLog(@"%@",xmlData);
    GDataXMLDocument *doc= [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
  
    
    if(xmlData.length==0){return @"Cannot access to the server";}
    else
        if (doc == nil) {
            return @"Technical issue";
           
        }
    
	NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
	GDataXMLElement *resultXML =  [results objectAtIndex:0];
    NSString* status=[(GDataXMLElement *) [resultXML attributeForName:@"status"] stringValue];
    
    if([status isEqualToString:@"Error"]){
        return resultXML.stringValue;
    }
    return @"OK";
}

//signedfileinfo

//+ (CUser *)loadUserWithData:(NSData *)xmlData {
//    
//    NSError *error;
//    
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
//														   options:0 error:&error];
//    
//    if (doc == nil) { return nil; }
//    
//	NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
//	
//	//LOAD first user in XML
//	GDataXMLElement *userXML =  [results objectAtIndex:0];
//    
//    //fill by user data
//    NSString* firstName;
//    NSString* userId;
//    NSString* lastName;
//    NSString * token;
//    NSString *language;
//    NSString *signature;
//    NSString *pincode;
//    NSString *serviceType;
//    NSMutableArray* destinations = [[NSMutableArray alloc] init];
//    NSMutableArray* routesLabel = [[NSMutableArray alloc] init];
//    
//    NSArray *tokens = [userXML elementsForName:@"Token"];
//	if (tokens.count > 0) {
//		GDataXMLElement *tokenEl = (GDataXMLElement *) [tokens objectAtIndex:0];
//		token = tokenEl.stringValue;
//	}
//    
//    NSArray *userIds = [userXML elementsForName:@"UserId"];
//    if  (userIds.count > 0) {
//        GDataXMLElement *userIdEl = (GDataXMLElement *) [userIds objectAtIndex:0];
//        userId = userIdEl.stringValue;
//    }
//    
//    NSArray *firstNames = [userXML elementsForName:@"Firstname"];
//    if (firstNames.count > 0) {
//        GDataXMLElement *firstNameEl = (GDataXMLElement *) [firstNames objectAtIndex:0];
//        firstName = firstNameEl.stringValue;
//    }
//    
//    NSArray *lastNames = [userXML elementsForName:@"Lastname"];
//    if  (lastNames.count > 0) {
//        GDataXMLElement *lastNameEl = (GDataXMLElement *) [lastNames objectAtIndex:0];
//        lastName = lastNameEl.stringValue;
//    }
//    
//    NSArray *languages = [userXML elementsForName:@"Language"];
//    if  (languages.count > 0) {
//        GDataXMLElement *languageEl = (GDataXMLElement *) [languages objectAtIndex:0];
//        language = languageEl.stringValue;
//    }
//    
//    NSArray *signatures = [userXML elementsForName:@"Signature"];
//    if  (signatures.count > 0) {
//        GDataXMLElement *signatureEl = (GDataXMLElement *) [signatures objectAtIndex:0];
//        signature = signatureEl.stringValue;
//    }
//    
//    NSArray *pincodes = [userXML elementsForName:@"Pincode"];
//    if  (pincodes.count > 0) {
//        GDataXMLElement *pincodeEl = (GDataXMLElement *) [pincodes objectAtIndex:0];
//        pincode = pincodeEl.stringValue;
//    }
//    
//    NSArray *services = [userXML elementsForName:@"ServiceType"];
//    if  (services.count > 0) {
//        GDataXMLElement *serviceEl = (GDataXMLElement *) [services objectAtIndex:0];
//        serviceType = serviceEl.stringValue;
//    }
//    
//    
//    NSArray *routes = [doc nodesForXPath:@"//Routes" error:nil];
//	
//	for (GDataXMLElement *route in routes) {
//        
//		
//		NSArray *destinationsList = [route elementsForName:@"Destinations"];
//        
//		NSArray *routeLabelList = [route elementsForName:@"Routelabels"];
//		
//		
//		
//		if (destinationsList.count > 0) {
//            
//            GDataXMLElement *destinationsXml = (GDataXMLElement *) [destinationsList objectAtIndex:0];
//            
//			NSArray *destinationsEl = [destinationsXml elementsForName:@"Destination"];
//			
//			for (GDataXMLElement * destEl in destinationsEl) {
//				
//                
//                
//                NSString* destType = [destEl attributeForName:@"type"].stringValue;
//                NSString* destId = [destEl attributeForName:@"id"].stringValue;
//                NSString* value = destEl.stringValue;
//                
//                //NSLog(@"destination type: %@", destType);
//                
//				CDestination* dest = [[CDestination alloc] initWithName:value Id:destId Type:destType];
//				[destinations addObject:dest];
//				
//			}
//		}
//		
//		if (routeLabelList.count > 0) {
//			
//            GDataXMLElement *labels = (GDataXMLElement *) [routeLabelList objectAtIndex:0];
//            
//			NSArray *labelsEl = [labels elementsForName:@"label"];
//            
//            for (GDataXMLElement * destEl in labelsEl) {
//				
//				
//				//GDataXMLElement *destEl = (GDataXMLElement *) [destinations objectAtIndex:0];
//				
//				
//				NSString* destId = [destEl attributeForName:@"id"].stringValue;
//				NSString* value = destEl.stringValue;
//				
//				//NSLog(@"routeLabel type: %@ %@ id:", value,destId);
//				
//				CRouteLabel* rlabel = [[CRouteLabel alloc] initWithName:value Id:destId];
//				[routesLabel addObject:rlabel];
//				
//			}
//		}
//		CRouteLabel* rlabel = [[CRouteLabel alloc] initWithName:@"NO LABEL" Id:@"NONE"];
//		[routesLabel addObject:rlabel];
//    }
//    
//    NSArray *menus =[doc nodesForXPath:@"//Inbox/InboxItem" error:nil];
//    NSMutableArray *menuItems =  [self loadMenuListWith:menus];
//    
//    CUser *user = [[CUser alloc] initWithName:firstName LastName:lastName UserId:userId Token:token Language:language];
//    [user setServiceType:serviceType];
//	//[user setUserXmlData:xmlData];
//    [user setMenu:menuItems];
//    [user setSignature:signature];
//    [user setPincode:pincode];
//    [user setDestinations:destinations];
//    [user setRouteLabels:routesLabel];
//    return user;
//}


+ (CUser *)loadUserWithData:(NSString *)url {
    
    NSError *error;
    
    // NSLog(@"xml path %@", url);
    NSURL *xmlURL = [NSURL URLWithString:url];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlURL];

    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 error:&error];
    
	NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
	
	//LOAD first user in XML
	GDataXMLElement *userXML =  [results objectAtIndex:0];
    
    //fill by user data
    NSString* firstName;
    NSString* userId;
    NSString* lastName;
    NSString * token;
    NSString *language;
	 NSString *signature;
    NSString *pincode;
    NSString *serviceType;
    NSMutableArray* destinations = [[NSMutableArray alloc] init];
    NSMutableArray* routesLabel = [[NSMutableArray alloc] init];
    
    NSArray *tokens = [userXML elementsForName:@"Token"];
	if (tokens.count > 0) {
		GDataXMLElement *tokenEl = (GDataXMLElement *) [tokens objectAtIndex:0];
		token = tokenEl.stringValue;
	}
    
    NSArray *userIds = [userXML elementsForName:@"UserId"];
    if  (userIds.count > 0) {
        GDataXMLElement *userIdEl = (GDataXMLElement *) [userIds objectAtIndex:0];
        userId = userIdEl.stringValue;
    }
    
    NSArray *firstNames = [userXML elementsForName:@"Firstname"];
    if (firstNames.count > 0) {
        GDataXMLElement *firstNameEl = (GDataXMLElement *) [firstNames objectAtIndex:0];
        firstName = firstNameEl.stringValue;
    }
    
    NSArray *lastNames = [userXML elementsForName:@"Lastname"];
    if  (lastNames.count > 0) {
        GDataXMLElement *lastNameEl = (GDataXMLElement *) [lastNames objectAtIndex:0];
        lastName = lastNameEl.stringValue;
    }
    
    NSArray *languages = [userXML elementsForName:@"Language"];
    if  (languages.count > 0) {
        GDataXMLElement *languageEl = (GDataXMLElement *) [languages objectAtIndex:0];
        language = languageEl.stringValue;
    }
    
    NSArray *signatures = [userXML elementsForName:@"Signature"];
    if  (signatures.count > 0) {
        GDataXMLElement *signatureEl = (GDataXMLElement *) [signatures objectAtIndex:0];
        signature = signatureEl.stringValue;
    }
    
    NSArray *pincodes = [userXML elementsForName:@"Pincode"];
    if  (pincodes.count > 0) {
        GDataXMLElement *pincodeEl = (GDataXMLElement *) [pincodes objectAtIndex:0];
        pincode = pincodeEl.stringValue;
    }
    
    NSArray *services = [userXML elementsForName:@"ServiceType"];
    if  (services.count > 0) {
        GDataXMLElement *serviceEl = (GDataXMLElement *) [services objectAtIndex:0];
        serviceType = serviceEl.stringValue;
    }

    
    NSArray *routes = [doc nodesForXPath:@"//Routes" error:nil];
	
	for (GDataXMLElement *route in routes) {
        
		
		NSArray *destinationsList = [route elementsForName:@"Destinations"];
				
		NSArray *routeLabelList = [route elementsForName:@"Routelabels"];
		
		
		
		if (destinationsList.count > 0) {
            
            GDataXMLElement *destinationsXml = (GDataXMLElement *) [destinationsList objectAtIndex:0];
            
			NSArray *destinationsEl = [destinationsXml elementsForName:@"Destination"];
			
			for (GDataXMLElement * destEl in destinationsEl) {
				
                
                
                NSString* destType = [destEl attributeForName:@"type"].stringValue;
                NSString* destId = [destEl attributeForName:@"id"].stringValue;
                NSString* value = destEl.stringValue;
                
                //NSLog(@"destination type: %@", destType);
                
				CDestination* dest = [[CDestination alloc] initWithName:value Id:destId Type:destType];
				[destinations addObject:dest];
				
			}
		}
		
		if (routeLabelList.count > 0) {
			
            GDataXMLElement *labels = (GDataXMLElement *) [routeLabelList objectAtIndex:0];
            
			NSArray *labelsEl = [labels elementsForName:@"label"];
            
            for (GDataXMLElement * destEl in labelsEl) {
				
				
				//GDataXMLElement *destEl = (GDataXMLElement *) [destinations objectAtIndex:0];
				
				
				NSString* destId = [destEl attributeForName:@"id"].stringValue;
				NSString* value = destEl.stringValue;
				
				//NSLog(@"routeLabel type: %@ %@ id:", value,destId);
				
				CRouteLabel* rlabel = [[CRouteLabel alloc] initWithName:value Id:destId];
				[routesLabel addObject:rlabel];
				
			}
		}
		CRouteLabel* rlabel = [[CRouteLabel alloc] initWithName:@"NO LABEL" Id:@"NONE"];
		[routesLabel addObject:rlabel];
    }
    
    NSArray *menus =[doc nodesForXPath:@"//Inbox/InboxItem" error:nil];
    NSMutableArray *menuItems =  [self loadMenuListWith:menus];
    
    CUser *user = [[CUser alloc] initWithName:firstName LastName:lastName UserId:userId Token:token Language:language];
    [user setServiceType:serviceType];
	//[user setUserXmlData:xmlData];
    [user setMenu:menuItems];
    [user setSignature:signature];
    [user setPincode:pincode];
    [user setDestinations:destinations];
    [user setRouteLabels:routesLabel];
    return user;
}

+ (NSMutableArray *)loadMenuListWith:(NSArray*) menus {
    
	
	NSMutableArray* menuItems = [[NSMutableArray alloc] init];
	
	for (GDataXMLElement *menuItem in menus) {
		
        NSInteger menuId;
        NSString *name;
        NSString *icon;
        
        NSArray *menuIds = [menuItem elementsForName:@"InboxId"];
		GDataXMLElement *menuIdEl = (GDataXMLElement *) [menuIds objectAtIndex:0];
		menuId = [menuIdEl.stringValue integerValue];
		
      
        NSArray *names = [menuItem elementsForName:@"Name"];
		if (names.count > 0) {
			GDataXMLElement *nameEl = (GDataXMLElement *) [names objectAtIndex:0];
			name = nameEl.stringValue;
		}
        
        NSArray *icons = [menuItem elementsForName:@"Icon"];
		if (icons.count > 0) {
			GDataXMLElement *iconEl = (GDataXMLElement *) [icons objectAtIndex:0];
			icon = iconEl.stringValue;
		}
        CMenu* menu = [[CMenu alloc] initWithName:name Id:menuId Icon:icon];
        
        [menuItems addObject:menu];
    }
    return menuItems;
}

+(NSMutableDictionary *)loadItems:(NSArray*) arrayItems{
     NSMutableDictionary* property = [[NSMutableDictionary alloc] init];
    NSArray *items=((GDataXMLElement*)arrayItems[0]).children;
    for(GDataXMLElement *prop in items)
    {
     [property setObject:prop.stringValue forKey:prop.name ];
                   
    }
    return property;
}

+ (NSMutableArray *)loadActionsWith:(NSArray*) toolbarActions {
    
	
	NSMutableArray* actions = [[NSMutableArray alloc] init];
	
	for (GDataXMLElement *actionItem in toolbarActions) {
		
        
        NSString *label;
        NSString *icon;
        NSString *action;
        
       
        NSArray *labels = [actionItem elementsForName:@"Label"];
		if (labels.count > 0) {
			GDataXMLElement *labelEl = (GDataXMLElement *) [labels objectAtIndex:0];
			label = labelEl.stringValue;
		}
        
       
        
        NSArray *icons = [actionItem elementsForName:@"Icon"];
		if (icons.count > 0) {
			GDataXMLElement *iconEl = (GDataXMLElement *) [icons objectAtIndex:0];
			icon = iconEl.stringValue;
		}
        
        NSArray *actionsArray = [actionItem elementsForName:@"Action"];
		if (actionsArray.count > 0) {
			GDataXMLElement *actionEl = (GDataXMLElement *) [actionsArray objectAtIndex:0];
			action = actionEl.stringValue;
		}
        
        
        CAction* menu = [[CAction alloc] initWithLabel:label icon:icon action:action];
        
        [actions addObject:menu];
    }
    return actions;
}


//+(NSMutableDictionary *)loadCorrespondencesWithData:(NSString*)url {
//    
//    // NSData *xmlData = [NSData dataWithContentsOfFile:url];
//    NSLog(@"In loading data");
//    NSError *error;
//    
//    NSURL *xmlURL = [NSURL URLWithString:url];
//    
//    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlURL];
//    
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
//                                                           options:0 error:&error];
//    
//    if (doc == nil) { return nil; }
//    
//    NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
//    
//    GDataXMLElement *correspondencesXML =  [results objectAtIndex:0];
//    
//    NSString* status=[(GDataXMLElement *) [correspondencesXML attributeForName:@"status"] stringValue];
//    
//    if([status isEqualToString:@"Error"]){
//        return nil;
//    }
//    
//    NSArray *inboxes =[correspondencesXML elementsForName:@"Inbox"];
//    NSMutableDictionary* allInboxes = [[NSMutableDictionary alloc] init];
//	
//	for (GDataXMLElement *inbox in inboxes) {
//        
//        NSString *inboxId=[(GDataXMLElement *) [inbox attributeForName:@"id"] stringValue ];
//        
//        NSArray *correspondences =[inbox nodesForXPath:@"Correspondences/Correspondence" error:nil];
//        NSMutableArray* Allcorrespondences = [[NSMutableArray alloc] init];
//        
//        for (GDataXMLElement *correspondence in correspondences) {
//            
//            NSString* transferId;
//            NSString *Id;
//            NSString *Priority;
//            BOOL New;
//            BOOL Locked;
//            BOOL SHOWLOCK;
//            NSMutableDictionary *propertiesList=[[NSMutableDictionary alloc] init];
//            // NSMutableArray* annotations=[[NSMutableArray alloc] init];
//            
//            NSArray *transferIds = [correspondence elementsForName:@"TransferId"];
//            if (transferIds.count > 0) {
//                GDataXMLElement *transferIdEl = (GDataXMLElement *) [transferIds objectAtIndex:0];
//                transferId = transferIdEl.stringValue;
//            }
//            
//            NSArray *correspondenceIds = [correspondence elementsForName:@"CorrespondenceId"];
//            if (correspondenceIds.count > 0) {
//                GDataXMLElement *correspondenceIdEl = (GDataXMLElement *) [correspondenceIds objectAtIndex:0];
//                Id = correspondenceIdEl.stringValue;
//            }
//            
//            
//            NSArray *priorities = [correspondence elementsForName:@"Priority"];
//            if (priorities.count > 0) {
//                GDataXMLElement *priorityEl = (GDataXMLElement *) [priorities objectAtIndex:0];
//                Priority = priorityEl.stringValue;
//            }
//            
//            GDataXMLElement *newEl = (GDataXMLElement *) [[correspondence elementsForName:@"New"]objectAtIndex:0];
//            New = [newEl.stringValue boolValue];
//            
//            GDataXMLElement *lockedEl = (GDataXMLElement *) [[correspondence elementsForName:@"Locked"]objectAtIndex:0];
//            Locked = [lockedEl.stringValue boolValue];
//            
//            
//            
//            GDataXMLElement *showlockedEl = (GDataXMLElement *) [[correspondence elementsForName:@"ShowLock"]objectAtIndex:0];
//            SHOWLOCK = [showlockedEl.stringValue boolValue];
//            
//            
//            
//            NSString *lockBy =[(GDataXMLElement *) [ [correspondence elementsForName:@"LockedBy"] objectAtIndex:0] stringValue];
//            BOOL canOpen =[[(GDataXMLElement *) [ [correspondence elementsForName:@"CanOpen"] objectAtIndex:0] stringValue]boolValue];
//            
//            NSArray *systemProperties =[correspondence nodesForXPath:@"SystemProperties" error:nil];
//            NSMutableDictionary *systemPropertiesList =  [self loadItemsByOrder:systemProperties];
//            
//            NSArray *properties = [correspondence elementsForName:@"Properties"];
//            if (properties.count > 0) {
//                GDataXMLElement *propertiesEl = (GDataXMLElement *) [properties objectAtIndex:0];
//                propertiesList=[self GetPropertiesFrom:propertiesEl];
//            }
//            NSArray *toolbar =[correspondence nodesForXPath:@"Toolbar/ToolbarItems" error:nil];
//            NSMutableDictionary *toolbarItems =  [self loadItems:toolbar];
//            
//            NSArray *toolbarAction =[correspondence nodesForXPath:@"Toolbar/ToolbarActions/ToolbarAction" error:nil];
//            NSMutableArray *toolbarActions =  [self loadActionsWith:toolbarAction];
//            
//            
//            
//            // get folders
//            NSMutableArray* attachments = [[NSMutableArray alloc] init];
//            NSArray *attachmentsXml = [correspondence elementsForName:@"Attachments"];
//            if (attachmentsXml.count > 0) {
//                GDataXMLElement *attachmentsEl = (GDataXMLElement *) [attachmentsXml objectAtIndex:0];
//                attachments=[self loadAttachmentListWith:attachmentsEl];
//            }
//            
//            //jis ccorrespondence
//            CCorrespondence  *newCorrespondence = [[CCorrespondence alloc] initWithId:Id Priority:Priority New:New Locked:Locked lockedByUser:lockBy SHOWLOCK:SHOWLOCK canOpenCorrespondence:canOpen];
//            
//            [newCorrespondence setTransferId:transferId];
//            [newCorrespondence setSystemProperties:systemPropertiesList];
//            [newCorrespondence setProperties:propertiesList];
//            [newCorrespondence setAttachmentsList:attachments];
//            [newCorrespondence setToolbar:toolbarItems];
//            [newCorrespondence setActions:toolbarActions];
//            [Allcorrespondences addObject:newCorrespondence];
//            
//        }
//        [allInboxes setObject:Allcorrespondences forKey:inboxId];
//    }
//    return allInboxes;
//}

+(NSMutableDictionary *)loadCorrespondencesWithData:(NSData*)xmlData {
    // NSData *xmlData = [NSData dataWithContentsOfFile:url];
    NSLog(@"In loading data");
    NSError *error;

    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    
    if (doc == nil) { return nil; }
    
    NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
    
    GDataXMLElement *correspondencesXML =  [results objectAtIndex:0];
    
    NSString* status=[(GDataXMLElement *) [correspondencesXML attributeForName:@"status"] stringValue];
    
    if([status isEqualToString:@"Error"]){
        [self performSelectorOnMainThread:@selector(ShowMessage:) withObject:nil waitUntilDone:YES];

     //   [self ShowMessage:correspondencesXML.stringValue];
        return nil;
    }
    
    NSArray *inboxes =[correspondencesXML elementsForName:@"Inbox"];
    NSMutableDictionary* allInboxes = [[NSMutableDictionary alloc] init];
	
	for (GDataXMLElement *inbox in inboxes) {
        
        NSString *inboxId=[(GDataXMLElement *) [inbox attributeForName:@"id"] stringValue ];
        
        NSArray *correspondences =[inbox nodesForXPath:@"Correspondences/Correspondence" error:nil];
        NSMutableArray* Allcorrespondences = [[NSMutableArray alloc] init];
        
        for (GDataXMLElement *correspondence in correspondences) {
            
            NSString* transferId;
            NSString *Id;
            NSString *Priority;
            BOOL New;
            BOOL Locked;
            BOOL SHOWLOCK;
            NSMutableDictionary *propertiesList=[[NSMutableDictionary alloc] init];
            // NSMutableArray* annotations=[[NSMutableArray alloc] init];
            
            NSArray *transferIds = [correspondence elementsForName:@"TransferId"];
            if (transferIds.count > 0) {
                GDataXMLElement *transferIdEl = (GDataXMLElement *) [transferIds objectAtIndex:0];
                transferId = transferIdEl.stringValue;
            }
            
            NSArray *correspondenceIds = [correspondence elementsForName:@"CorrespondenceId"];
            if (correspondenceIds.count > 0) {
                GDataXMLElement *correspondenceIdEl = (GDataXMLElement *) [correspondenceIds objectAtIndex:0];
                Id = correspondenceIdEl.stringValue;
            }
            
            
            NSArray *priorities = [correspondence elementsForName:@"Priority"];
            if (priorities.count > 0) {
                GDataXMLElement *priorityEl = (GDataXMLElement *) [priorities objectAtIndex:0];
                Priority = priorityEl.stringValue;
            }
            
            GDataXMLElement *newEl = (GDataXMLElement *) [[correspondence elementsForName:@"New"]objectAtIndex:0];
            New = [newEl.stringValue boolValue];
            
            GDataXMLElement *lockedEl = (GDataXMLElement *) [[correspondence elementsForName:@"Locked"]objectAtIndex:0];
            Locked = [lockedEl.stringValue boolValue];
            
            
            
            GDataXMLElement *showlockedEl = (GDataXMLElement *) [[correspondence elementsForName:@"ShowLock"]objectAtIndex:0];
            SHOWLOCK = [showlockedEl.stringValue boolValue];
            
            
            
            NSString *lockBy =[(GDataXMLElement *) [ [correspondence elementsForName:@"LockedBy"] objectAtIndex:0] stringValue];
            BOOL canOpen =[[(GDataXMLElement *) [ [correspondence elementsForName:@"CanOpen"] objectAtIndex:0] stringValue]boolValue];
            
            NSArray *systemProperties =[correspondence nodesForXPath:@"SystemProperties" error:nil];
            NSMutableDictionary *systemPropertiesList =  [self loadItemsByOrder:systemProperties];
            
            NSArray *properties = [correspondence elementsForName:@"Properties"];
            if (properties.count > 0) {
                GDataXMLElement *propertiesEl = (GDataXMLElement *) [properties objectAtIndex:0];
                propertiesList=[self GetPropertiesFrom:propertiesEl];
            }
            NSArray *toolbar =[correspondence nodesForXPath:@"Toolbar/ToolbarItems" error:nil];
            NSMutableDictionary *toolbarItems =  [self loadItems:toolbar];
            
            NSArray *toolbarAction =[correspondence nodesForXPath:@"Toolbar/ToolbarActions/ToolbarAction" error:nil];
            NSMutableArray *toolbarActions =  [self loadActionsWith:toolbarAction];
            
            
            //johnny attachment
            // get folders
            
//            NSMutableArray* attachments = [[NSMutableArray alloc] init];
//            NSArray *attachmentsXml = [correspondence elementsForName:@"Attachments"];
//            if (attachmentsXml.count > 0) {
//                GDataXMLElement *attachmentsEl = (GDataXMLElement *) [attachmentsXml objectAtIndex:0];
//                attachments=[self loadAttachmentListWith:attachmentsEl];
//            }
            
            //jis ccorrespondence
            CCorrespondence  *newCorrespondence = [[CCorrespondence alloc] initWithId:Id Priority:Priority New:New Locked:Locked lockedByUser:lockBy SHOWLOCK:SHOWLOCK canOpenCorrespondence:canOpen];
            
            [newCorrespondence setTransferId:transferId];
            [newCorrespondence setSystemProperties:systemPropertiesList];
            [newCorrespondence setProperties:propertiesList];
//            [newCorrespondence setAttachmentsList:attachments];
            [newCorrespondence setToolbar:toolbarItems];
            [newCorrespondence setActions:toolbarActions];
            [Allcorrespondences addObject:newCorrespondence];
            
        }
        [allInboxes setObject:Allcorrespondences forKey:inboxId];
    }
    return allInboxes;
}
+(void)ShowMessage:(NSString*)message{
    
    NSString *msg = @"Server Issue";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Alert",@"Alert")
                          message: msg
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                          otherButtonTitles: nil];
    [alert show];
}

+(NSMutableArray*)loadSpecifiqueAttachment:(NSData*)xmlData{
    NSError *error;
    
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    
    if (doc == nil) { return nil; }
    
    NSArray *Attachments = [doc nodesForXPath:@"//Attachments" error:nil];
    NSMutableArray* attachments = [[NSMutableArray alloc] init];
 

    if (Attachments.count > 0) {
              GDataXMLElement *AttachmentsXML =  [Attachments objectAtIndex:0];
              attachments=[self loadAttachmentListWith:AttachmentsXML];
    }
    if(Attachments.count==0){
        
        NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
        
        GDataXMLElement *resultxml =  [results objectAtIndex:0];
        
        NSString* status=[(GDataXMLElement *) [resultxml attributeForName:@"status"] stringValue];
        
        if([status isEqualToString:@"Error"]){
            //[self ShowMessage:resultxml.stringValue];
            [self performSelectorOnMainThread:@selector(ShowMessage:) withObject:nil waitUntilDone:YES];
        }
    }
    return attachments;
    
}


+(NSMutableDictionary *)GetPropertiesFrom:(GDataXMLElement*) element{
    
    NSMutableDictionary* properties = [[NSMutableDictionary alloc] init];
    NSInteger i=0;
    NSArray *propertyXML = [element elementsForName:@"Property"];
    if (propertyXML.count > 0) {
        
        for(GDataXMLElement *prop in propertyXML)
        {
            // NSLog(@"prop element %@", prop);
             NSMutableDictionary* property = [[NSMutableDictionary alloc] init];
            NSArray *pnames = [prop elementsForName:@"Propname"];
            if (pnames.count > 0) {
                
                GDataXMLElement *pEl = (GDataXMLElement *) [pnames objectAtIndex:0];
                
                GDataXMLElement* valueEl = [[prop elementsForName:@"Propvalue"] objectAtIndex:0];
                
                [property setObject:valueEl.stringValue forKey:pEl.stringValue];
                NSString *s=[NSString stringWithFormat:@"%d",i];
                [properties setObject:property forKey:s];
                i++;
            }
            
        }
        
    }
    return properties;
}

+(NSMutableDictionary *)loadItemsByOrder:(NSArray*) arrayItems{
    
    NSMutableDictionary* properties = [[NSMutableDictionary alloc] init];
    NSInteger i=0;
   
    NSArray *items=((GDataXMLElement*)arrayItems[0]).children;
    for(GDataXMLElement *prop in items)
    {
         NSMutableDictionary* property = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
        NSArray *pnames = [prop elementsForName:@"Label"];
        if (pnames.count > 0) {
            
            GDataXMLElement *pEl = (GDataXMLElement *) [pnames objectAtIndex:0];
            
            GDataXMLElement* valueEl = [[prop elementsForName:@"Value"] objectAtIndex:0];
            
            [item setObject:valueEl.stringValue forKey:pEl.stringValue];
        }
        [property setObject:item forKey:prop.name ];
        NSString *s=[NSString stringWithFormat:@"%d",i];
        [properties setObject:property forKey:s];
        i++;
    }
    return properties;
}

+ (NSMutableArray *)loadFoldersListWith:(NSArray*) folders {
	
	
	NSMutableArray* Allfolders = [[NSMutableArray alloc] init];
	
	for (GDataXMLElement *folder in folders) {
		
        NSString *name;
       
		
        NSArray *names = [folder elementsForName:@"Name"];
        if (names.count > 0) {
            GDataXMLElement *namesEl = (GDataXMLElement *) [names objectAtIndex:0];
            name = namesEl.stringValue;
        }
		      
       NSMutableArray* attachments = [[NSMutableArray alloc] init];
        NSArray *attachmentsXml = [folder elementsForName:@"Attachments"];
        if (attachmentsXml.count > 0) {
            GDataXMLElement *attachmentsEl = (GDataXMLElement *) [attachmentsXml objectAtIndex:0];
            attachments=[self loadAttachmentListWith:attachmentsEl];
        }
        
        
        CFolder* newFolder = [[CFolder alloc] initWithName:name];
        [newFolder setAttachments:attachments];
        [Allfolders addObject:newFolder];
    }

    
    
    return Allfolders;
    
}





+(NSMutableArray*)loadAttachmentListWith:(GDataXMLElement*)attachmentEl{
    AppDelegate *mainDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSMutableArray* attachments = [[NSMutableArray alloc] init];
    NSArray *attachmentXML = [attachmentEl elementsForName:@"Attachment"];
    for(GDataXMLElement *attachment in attachmentXML)
    {
        [mainDelegate.IncomingHighlights removeAllObjects];
        [mainDelegate.IncomingNotes removeAllObjects];
        NSString* folderName;
        NSString* fileUri;
        NSString* title;
        NSString* url;
        NSString* SiteId;
        NSString* FileId;
        NSString* FileUrl;
        NSString* thumbnailUrl;
        NSString* isOriginalMail;
        NSString* AttachmentId;
        
        NSString* thumbnailBase64;
       // NSMutableArray* annotations=[[NSMutableArray alloc] init];
        
        NSArray *folderNames= [attachment elementsForName:@"Location"];
        if (folderNames.count > 0) {
            GDataXMLElement *folderNameEl = (GDataXMLElement *) [folderNames objectAtIndex:0];
            folderName = folderNameEl.stringValue;
        }
        
        NSArray *fileUris = [attachment elementsForName:@"DocId"];
        if (fileUris.count > 0) {
            GDataXMLElement *fileUriEl = (GDataXMLElement *) [fileUris objectAtIndex:0];
            fileUri = fileUriEl.stringValue;
        }
        NSArray *attachid = [attachment elementsForName:@"AttachmentId"];
        if (attachid.count > 0) {
            GDataXMLElement *attachidEl = (GDataXMLElement *) [attachid objectAtIndex:0];
            AttachmentId = attachidEl.stringValue;
        }
        NSArray *titles = [attachment elementsForName:@"Title"];
        if (titles.count > 0) {
            GDataXMLElement *titleEl = (GDataXMLElement *) [titles objectAtIndex:0];
            title = titleEl.stringValue;
        }
        
        NSArray *urls = [attachment elementsForName:@"url"];
        if (urls.count > 0) {
            GDataXMLElement *urlEl = (GDataXMLElement *) [urls objectAtIndex:0];
            url = urlEl.stringValue;
        }
        
        NSArray *SiteIds = [attachment elementsForName:@"SiteId"];
        if (SiteIds.count > 0) {
            GDataXMLElement *SiteIdEl = (GDataXMLElement *) [SiteIds objectAtIndex:0];
            SiteId = SiteIdEl.stringValue;
        }
        
        NSArray *FileIds = [attachment elementsForName:@"FileId"];
        if (FileIds.count > 0) {
            GDataXMLElement *FileIdEl = (GDataXMLElement *) [FileIds objectAtIndex:0];
            FileId = FileIdEl.stringValue;
        }
        
        
        NSArray *FileUrls = [attachment elementsForName:@"FileUrl"];
        if (FileUrls.count > 0) {
            GDataXMLElement *FileUrlEl = (GDataXMLElement *) [FileUrls objectAtIndex:0];
            FileUrl = FileUrlEl.stringValue;
        }
        
        NSArray *thumbnailUrls = [attachment elementsForName:@"ThumbnailUrl"];
        if (thumbnailUrls.count > 0) {
            GDataXMLElement *thumbnailUrlEl= (GDataXMLElement *) [thumbnailUrls objectAtIndex:0];
            thumbnailUrl = thumbnailUrlEl.stringValue;
        }
        
        NSArray *isOriginalMails = [attachment elementsForName:@"isOriginalMail"];
        if (isOriginalMails.count > 0) {
            GDataXMLElement *isOriginalMailEl= (GDataXMLElement *) [isOriginalMails objectAtIndex:0];
            isOriginalMail = isOriginalMailEl.stringValue;
        }
        
        
        NSArray *thumbnails= [attachment elementsForName:@"ThumbnailBase64"];
        if (thumbnails.count > 0) {
            GDataXMLElement *thumbnailEl = (GDataXMLElement *) [thumbnails objectAtIndex:0];
            thumbnailBase64 = thumbnailEl.stringValue;
        }
        
         NSMutableArray* annotations = [[NSMutableArray alloc] init];
        NSArray *annotationsXml = [attachment elementsForName:@"Annotations"];
        
        if (annotationsXml.count > 0) {
            GDataXMLElement *annotationsEl = (GDataXMLElement *) [annotationsXml objectAtIndex:0];
//            NSArray *annotationsArray = [annotationsEl elementsForName:@"Annotation"];
//            for(GDataXMLElement *note in annotationsArray)
//            {
//                NSInteger noteId=[[(GDataXMLElement *) [note attributeForName:@"NoteId"] stringValue]intValue];
//                NSString *security=[(GDataXMLElement *) [note attributeForName:@"SecurityLevel"] stringValue];
//                NSString *author=[(GDataXMLElement *) [note attributeForName:@"Author"] stringValue];
//                NSString *date=[(GDataXMLElement *) [note attributeForName:@"CreationDate"] stringValue];
//                 BOOL owner=[[(GDataXMLElement *) [note attributeForName:@"Owner"] stringValue] boolValue];
//                
//                NSString* value=[note stringValue];
//                
//                
//                CAnnotation* annotation = [[CAnnotation alloc] initWithId:noteId author:author securityLevel:security note:value creationDate:date owner:owner];
//                [annotations addObject:annotation];
//                
//                
//            }
            
            NSArray *Notes = [annotationsEl nodesForXPath:@"Notes" error:nil];
            
            
            
            GDataXMLElement *NotesXML;
            
            if(Notes.count>0){
                
                NotesXML = [Notes objectAtIndex:0];
                
            }
            
            
            
            NSArray *noteXML = [NotesXML elementsForName:@"Note"];
            
            NSString *noteX;
            
            NSString *noteY;
            
            NSString *notepage;
            
            NSString *noteMSG;
            
            
           
            
            for(GDataXMLElement *notee in noteXML)
                
            {
                
                NSArray *noteXs = [notee elementsForName:@"noteX"];
                
                if (noteXs.count > 0) {
                    
                    GDataXMLElement *noteXEl = (GDataXMLElement *) [noteXs objectAtIndex:0];
                    
                    noteX = noteXEl.stringValue;
                    
                }
                
                
                
                NSArray *noteYs = [notee elementsForName:@"noteY"];
                
                if (noteYs.count > 0) {
                    
                    GDataXMLElement *noteYEl = (GDataXMLElement *) [noteYs objectAtIndex:0];
                    
                    noteY = noteYEl.stringValue;
                    
                }
                
                
                
                NSArray *pages = [notee elementsForName:@"page"];
                
                if (pages.count > 0) {
                    
                    GDataXMLElement *pageEl = (GDataXMLElement *) [pages objectAtIndex:0];
                    
                    notepage = pageEl.stringValue;
                    
                }
                
                
                
                NSArray *noteMSGs = [notee elementsForName:@"noteMSG"];
                
                if (noteMSGs.count > 0) {
                    
                    GDataXMLElement *noteMSGEl = (GDataXMLElement *) [noteMSGs objectAtIndex:0];
                    
                    noteMSG = noteMSGEl.stringValue;
                    
                }
                
                
                
                
                
                CGPoint ptLeftTop;
                
                ptLeftTop.x=[noteX intValue];
                
                ptLeftTop.y=[noteY intValue];
                
                
                
                note* noteObj=[[note alloc]initWithName:ptLeftTop.x ordinate:ptLeftTop.y note:noteMSG PageNb:notepage.intValue AttachmentId:AttachmentId.intValue];
                [mainDelegate.IncomingNotes addObject:noteObj];
                
            }
            
            
            
            
            
            NSArray *Highlights = [annotationsEl nodesForXPath:@"Highlights" error:nil];
            
            
            
            GDataXMLElement *HighlightsXML;
            
            if(Highlights.count>0){
                
                HighlightsXML = [Highlights objectAtIndex:0];
                
            }
            
            
            
            NSArray *HighlightXML = [HighlightsXML elementsForName:@"Highlight"];
            
            NSString *HighlightX1;
            
            NSString *HighlightY1;
            
            NSString *HighlightX2;
            
            NSString *HighlightY2;
            
            NSString *Highlightpage;
            
            
            
            
            
            for(GDataXMLElement *Highlight in HighlightXML)
                
            {
                
                NSArray *HighlightX1s = [Highlight elementsForName:@"HighlightX1"];
                
                if (HighlightX1s.count > 0) {
                    
                    GDataXMLElement *HighlightX1El = (GDataXMLElement *) [HighlightX1s objectAtIndex:0];
                    
                    HighlightX1= HighlightX1El.stringValue;
                    
                }
                
                
                
                NSArray *HighlightX2s = [Highlight elementsForName:@"HighlightX2"];
                
                if (HighlightX2s.count > 0) {
                    
                    GDataXMLElement *HighlightX2El = (GDataXMLElement *) [HighlightX2s objectAtIndex:0];
                    
                    HighlightX2= HighlightX2El.stringValue;
                    
                }
                
                
                
                NSArray *HighlightY1s = [Highlight elementsForName:@"HighlightY1"];
                
                if (HighlightY1s.count > 0) {
                    
                    GDataXMLElement *HighlightY1El = (GDataXMLElement *) [HighlightY1s objectAtIndex:0];
                    
                    HighlightY1= HighlightY1El.stringValue;
                    
                }
                
                
                
                NSArray *HighlightY2s = [Highlight elementsForName:@"HighlightY2"];
                
                if (HighlightY2s.count > 0) {
                    
                    GDataXMLElement *HighlightY2El = (GDataXMLElement *) [HighlightY2s objectAtIndex:0];
                    
                    HighlightY2= HighlightY2El.stringValue;
                    
                }
                
                
                
                
                
                NSArray *Highlightpages = [Highlight elementsForName:@"page"];
                
                if (Highlightpages.count > 0) {
                    
                    GDataXMLElement *HighlightpageEl = (GDataXMLElement *) [Highlightpages objectAtIndex:0];
                    
                    Highlightpage = HighlightpageEl.stringValue;
                    
                }
                
                
                
                
                
                
                
                CGPoint ptLeftTop;
                
                CGPoint ptRightBottom;
                
                
                
                ptLeftTop.x=[HighlightX1 intValue];
                
                ptLeftTop.y=[HighlightY1 intValue];
                
                ptRightBottom.x=[HighlightX2 intValue];
                
                ptRightBottom.y=[HighlightY2 intValue];
                
            
                
                HighlightClass* obj=[[HighlightClass alloc]initWithName:ptLeftTop.x ordinate:ptLeftTop.y height:ptRightBottom.x width:ptRightBottom.y PageNb:notepage.intValue AttachmentId:AttachmentId.intValue];
                [mainDelegate.IncomingHighlights addObject:obj];
                
            }
        }

        CAttachment* newAttachment = [[CAttachment alloc] initWithTitle:title docId:fileUri url:url  thumbnailBase64:thumbnailBase64 location:folderName SiteId:SiteId FileId:FileId FileUrl:FileUrl ThubnailUrl:thumbnailUrl isOriginalMail:isOriginalMail];
        [newAttachment setAnnotations:annotations];
        [newAttachment setAttachmentId:AttachmentId];
        [newAttachment setNoteAnnotations:[mainDelegate.IncomingNotes copy]];
        [newAttachment setHighlightAnnotations:[mainDelegate.IncomingHighlights copy]];
        [attachments addObject:newAttachment];
        
    }
    
    return attachments;
    
}

+(NSInteger)GetNoteIdWithData:(NSData *) xmlData {
    
    
    // NSURL *xmlUrl = [NSURL URLWithString:url];
    // NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 error:&error];
    
    
	NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
	
	GDataXMLElement *noteXml =  [results objectAtIndex:0];
    
    
    NSInteger noteId;
    
	
    NSArray *noteIds = [noteXml elementsForName:@"NoteId"];
	GDataXMLElement *noteEl = (GDataXMLElement *) [noteIds objectAtIndex:0];
	noteId = [noteEl.stringValue integerValue];
    
    
    return noteId;
}

+(NSString*)loadPdfFile:(NSString*)fileUrl inDirectory:(NSString*)dirName{
    //NSString*strUrl;
  //  strUrl= [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   // NSURL *url=[NSURL URLWithString:strUrl];
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [cachesDirectory stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    
    NSString* pdfCacheName = [fileUrl lastPathComponent];
    
    NSString *tempPdfLocation = [path stringByAppendingPathComponent:pdfCacheName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:tempPdfLocation];
    if(!fileExists){
        //jen
        NSString*strUrl;
        strUrl=[fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:strUrl];
        NSData *data = [NSData dataWithContentsOfURL:url ];
        if(data.length!=0)
            [data writeToFile:tempPdfLocation atomically:TRUE];
        else tempPdfLocation=@"";    }
    
    return tempPdfLocation;
}

+(NSString*)loadSignature:(NSData*)xmlData {

NSError *error;

GDataXMLDocument *signatureXML = [[GDataXMLDocument alloc] initWithData:xmlData
                                                       options:0 error:&error];


NSString* signature;

    NSArray *signatures = [signatureXML nodesForXPath:@"//signature" error:nil];
    if (signatures.count > 0) {
        GDataXMLElement *signatureEl = (GDataXMLElement *) [signatures objectAtIndex:0];
        
        signature = signatureEl.stringValue;
        
        
    }

return signature;
}

+(CSearch *)loadSearchWithData:(NSData*)xmlData {

    NSMutableArray *searchCriteriaProp=[[NSMutableArray alloc]init];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 error:&error];
    
    if (doc == nil) { return nil; }
    
	NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
	

	GDataXMLElement *searchXML =  [results objectAtIndex:0];
    NSMutableArray *searchTypesList=[[NSMutableArray alloc]init];
     NSArray *searchTypesEl =[searchXML nodesForXPath:@"SearchTypes/Type" error:nil];
    
    for (GDataXMLElement * typeEl in searchTypesEl) {
       
        NSInteger typeId = [[typeEl attributeForName:@"id"].stringValue integerValue];
        NSString* label = [[[typeEl elementsForName:@"Label"] objectAtIndex:0] stringValue];
         NSString* icon = [[[typeEl elementsForName:@"Icon"]objectAtIndex:0] stringValue];
        CSearchType* searchType=[[CSearchType alloc]initWithId:typeId label:label icon:icon];
        [searchTypesList addObject:searchType];
    }

NSArray *searchCriteriaEl =[searchXML nodesForXPath:@"CriteriaList/Criteria" error:nil];
    for(GDataXMLElement * criteriaEl in searchCriteriaEl){
    NSString* criteriaId;
    NSString* label;
    NSString* type;
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    
    NSArray *ids = [criteriaEl elementsForName:@"id"];
	if (ids.count > 0) {
		GDataXMLElement *idEl = (GDataXMLElement *) [ids objectAtIndex:0];
		criteriaId = idEl.stringValue;
	}
    NSArray *labels = [criteriaEl elementsForName:@"label"];
	if (labels.count > 0) {
		GDataXMLElement *labelEl = (GDataXMLElement *) [labels objectAtIndex:0];
		label = labelEl.stringValue;
	}
    NSArray *types = [criteriaEl nodesForXPath:@"control/type" error:nil];
	if (types.count > 0) {
		GDataXMLElement *typeEl = (GDataXMLElement *) [types objectAtIndex:0];
		type = typeEl.stringValue;
	}
    NSArray *optionsList = [criteriaEl nodesForXPath:@"control/options/option" error:nil];
    for (GDataXMLElement * optionEl in optionsList) {
        
        NSString* optionId = [optionEl attributeForName:@"id"].stringValue;
        NSString* value = [optionEl attributeForName:@"label"].stringValue;
        
        [options setObject:value forKey:optionId];
        
    }
        CSearchCriteria* searchCriteria=[[CSearchCriteria alloc]initWithId:criteriaId label:label type:type options:options];
        [searchCriteriaProp addObject:searchCriteria];
    }
    
    CSearch *search=[[CSearch alloc]init];
    [search setSearchTypes:searchTypesList];
    [search setCriterias:searchCriteriaProp];
    return search;

}

+(NSMutableArray*)loadSearchCorrespondencesWithData:(NSData*)xmlData {
    
    // NSData *xmlData = [NSData dataWithContentsOfFile:url];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    
    if (doc == nil) { return nil; }
    
    NSArray *results = [doc nodesForXPath:@"//Result" error:nil];
    
    GDataXMLElement *correspondencesXML =  [results objectAtIndex:0];
    
    NSString* status=[(GDataXMLElement *) [correspondencesXML attributeForName:@"status"] stringValue];
    
    if([status isEqualToString:@"Error"]){
        return nil;
    }
    
            NSArray *correspondences =[correspondencesXML nodesForXPath:@"//Correspondences/Correspondence" error:nil];
        NSMutableArray* Allcorrespondences = [[NSMutableArray alloc] init];
        
        for (GDataXMLElement *correspondence in correspondences) {
            
            NSString *Id;
            NSString *Priority;
            BOOL New;
            BOOL Locked;
            NSMutableDictionary *propertiesList=[[NSMutableDictionary alloc] init];
            // NSMutableArray* annotations=[[NSMutableArray alloc] init];
            
            NSArray *correspondenceIds = [correspondence elementsForName:@"CorrespondenceId"];
            if (correspondenceIds.count > 0) {
                GDataXMLElement *correspondenceIdEl = (GDataXMLElement *) [correspondenceIds objectAtIndex:0];
                Id = correspondenceIdEl.stringValue;
            }
            
            
            NSArray *priorities = [correspondence elementsForName:@"Priority"];
            if (priorities.count > 0) {
                GDataXMLElement *priorityEl = (GDataXMLElement *) [priorities objectAtIndex:0];
                Priority = priorityEl.stringValue;
            }
            
            GDataXMLElement *newEl = (GDataXMLElement *) [[correspondence elementsForName:@"New"]objectAtIndex:0];
            New = [newEl.stringValue boolValue];
            
            GDataXMLElement *lockedEl = (GDataXMLElement *) [[correspondence elementsForName:@"Locked"]objectAtIndex:0];
            Locked = [lockedEl.stringValue boolValue];
            
            NSString *lockBy =[(GDataXMLElement *) [ [correspondence elementsForName:@"LockedBy"] objectAtIndex:0] stringValue];
            BOOL canOpen =[[(GDataXMLElement *) [ [correspondence elementsForName:@"CanOpen"] objectAtIndex:0] stringValue]boolValue];
            
            NSArray *systemProperties =[correspondence nodesForXPath:@"SystemProperties" error:nil];
            NSMutableDictionary *systemPropertiesList =  [self loadItemsByOrder:systemProperties];
            
            NSArray *properties = [correspondence elementsForName:@"Properties"];
            if (properties.count > 0) {
                GDataXMLElement *propertiesEl = (GDataXMLElement *) [properties objectAtIndex:0];
                propertiesList=[self GetPropertiesFrom:propertiesEl];
            }
            NSArray *toolbar =[correspondence nodesForXPath:@"Toolbar/ToolbarItems" error:nil];
            NSMutableDictionary *toolbarItems;
            if (toolbar.count > 0) {
                toolbarItems =  [self loadItems:toolbar];
            }
            
            NSArray *toolbarAction =[correspondence nodesForXPath:@"Toolbar/ToolbarActions/ToolbarAction" error:nil];
            NSMutableArray *toolbarActions;
            if (toolbarAction.count>0)
                toolbarActions =  [self loadActionsWith:toolbarAction];
            
            NSArray *SignAction =[correspondence nodesForXPath:@"Toolbar/ToolbarItems/SignActions/SignAction" error:nil];
            NSMutableArray *signActions;
            if(SignAction.count>0)
                signActions =  [self loadActionsWith:SignAction];
            
            // get folders
            NSMutableArray* attachments = [[NSMutableArray alloc] init];
            NSArray *attachmentsXml = [correspondence elementsForName:@"Attachments"];
            if (attachmentsXml.count > 0) {
                GDataXMLElement *attachmentsEl = (GDataXMLElement *) [attachmentsXml objectAtIndex:0];
                attachments=[self loadAttachmentListWith:attachmentsEl];
            }
            CCorrespondence  *newCorrespondence = [[CCorrespondence alloc] initWithId:Id Priority:Priority New:New Locked:Locked lockedByUser:lockBy canOpenCorrespondence:canOpen];
            [newCorrespondence setSystemProperties:systemPropertiesList];
            [newCorrespondence setProperties:propertiesList];
            [newCorrespondence setAttachmentsList:attachments];
            [newCorrespondence setToolbar:toolbarItems];
            [newCorrespondence setActions:toolbarActions];
            [Allcorrespondences addObject:newCorrespondence];
            
        }
    

    return Allcorrespondences;
}

@end
