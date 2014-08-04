//
//  NotesTableViewCell.m
//  iBoard
//
//  Created by DNA on 11/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "NotesTableViewCell.h"

@implementation NotesTableViewCell
@synthesize author,note,creationDate,btnDelete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
       
        
        author=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 475, 25)];
        author.backgroundColor=[UIColor clearColor];
        author.textColor=[UIColor whiteColor];
        
        creationDate=[[UILabel alloc]initWithFrame:CGRectMake(self.author.frame.size.width+2, 10, 150, 25)];
        creationDate.backgroundColor=[UIColor clearColor];
        creationDate.textColor=[UIColor whiteColor];
        creationDate.font=[UIFont italicSystemFontOfSize:18];
        note  =[[UILabel alloc]initWithFrame:CGRectMake(50, 35, self.frame.size.width-50, 30)];
        note.backgroundColor=[UIColor clearColor];
        note.textColor=[UIColor whiteColor];
        //note.font=[UIFont fontWithName:@"Helvetica" size:16];
        note.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        [note setNumberOfLines:0];
        
          AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"]){
            note.textAlignment=NSTextAlignmentRight;
           // author.frame=CGRectMake(520-120, 10, 100, 25);
            author.textAlignment =NSTextAlignmentRight;
           // creationDate.frame=CGRectMake(400-self.author.frame.size.width-2-150, 10, 150, 25);
           // creationDate.textAlignment =NSTextAlignmentRight;
        }
        [self addSubview:btnDelete];
        [self addSubview:author];
        //[self addSubview:creationDate];
        [self addSubview:note];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame{
    frame.size.width=520;
    [super setFrame:frame];
}


@end

@implementation UILabel (dynamicSizeWidth)

-(void)resizeToStretchWidth{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

-(void)resizeToStretchHeight{

    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
}

-(float)expectedHeight{
    
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, FLT_MAX);
    CGRect expectedLabelSize = [[self text] boundingRectWithSize:maximumLabelSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[self font]}
                                         context:nil];
   
 //   CGSize expectedLabelSize = [[self text] sizeWithFont:[self font] constrainedToSize:maximumLabelSize lineBreakMode:[self lineBreakMode]];
    
    return expectedLabelSize.size.height;
}


-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX,self.frame.size.height);
    CGRect expectedLabelSize = [[self text] boundingRectWithSize:maximumLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[self font]}
                                                         context:nil];
    //CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]constrainedToSize:maximumLabelSize lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.size.width;
}

@end