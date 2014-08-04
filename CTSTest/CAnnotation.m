//
//  CFAnnotation.m
//  iBoard
//
//  Created by DNA on 11/6/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CAnnotation.h"

@implementation CAnnotation

-(id)initWithId:(NSInteger)noteId author:(NSString*)author securityLevel:(NSString*)security  note:(NSString*)note creationDate:(NSString*)date owner:(BOOL)isOwner{
    if ((self = [super init])) {
        self.noteId=noteId;
        self.note = note;
		self.securityLevel = security;
        self.Author=author;
        self.CreationDate=date;
       self.owner=isOwner;
       // self.page=pageNumber;
	}
    return self;
}
@end
