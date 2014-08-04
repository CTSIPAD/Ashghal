//
//  PdfGalleryCollectionViewCell.m
//  iBoard
//
//  Created by LBI on 10/24/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "PdfGalleryCollectionViewCell.h"
#import "CParser.h"
#import "CUser.h"
#import "CCorrespondence.h"
#import "CFPendingAction.h"

@implementation PdfGalleryCollectionViewCell
{
    UIView *detailsView;
    UILabel *lblSender;
    UILabel *lblSubject;
    UILabel *lblNumber;
    UILabel *lblDate;
    UIImageView *imageView;
    AppDelegate *mainDelegate;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
       
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.alpha = 0.7;
        
        self.imageViewLock = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 25, 25)];
       
       
        self.imageViewRight1 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-55, 3, 25, 25)];
        self.imageViewRight2= [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-30, 3, 25, 25)];
        detailsView= [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-76, frame.size.width, 150)];
        detailsView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thumb.png"]];
        
        lblSender=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, frame.size.width-10, 30)];
        lblSender.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        lblSender.textColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:213/255.0f alpha:1.0];
        
        
        lblSubject=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, frame.size.width-10, 90)];
        lblSubject.font = [UIFont fontWithName:@"Helvetica" size:20];
        lblSubject.textColor=[UIColor whiteColor];
        lblSubject.numberOfLines=0;
        
        if([appDelegate.userLanguage.lowercaseString isEqualToString:@"ar"]){
             lblSender.textAlignment=NSTextAlignmentRight;
             lblSubject.textAlignment=NSTextAlignmentRight;
        }
        
        lblNumber=[[UILabel alloc]initWithFrame:CGRectMake(5, 120, frame.size.width/2-5, 30)];
        lblNumber.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lblNumber.textColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:213/255.0f alpha:1.0];
        
        lblDate=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2, 120, frame.size.width/2-5, 30)];
        lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lblDate.textColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:213/255.0f alpha:1.0];
        lblDate.textAlignment=NSTextAlignmentRight;
        [detailsView addSubview:lblSender];
        [detailsView addSubview:lblSubject];
        [detailsView addSubview:lblNumber];
        [detailsView addSubview:lblDate];
        [self addSubview:imageView];
        
//        if(self.showLocked){
//            [self addSubview:self.imageViewLock];
//        }
        
        [self addSubview:self.imageViewRight1];
        [self addSubview:self.imageViewRight2];
        [self addSubview:detailsView];
        
    }
    

    return self;
}

-(void)setFrame:(CGRect)frame{
    
    frame.size.width=self.bounds.size.width;
    frame.size.height=self.bounds.size.height;
}

-(void)updateCell {
   
    imageView.frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    detailsView.frame=CGRectMake(0, self.bounds.size.height-150, self.bounds.size.width, 150);
    lblSender.frame=CGRectMake(5, 0, self.bounds.size.width-10, 30);
    lblSubject.frame=CGRectMake(5, 30, self.bounds.size.width-10, 90);
    lblNumber.frame=CGRectMake(5, 120, self.bounds.size.width/2-5, 30);
    lblDate.frame=CGRectMake(self.bounds.size.width/2, 120, self.bounds.size.width/2-5, 30);
    self.imageViewLock.frame = CGRectMake(5, 3, 30, 30);
    self.imageViewRight1.frame = CGRectMake(self.bounds.size.width-65, 3, 30, 30);
    self.imageViewRight2.frame= CGRectMake(self.bounds.size.width-35, 3, 30, 30);
    
    if(self.showLocked){
        [self addSubview:self.imageViewLock];
    }
    
    if(self.showLocked){
        if(self.Locked){
            [self.imageViewLock setImage:[UIImage imageNamed:@"cts_Lock.png"]];
        }else{
            [self.imageViewLock setImage:[UIImage imageNamed:@"cts_Unlock.png"]];
        }
    }
    
    if([self.Priority isEqualToString:@"high"] && self.New)
        [self.imageViewRight1 setImage:[UIImage imageNamed:@"cts_Priority.png"]];
    else if([self.Priority isEqualToString:@"high"] && !self.New){
        self.imageViewRight1.image = nil;
        [self.imageViewRight2 setImage:[UIImage imageNamed:@"cts_Priority.png"]];
    }
    else{ self.imageViewRight1.image = nil;
    self.imageViewRight2.image = nil;}
    if(self.New)
        [self.imageViewRight2 setImage:[UIImage imageNamed:@"cts_New.png"]];
    
    UIImage *cellImage;
    
    NSData * data = [NSData dataWithBase64EncodedString:self.imageThumbnailBase64];
    cellImage = [UIImage imageWithData:data];
    imageView.clipsToBounds = YES;
    CGSize newSize=CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    cellImage=[self imageByScalingProportionallyToSize:newSize sourceImage:cellImage];
   [imageView setImage:cellImage];
    lblSender.text=self.Sender;
    lblSubject.text=self.Subject;
    lblNumber.text=self.Number;
    lblDate.text=self.Date;
    
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage*)sourceImage{

    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
       else
           scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
//        if (widthFactor < heightFactor) {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        } else if (widthFactor > heightFactor) {
//            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//        }
    }
    
    
    
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

-(void) performLockAction

{ //AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(self.Locked){
        if([self.correspondence performCorrespondenceAction:@"UnlockCorrespondence"]){
        self.Locked=NO;
        //self.LockedBy=@"";
        [self.imageViewLock setImage:[UIImage imageNamed:@"cts_Unlock.png"]];
        }
    }else{
        if([self.correspondence performCorrespondenceAction:@"LockCorrespondence"]){
        self.Locked=YES;
        //self.LockedBy=mainDelegate.user.userId;
        [self.imageViewLock setImage:[UIImage imageNamed:@"cts_Lock.png"]];
             mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            self.LockedBy = [NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName
];
                    }
    }
    

}


 -(void)ShowMessage:(NSString*)message{
        
        NSString *msg = message;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Alert",@"Alert")
                              message: msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                              otherButtonTitles: nil];
        [alert show];
    }


@end
