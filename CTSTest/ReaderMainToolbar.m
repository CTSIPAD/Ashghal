//
//	ReaderMainToolbar.m
//	Reader v2.6.1
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"
#import"CUser.h"
#import"CMenu.h"
#import"CCorrespondence.h"
#import"CAttachment.h"
#import"CFolder.h"
#import "AppDelegate.h"
#import "CParser.h"
#import "CSearch.h"
#import "TransferViewController.h"
#import <MessageUI/MessageUI.h>
#import "CFPendingAction.h"

@implementation ReaderMainToolbar
{
	UIButton *markButton;

	UIImage *markImageN;
	UIImage *markImageY;

    
    NSInteger correspondencesCount;
    //jen PreviousNext
    NSInteger attachementsCount;
    AppDelegate *mainDelegate;
    NSString* pageName;
    CCorrespondence *correspondence;
}
@synthesize nextButton,previousButton,actionsButton,transferButton,attachmentButton,metadataButton,lockButton,commentsButton,annotationButton,lblTitle,closeButton;
#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define EMAIL_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define TITLE_HEIGHT 28.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame document:nil CorrespondenceId:0 MenuId:0 AttachmentId:0];
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object CorrespondenceId:(NSInteger)correspondenceId MenuId:(NSInteger)menuId AttachmentId:(NSInteger)attachmentId
{
	assert(object != nil); // Must have a valid ReaderDocument
	if ((self = [super initWithFrame:frame]))
	{
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(self.frame.size.width, 10, 61, 20);
        [closeButton setTintColor:[UIColor whiteColor]];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"up.jpg"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hideToolbar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        self.menuId=menuId;
        self.correspondenceId=correspondenceId;
        self.attachmentId=attachmentId;
        NSInteger btnWidth=80;
        NSInteger leftButtonX=10;
       
        
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.user=mainDelegate.user;
        
        if(menuId!=100){
            correspondence=((CMenu*)self.user.menu[menuId]).correspondenceList[correspondenceId];
             correspondencesCount=((CMenu*)self.user.menu[menuId]).correspondenceList.count;
            //jen PreviousNext
            attachementsCount=correspondence.attachmentsList.count;
        }else{
            
            correspondence=mainDelegate.searchModule.correspondenceList[mainDelegate.searchSelected];
             correspondencesCount=mainDelegate.searchModule.correspondenceList.count;
            //jen PreviousNext
            attachementsCount=correspondence.attachmentsList.count;
        }
        
        lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.frame.size.width, 15)];
        lblTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        lblTitle.textColor=[UIColor colorWithRed:204/255.0f green:233/255.0f blue:247/255.0f alpha:1.0];
        //lblTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lblTitle];
        
       homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [homeButton setBackgroundImage:[UIImage imageNamed:@"HomeIcon.png"] forState:UIControlStateNormal];
        //[homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 17, 10, 0)];
        [homeButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 10, 0,10)];
        [homeButton setTitle:NSLocalizedString(@"Menu.Home",@"Home") forState:UIControlStateNormal];
        homeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [homeButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
      
        [self addSubview:homeButton];
        
       
        
  
         CGFloat viewWidth = self.frame.size.width;
        CGFloat rightButtonX = viewWidth;
        
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButtonX -= (65 + 10);
        nextButton.frame = CGRectMake(rightButtonX, 30, 65, 90);
        [nextButton setBackgroundImage: [UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
        [nextButton setTitle:NSLocalizedString(@"Menu.Next",@"Next") forState:UIControlStateNormal];
        nextButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [nextButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
         [nextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:nextButton];
       //jen PreviousNext
        if(attachmentId==attachementsCount-1){
            nextButton.enabled=FALSE;
        }
//        if(correspondenceId==correspondencesCount-1){
//            nextButton.enabled=FALSE;
//        }
        else  nextButton.enabled=TRUE;
      
        previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButtonX -= (65 + 10);
        previousButton.frame = CGRectMake(rightButtonX, 30, 65, 90);
        //[previousButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
         [previousButton setBackgroundImage: [UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
       // previousButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
       // previousButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), -17, 0.0, - titleSize.width);
       // [previousButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 10, 10)];
        [previousButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
        [previousButton setTitle:NSLocalizedString(@"Menu.Previous",@"Previous") forState:UIControlStateNormal];
        previousButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [previousButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [previousButton setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
       [previousButton addTarget:self action:@selector(previousButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousButton];
        //jen PreviousNext
//        if(correspondenceId==0){
//            previousButton.enabled=FALSE;
//        }
        if(attachmentId==0){
            previousButton.enabled=FALSE;
        }
        else  previousButton.enabled=TRUE;
        
        lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButtonX -= (65 + 10);
        lockButton.frame = CGRectMake(rightButtonX, 30, 65, 90);
        //[previousButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
        if(correspondence.Locked==YES){
            [lockButton setBackgroundImage: [UIImage imageNamed:@"Unlock.png"] forState:UIControlStateNormal];
            [lockButton setBackgroundImage: [UIImage imageNamed:@"Lock.png"] forState:UIControlStateSelected];
             [lockButton setTitle:NSLocalizedString(@"Menu.Unlock",@"unlock") forState:UIControlStateNormal];
            
        }
        else{
            [lockButton setBackgroundImage: [UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
             [lockButton setBackgroundImage: [UIImage imageNamed:@"Unlock.png"] forState:UIControlStateSelected];
             [lockButton setTitle:NSLocalizedString(@"Menu.Lock",@"lock") forState:UIControlStateNormal];
            
        }
        // previousButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        // previousButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), -17, 0.0, - titleSize.width);
        // [previousButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 10, 10)];
        [lockButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
       
        lockButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [lockButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [lockButton setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
        [lockButton addTarget:self action:@selector(lockButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:lockButton];
        [self updateToolbar];
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   [self adjustButtons:orientation];


	return self;
}

-(void)adjustButtons:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        lockButton.frame=CGRectMake(560, 30, 65, 90);
       previousButton.frame=CGRectMake(630, 30, 65, 90);
         nextButton.frame = CGRectMake(700,30, 65, 90);
        closeButton.frame = CGRectMake(500,100, 61, 40);
       // lblTitle.frame = CGRectMake(0, 15, 765, 15);
    } else {
         lockButton.frame=CGRectMake(810, 30, 65, 90);
        previousButton.frame=CGRectMake(880, 30, 65, 90);
         nextButton.frame = CGRectMake(950, 30, 65, 90);
        closeButton.frame = CGRectMake(500, 100, 61, 40);
        //lblTitle.frame = CGRectMake(0, 15, 1024, 15);
    }
}

-(void)desableButtons{
    [annotationButton removeFromSuperview];
    [transferButton removeFromSuperview];
}

- (void)setBookmarkState:(BOOL)state
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
	if (self.hidden == NO)
	{
       
        
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

-(ReaderDocument*) OpenPdfReader:(NSString *) pdfPath{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSString *filePath = pdfPath;// [pdfs lastObject];
    assert(filePath != nil); // Path to last PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    return document;
}


#pragma mark UIButton action methods


- (void)homeButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self homeButton:button];
}

- (void)actionsButtonTapped:(UIButton *)button
{
   
	[delegate tappedInToolbar:self actionsButton:button];
}

- (void)commentButtonTapped:(UIButton *)button
{
[delegate tappedInToolbar:self commentButton:button];
}
- (void)metadataButtonTapped:(UIButton *)button
{
    
	[delegate tappedInToolbar:self metadataButton:button];
    
   
}

- (void)attachmentButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self attachmentButton:button];
}

- (void)annotationButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self annotationButton:button];
}
- (void)transferButtonTapped:(UIButton *)button
{
  [delegate tappedInToolbar:self transferButton:button];
  
}
BOOL lockSelected=NO;
- (void)lockButtonTapped:(UIButton *)button
{
    
    lockSelected=!lockSelected;
    if(lockSelected){
        lockButton.selected=YES;
    }else  lockButton.selected=NO;
    if(correspondence.Locked==NO){
         if([self performLock:@"LockCorrespondence"])
         [lockButton setTitle:NSLocalizedString(@"Menu.Unlock",@"unlock") forState:UIControlStateNormal];
        if(self.menuId !=100)
        ((CCorrespondence*) ((CMenu*)self.user.menu[self.menuId]).correspondenceList[self.correspondenceId]).Locked=YES;
    }
    else{  if([self performLock:@"UnlockCorrespondence"])
         [lockButton setTitle:NSLocalizedString(@"Menu.Lock",@"lock") forState:UIControlStateNormal];
        if(self.menuId !=100)
         ((CCorrespondence*) ((CMenu*)self.user.menu[self.menuId]).correspondenceList[self.correspondenceId]).Locked=NO;
       
    }
 // [delegate tappedInToolbar:self lockButton:button];
    
}

-(BOOL)performLock:(NSString*)action{
    
    BOOL isPerformed=NO;
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    NSString* url=[NSString stringWithFormat:@"action=%@&token=%@&correspondenceId=%@",action,appDelegate.user.token,correspondence.Id];
    NSString* lockUrl = [NSString stringWithFormat:@"http://%@?%@",serverUrl,url];
    NSURL *xmlUrl = [NSURL URLWithString:lockUrl];
    NSData *lockXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
    
    NSString *validationResult=[CParser ValidateWithData:lockXmlData];
    if(![validationResult isEqualToString:@"OK"]){
        if([validationResult isEqualToString:@"Cannot access to the server"])
        {isPerformed=YES;
            
            CFPendingAction*pa = [[CFPendingAction alloc] initWithActionUrl:url];
            [appDelegate.user addPendingAction:pa];
        }else
            [delegate tappedInToolbar:self lockButton:nil message:validationResult];
    }
    else isPerformed=YES;
    
    return isPerformed;
}


- (void)nextButtonTapped :(UIButton *)button
{
    //jen PreviousNext
    CAttachment *fileToOpen;
   // self.correspondenceId=self.correspondenceId+1;
    self.attachmentId=self.attachmentId+1;
    if(self.menuId!=100){
    correspondence= ((CMenu*)self.user.menu[self.menuId]).correspondenceList[self.correspondenceId];
        //jen PreviousNext
        fileToOpen=correspondence.attachmentsList[self.attachmentId];
    }else{
        correspondence=mainDelegate.searchModule.correspondenceList[self.correspondenceId];
        //jen PreviousNext
        fileToOpen=correspondence.attachmentsList[self.attachmentId];
    }
   
    //CAttachment *fileToOpen=correspondence.attachmentsList[1];
   // [self updateTitleWithLocation:fileToOpen.location withName:fileToOpen.title];
    //jen PreviousNext
     //NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:correspondence.Id fromSharepoint:mainDelegate.isSharepoint];
    NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:fileToOpen.docId fromSharepoint:mainDelegate.isSharepoint];
   //  NSString *tempPdfLocation=[CParser loadPdfFile:fileToOpen.url inDirectory:correspondence.Id];
    ReaderDocument *newdocument=nil;
    if ([ReaderDocument isPDF:tempPdfLocation] == YES) // File must exist
    {
    newdocument=[self OpenPdfReader:tempPdfLocation];
    }
    
    //jen PreviousNext
	//[delegate tappedInToolbar:self nextButton:button documentReader:newdocument correspondenceId:self.correspondenceId];
    [delegate tappedInToolbar:self nextButton:button documentReader:newdocument correspondenceId:self.correspondenceId attachementId:self.attachmentId];
//    if(self.correspondenceId==correspondencesCount-1){
//        button.enabled=FALSE;
//    }
    if(self.attachmentId==attachementsCount-1){
        button.enabled=FALSE;
    }
    else  button.enabled=TRUE;
//    if(self.correspondenceId==0){
//        previousButton.enabled=FALSE;
//        
//    }
    if(self.attachmentId==0){
        previousButton.enabled=FALSE;
    }
    else  previousButton.enabled=TRUE;
    lockSelected=NO;
   [self updateToolbar];
   }

- (void)previousButtonTapped :(UIButton *)button
{
    //jen PreviousNExt
    CAttachment *fileToOpen;
    //self.correspondenceId=self.correspondenceId-1;
    self.attachmentId=self.attachmentId-1;
    
    if(self.menuId!=100){
        correspondence= ((CMenu*)self.user.menu[self.menuId]).correspondenceList[self.correspondenceId];
        //jen
        fileToOpen=correspondence.attachmentsList[self.attachmentId];
    }else{
        correspondence=mainDelegate.searchModule.correspondenceList[self.correspondenceId];
        //jen
        fileToOpen=correspondence.attachmentsList[self.attachmentId];
    }
    
    //CAttachment *fileToOpen=correspondence.attachmentsList[0];
   // [self updateTitleWithLocation:fileToOpen.location withName:fileToOpen.title];
    //jen
    // NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:correspondence.Id fromSharepoint:mainDelegate.isSharepoint];
    NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:fileToOpen.docId fromSharepoint:mainDelegate.isSharepoint];
   // NSString *tempPdfLocation=[CParser loadPdfFile:fileToOpen.url inDirectory:correspondence.Id];

    ReaderDocument *document=nil;
    if ([ReaderDocument isPDF:tempPdfLocation] == YES) // File must exist
    {
        document=[self OpenPdfReader:tempPdfLocation];
    }
//jen PreviousNext
	//[delegate tappedInToolbar:self previousButton:button documentReader:document correspondenceId:self.correspondenceId];
    [delegate tappedInToolbar:self previousButton:button documentReader:document correspondenceId:self.correspondenceId attachementId:self.attachmentId];
//    if(self.correspondenceId==0){
//        button.enabled=FALSE;
//    
//    }
    if(self.attachmentId==0){
            button.enabled=FALSE;
            }
    else  button.enabled=TRUE;
    
//    if(self.correspondenceId==correspondencesCount-1){
//        nextButton.enabled=FALSE;
//    }
    if(self.attachmentId==attachementsCount-1){
        nextButton.enabled=FALSE;
    }
    else  nextButton.enabled=TRUE;
    
   lockSelected=NO;
    [self updateToolbar];
}



-(void)updateToolbar{
    NSInteger btnWidth=80;
    NSInteger leftButtonX=90;
    [metadataButton removeFromSuperview];
    [attachmentButton removeFromSuperview];
    [transferButton removeFromSuperview];
    [commentsButton removeFromSuperview];
    [annotationButton removeFromSuperview];
    [actionsButton removeFromSuperview];
    if([[correspondence.toolbar objectForKey:@"Metadata"] isEqualToString:@"YES"]){
        metadataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        metadataButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [metadataButton setBackgroundImage:[UIImage imageNamed:@"metadata.png"] forState:UIControlStateNormal];
        [metadataButton setTitle:NSLocalizedString(@"Menu.Metadata",@"Metadata") forState:UIControlStateNormal];
        [metadataButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 2, 0,2)];
        
        metadataButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [metadataButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [metadataButton addTarget:self action:@selector(metadataButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:metadataButton];
        leftButtonX=leftButtonX+btnWidth;
    }
    if([[correspondence.toolbar objectForKey:@"Attachments"] isEqualToString:@"YES"]){
        attachmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        attachmentButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [attachmentButton setBackgroundImage:[UIImage imageNamed:@"attachments.png"] forState:UIControlStateNormal];
        [attachmentButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
        
        
        [attachmentButton setTitle:NSLocalizedString(@"Menu.Attachments",@"Attachments") forState:UIControlStateNormal];
        attachmentButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [attachmentButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [attachmentButton addTarget:self action:@selector(attachmentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attachmentButton];
        leftButtonX=leftButtonX+btnWidth;
    }
    
    if([[correspondence.toolbar objectForKey:@"Comments"] isEqualToString:@"YES"]){
        commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentsButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [commentsButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 2, 0,2)];
        [commentsButton setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        
        [commentsButton setTitle:NSLocalizedString(@"Menu.Comments",@"Comments") forState:UIControlStateNormal];
        commentsButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [commentsButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [commentsButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentsButton];
        
        leftButtonX=leftButtonX+btnWidth;
    }
    
    if([[correspondence.toolbar objectForKey:@"Transfer"] isEqualToString:@"YES"]){
        transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        transferButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [transferButton setBackgroundImage:[UIImage imageNamed:@"transfer.png"] forState:UIControlStateNormal];
        // [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 17, 10, 0)];
        [transferButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 2, 0,2)];
        [transferButton setTitle:NSLocalizedString(@"Menu.Transfer",@"Transfer") forState:UIControlStateNormal];
        transferButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [transferButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [transferButton addTarget:self action:@selector(transferButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:transferButton];
        
        leftButtonX=leftButtonX+btnWidth;
    }
    
    if([[correspondence.toolbar objectForKey:@"Highlight"] isEqualToString:@"YES"] || [[correspondence.toolbar objectForKey:@"Note"] isEqualToString:@"YES"] || [[correspondence.toolbar objectForKey:@"Sign"] isEqualToString:@"YES"]
       || [[correspondence.toolbar objectForKey:@"SignAndSend"] isEqualToString:@"YES"]){
        annotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        annotationButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        // [annotationButton setImage:[UIImage imageNamed:@"highlight.png"] forState:UIControlStateNormal];
        [annotationButton setBackgroundImage: [UIImage imageNamed:@"Annotations.png"] forState:UIControlStateNormal];
        // [nextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 17, 10, 0)];
        [annotationButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
        [annotationButton setTitle:NSLocalizedString(@"Menu.Annotations",@"Annotations") forState:UIControlStateNormal];
        annotationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [annotationButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [annotationButton setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
        [annotationButton addTarget:self action:@selector(annotationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:annotationButton];
        leftButtonX=leftButtonX+btnWidth;
    }
    
    if(correspondence.actions.count>0 ){
        actionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionsButton.frame = CGRectMake(leftButtonX, 30, btnWidth, 90);
        [actionsButton setBackgroundImage: [UIImage imageNamed:@"Actions.png"] forState:UIControlStateNormal];
        [actionsButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0,0)];
        [actionsButton setTitle:NSLocalizedString(@"Menu.More",@"More...") forState:UIControlStateNormal];
        actionsButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [actionsButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [actionsButton setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
        [actionsButton addTarget:self action:@selector(actionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionsButton];
        leftButtonX=leftButtonX+btnWidth;
    }
    
    if(correspondence.Locked==YES){
        [lockButton setBackgroundImage: [UIImage imageNamed:@"Unlock.png"] forState:UIControlStateNormal];
        [lockButton setBackgroundImage: [UIImage imageNamed:@"Lock.png"] forState:UIControlStateSelected];
        [lockButton setTitle:NSLocalizedString(@"Menu.Unlock",@"unlock") forState:UIControlStateNormal];
        
    }
    else{ [lockButton setBackgroundImage: [UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
        [lockButton setBackgroundImage: [UIImage imageNamed:@"Unlock.png"] forState:UIControlStateSelected];
        [lockButton setTitle:NSLocalizedString(@"Menu.Lock",@"lock") forState:UIControlStateNormal];
        
    }

}

-(void) updateTitleWithLocation:(NSString*)location withName:(NSString*)name{
    [lblTitle setText:[NSString stringWithFormat:@"LOCATION: %@   TITLE: %@",location,name]];
}


//- (void)doneButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self doneButton:button];
//}
//
//- (void)thumbsButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self thumbsButton:button];
//}
//
//- (void)printButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self printButton:button];
//}
//
//- (void)emailButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self emailButton:button];
//}
//
//- (void)markButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self markButton:button];
//}

@end
