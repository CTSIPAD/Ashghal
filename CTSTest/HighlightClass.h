//
//  HighlightClass.h
//  CTSIpad
//
//  Created by DNA on 7/15/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface HighlightClass : NSObject
@property int PageNb;
@property int index;
@property int AttachmentId;
@property double abscissa;
@property double ordinate;
@property double x1;
@property double y1;
@property (nonatomic, retain) NSString *status;
-(id)initWithName:(double )abscisa ordinate:(double )ordinat height:(double)h width:(double)w PageNb:(int)Pagenb AttachmentId:(int)Attachmentid;
@end
