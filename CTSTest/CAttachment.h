//
//  CAttachment.h
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAttachment : NSObject<NSURLConnectionDelegate>

@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSString* docId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* thumbnailBase64;
@property (nonatomic, retain) NSMutableArray* annotations;
@property (nonatomic, retain) NSString *tempPdfLocation;
@property (nonatomic, retain) NSString *AttachmentId;


@property (nonatomic,retain) NSString* SiteId;
@property (nonatomic,retain) NSString* FileId;
@property (nonatomic,retain) NSString* FileUrl;
@property (nonatomic,retain) NSString* ThubnailUrl;
@property (nonatomic,retain) NSString* isOriginalMail;
@property (retain,nonatomic) NSMutableArray* HighlightAnnotations;
@property (retain,nonatomic) NSMutableArray* NoteAnnotations;

-(id) initWithTitle:(NSString*)title docId:(NSString*)did url:(NSString*)url  thumbnailBase64:(NSString*)thumbnailBase64 location:(NSString*)folderName;

-(id) initWithTitle:(NSString*)title docId:(NSString*)did url:(NSString*)url  thumbnailBase64:(NSString*)thumbnailBase64 location:(NSString*)folderName SiteId:(NSString*)SiteId FileId:(NSString*)FileId FileUrl:(NSString *)FileUrl ThubnailUrl:(NSString *)ThubnailUrl isOriginalMail:(NSString*)isOriginalMail;

-(NSString *)saveInCacheinDirectory:(NSString*)dirName fromSharepoint:(BOOL)isSharePoint;
@end
