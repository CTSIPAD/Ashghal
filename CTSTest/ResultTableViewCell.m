//
//  SearchResultTableViewCell.m
//  iBoard
//
//  Created by DNA on 11/14/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell
@synthesize imageView,label1,label2,label3,label4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat red = 29.0f / 255.0f;
        CGFloat green = 29.0f / 255.0f;
        CGFloat blue = 29.0f / 255.0f;
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
       
        //imageView =[[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 119, 119)];
        //[self addSubview:imageView];
        
//        label1=[[UILabel alloc] initWithFrame:CGRectMake(150, 5, 600, 30)];
        label1=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 600, 30)];
        label1.backgroundColor=[UIColor clearColor];
        label1.textColor=[UIColor whiteColor];
        //label1.font=[UIFont fontWithName:@"Helvetica" size:26];
        label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        [self addSubview:label1];
        
        label2=[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 600, 25)];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor=[UIColor whiteColor];
        //label2.font=[UIFont fontWithName:@"Helvetica" size:20];
        label2.font=[UIFont fontWithName:@"Helvetica" size:16];
        [self addSubview:label2];
        
        label3=[[UILabel alloc] initWithFrame:CGRectMake(10, 65, 600, 20)];
        label3.backgroundColor=[UIColor clearColor];
        label3.textColor=[UIColor whiteColor];
        //label3.font=[UIFont italicSystemFontOfSize:14];
        label3.font=[UIFont fontWithName:@"Helvetica" size:16];
        [self addSubview:label3];
        
        label4=[[UILabel alloc] initWithFrame:CGRectMake(10, 85, 600, 20)];
        label4.backgroundColor=[UIColor clearColor];
        label4.textColor=[UIColor whiteColor];
        //label4.font=[UIFont italicSystemFontOfSize:14];
        label4.font=[UIFont fontWithName:@"Helvetica" size:16];
        [self addSubview:label4];

    }
    return self;
}

-(void)updateCell {
    
   
    UIImage *cellImage;
    
    NSData * data = [NSData dataWithBase64EncodedString:self.imageThumbnailBase64];
    
    cellImage = [UIImage imageWithData:data];
    self.imageView.clipsToBounds = YES;
   
    [self.imageView setImage:cellImage];
   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
