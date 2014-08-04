//
//  HighlightClass.m
//  CTSIpad
//
//  Created by DNA on 7/15/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "HighlightClass.h"

@implementation HighlightClass
@synthesize ordinate,abscissa,x1,y1,status,PageNb,AttachmentId;

-(id)initWithName:(double )abscisa ordinate:(double )ordinat height:(double)h width:(double)w PageNb:(int)Pagenb AttachmentId:(int)Attachmentid
{
    self = [super init];
    if (self) {
        self.PageNb=Pagenb;
        self.abscissa = abscisa;
        self.ordinate = ordinat;
        self.x1 = h;
        self.y1=w;
        self.status=@"NEW";
        self.AttachmentId=Attachmentid;
    }
    return self;
}
@end
