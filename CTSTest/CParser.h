//
//  CParser.h
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CUser;
@class CMenu;
@interface CParser : NSObject

+(NSString*)ValidateWithData:(NSData*)xmlData;
//+ (CUser *)loadUserWithData:(NSData*) xmlData ;
+ (CUser *)loadUserWithData:(NSString*) url ;
+(NSMutableDictionary *)loadCorrespondencesWithData:(NSData*)xmlData;
//+(NSMutableDictionary *)loadCorrespondencesWithData:(NSString*)url;
+(NSString*)loadPdfFile:(NSString*)fileUrl inDirectory:(NSString*)dirName;
+(NSInteger)GetNoteIdWithData:(NSData*) xmlData;
+(CSearch *)loadSearchWithData:(NSData*)xmlData;
+(NSMutableArray*)loadSearchCorrespondencesWithData:(NSData*)xmlData;
+(NSMutableArray*)loadSpecifiqueAttachment:(NSData*)xmlData;

-(void)john:(NSData *)xmlData;
@end
