//
//  note.h
//  CTSIpad
//
//  Created by DNA on 7/15/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface note : NSObject
@property int PageNb;
@property int AttachmentId;
@property double abscissa;
@property double ordinate;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *status;

-(id)initWithName:(double )abscisa ordinate:(double )ordinat note:(NSString *)notes PageNb:(int)Pagenb AttachmentId:(int)Attachmentid;
@end
