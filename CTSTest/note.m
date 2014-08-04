//
//  note.m
//  CTSIpad
//
//  Created by DNA on 7/15/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "note.h"

@implementation note
@synthesize note,ordinate,abscissa,status,PageNb,AttachmentId;

-(id)initWithName:(double )abscisa ordinate:(double )ordinat note:(NSString *)notes PageNb:(int)Pagenb AttachmentId:(int)Attachmentid
{
    self = [super init];
    if (self) {
        self.PageNb=Pagenb;
        self.abscissa = abscisa;
        self.ordinate = ordinat;
        self.note = notes;
        self.status=@"NEW";
        self.AttachmentId=Attachmentid;
    }
    return self;
}

@end
