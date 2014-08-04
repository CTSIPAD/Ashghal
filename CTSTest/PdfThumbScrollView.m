//
//  PdfThumbScrollView.m
//  iBoard
//
//  Created by DNA on 10/30/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "PdfThumbScrollView.h"

//#import "ThumbsViewController.h"
//#import "ReaderMainToolbar.h"
//#import "ReaderMainPagebar.h"
//#import "ReaderContentView.h"
//#import "ReaderThumbCache.h"
//#import "ReaderThumbQueue.h"
#import "CAttachment.h"
#import "CCorrespondence.h"
#import "CFolder.h"
#import "NSData+Base64.h"

@interface PdfThumbScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation PdfThumbScrollView
{
	CCorrespondence *correspondence;
    
    
	NSMutableDictionary *contentViews;
    
	UIPrintInteractionController *printInteraction;
    
	NSInteger currentPage;
    
    NSInteger positionX;
    
	CGSize lastAppearSize;
    
	NSDate *lastHideTime;
    
	BOOL isVisible;
    NSInteger count;
}
#pragma mark Constants

#define PAGING_VIEWS 4
#define PAGE_WIDTH 172
#define PAGE_SPACE 10
//#define TOOLBAR_HEIGHT 44.0f
//#define PAGEBAR_HEIGHT 48.0f

//#define TAP_AREA_SIZE 48.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // assert(document != nil); // Must have a valid ReaderDocument
        
      //  self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        self.backgroundColor =[UIColor blackColor];
       // CGRect viewRect = self.bounds; // View controller's view bounds
        
      
        self.scrollsToTop = NO;
        self.pagingEnabled = NO;
        self.delaysContentTouches = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.autoresizesSubviews = NO;
        self.delegate = self;
        
       
        
              contentViews = [NSMutableDictionary new]; lastHideTime = [NSDate date];
    }
    
   

    return self;
}





#pragma mark Properties

@synthesize delegate;

#pragma mark Support methods

- (void)updateScrollViewContentSize
{

        count=correspondence.attachmentsList.count;
    
	//if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit
    
	CGFloat contentHeight = self.bounds.size.height;
    
	CGFloat contentWidth = ((PAGE_WIDTH +PAGE_SPACE)* count);
    
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

//- (void)updateScrollViewContentViews
//{
//	[self updateScrollViewContentSize]; // Update the content size
//    
//	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
//    
//	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
//     ^(id key, id object, BOOL *stop)
//     {
//         ReaderContentView *contentView = object; [pageSet addIndex:contentView.tag];
//     }
//     ];
//    
//	__block CGRect viewRect = CGRectZero; viewRect.size = self.bounds.size;
//    
//	__block CGPoint contentOffset = CGPointZero; NSInteger page = document.pagenumber;
//    
//	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
//     ^(NSUInteger number, BOOL *stop)
//     {
//         NSNumber *key = [NSNumber numberWithInteger:number]; // # key
//         
//         ReaderContentView *contentView = [contentViews objectForKey:key];
//         
//         contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;
//         
//         viewRect.origin.x += viewRect.size.width; // Next view frame position
//     }
//     ];
//    
//	if (CGPointEqualToPoint(self.contentOffset, contentOffset) == false)
//	{
//		self.contentOffset = contentOffset; // Update content offset
//	}
//}



- (void)showDocumentAttachments
{
    CGRect viewRect=CGRectZero;
    positionX=5;
  
		NSInteger minValue; NSInteger maxValue;
		NSInteger maxPage = correspondence.attachmentsList.count;
		NSInteger minPage = 1;
        

			minValue = minPage;
			maxValue = maxPage;

       
        
		for (NSInteger number = minValue-1; number <= maxValue-1; number++)
		{
             viewRect = CGRectMake(positionX, 10, PAGE_WIDTH, self.bounds.size.height-20);
            positionX=positionX+PAGE_WIDTH+PAGE_SPACE;
           
           
           
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key
            
			UIView* viewcontainer= [contentViews objectForKey:key];
            UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1;
			if (viewcontainer == nil) // Create a brand new document content view
			{
				//NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
                viewcontainer=[[UIView alloc]initWithFrame:viewRect];
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewcontainer.frame.size.width, viewcontainer.frame.size.height)];
                UIView* titleContainerView=[[UIView alloc]initWithFrame:CGRectMake(0,viewcontainer.frame.size.height-150, viewcontainer.frame.size.width,150)];
                
                UILabel* lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(2, viewcontainer.frame.size.height-30, viewcontainer.frame.size.width-4,30)];
                 lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
                lblTitle.textColor=[UIColor whiteColor];
                titleContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thumb.png"]];
                
                lblTitle.backgroundColor=[UIColor clearColor];
				
                viewcontainer.tag=number;
                imageView.userInteractionEnabled=YES;
         
                [viewcontainer addGestureRecognizer:singleTapOne];
                CAttachment *FILE=correspondence.attachmentsList[number];
                lblTitle.text=FILE.location;
                NSData * data = [NSData dataWithBase64EncodedString:FILE.thumbnailBase64];
               
                UIImage *cellImage = [UIImage imageWithData:data];
                [imageView setImage:cellImage];
                [viewcontainer addSubview:imageView];
                [viewcontainer addSubview:titleContainerView];
                
                [viewcontainer addSubview:lblTitle];
				[self addSubview:viewcontainer];
                [contentViews setObject:viewcontainer forKey:key];
                
				//contentView.message = self;
            //[newPageSet addIndex:number];
			}
			else // Reposition the existing content view
			{
				viewcontainer.frame = viewRect;
                
				//[unusedViews removeObjectForKey:key];
			}
            
			viewRect.origin.x += viewRect.size.width;
		}
    

}



- (void)showDocument:(id)object
{
	[self updateScrollViewContentSize]; // Set content size
    
	[self showDocumentAttachments];
    
	//document.lastOpen = [NSDate date]; // Update last opened date
    
	isVisible = YES; // iOS present modal bodge
}

#pragma mark UIViewController methods

- (void)createReaderDocument:(CCorrespondence *)object
{
	id reader = nil; // ReaderViewController object
    
	if (object != nil)
	{
		
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            
			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillTerminateNotification object:nil];
            
			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillResignActiveNotification object:nil];
            
			//[object updateProperties];
            correspondence = object; // Retain the supplied ReaderDocument object for our use
            
			//[ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
            
			reader = self; // Return an initialized ReaderViewController object
		//}
	}
//    if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
//	{
//		if (CGSizeEqualToSize(lastAppearSize, self.bounds.size) == false)
//		{
//			[self updateScrollViewContentViews]; // Update content views
//		}
//        
//		lastAppearSize = CGSizeZero; // Reset view size tracking
//	}
    
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) // First time
	{
		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
	}
    
    
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
}



//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//    
//	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
//	{
//		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
//		{
//			[self updateScrollViewContentViews]; // Update content views
//		}
//        
//		lastAppearSize = CGSizeZero; // Reset view size tracking
//	}
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//	[super viewDidAppear:animated];
//    
//	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero)) // First time
//	{
//		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
//	}
//    
//#if (READER_DISABLE_IDLE == TRUE) // Option
//    
//	[UIApplication sharedApplication].idleTimerDisabled = YES;
//    
//#endif // end of READER_DISABLE_IDLE Option
//}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (isVisible == NO) return; // iOS present modal bodge
    
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		if (printInteraction != nil) [printInteraction dismissAnimated:NO];
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if (isVisible == NO) return; // iOS present modal bodge
    
	//[self updateScrollViewContentViews]; // Update content views
    [self updateScrollViewContentSize];
	lastAppearSize = CGSizeZero; // Reset view size tracking
}

/*
 - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
 {
 //if (isVisible == NO) return; // iOS present modal bodge
 
 //if (fromInterfaceOrientation == self.interfaceOrientation) return;
 }
 */


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	__block NSInteger page = 0;
    
	CGFloat contentOffsetX = scrollView.contentOffset.x;
    
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
     ^(id key, id object, BOOL *stop)
     {
         UIImageView *imageview = object;
         
         if (imageview.frame.origin.x == contentOffsetX)
         {
             page = imageview.tag; *stop = YES;
         }
     }
     ];
    
	if (page != 0) [self showDocumentAttachments]; // Show the page
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	//[self showDocumentPage:self.tag]; // Show page
    
	//self.tag = 0; // Clear page number tag
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
	return YES;
   
}

#pragma mark UIGestureRecognizer action methods

//- (void)decrementPageNumber
//{
//	if (self.tag == 0) // Scroll view did end
//	{
//		NSInteger page = [document.pageNumber integerValue];
//		NSInteger maxPage = [document.pageCount integerValue];
//		NSInteger minPage = 1; // Minimum
//        
//		if ((maxPage > minPage) && (page != minPage))
//		{
//			CGPoint contentOffset = self.contentOffset;
//            
//			contentOffset.x -= self.bounds.size.width; // -= 1
//            
//			[self setContentOffset:contentOffset animated:YES];
//            
//			self.tag = (page - 1); // Decrement page number
//		}
//	}
//}
//
//- (void)incrementPageNumber
//{
//	if (self.tag == 0) // Scroll view did end
//	{
//		NSInteger page = [document.pageNumber integerValue];
//		NSInteger maxPage = [document.pageCount integerValue];
//		NSInteger minPage = 1; // Minimum
//        
//		if ((maxPage > minPage) && (page != maxPage))
//		{
//			CGPoint contentOffset = self.contentOffset;
//            
//			contentOffset.x += self.bounds.size.width; // += 1
//            
//			[self setContentOffset:contentOffset animated:YES];
//            
//			self.tag = (page + 1); // Increment page number
//		}
//	}
//}
//
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		//CGRect viewRect = recognizer.view.bounds; // View bounds
        
		//CGPoint point = [recognizer locationInView:recognizer.view];
        NSLog(@"%d",recognizer.view.tag);
        if ([self.delegate respondsToSelector:@selector(scrollView:file:)]) {
           [self.delegate scrollView:self file:recognizer.view.tag];
        }

        

        
//	//	CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area
//        
//		//if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
//	//	{
//			NSInteger page = [document.pageNumber integerValue]; // Current page #
//            
//			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
//            
//			ReaderContentView *targetView = [contentViews objectForKey:key];
//            
//			id target = [targetView processSingleTap:recognizer]; // Target
//            
//			if (target != nil) // Handle the returned target object
//			{
//				if ([target isKindOfClass:[NSURL class]]) // Open a URL
//				{
//					NSURL *url = (NSURL *)target; // Cast to a NSURL object
//                    
//					if (url.scheme == nil) // Handle a missing URL scheme
//					{
//						NSString *www = url.absoluteString; // Get URL string
//                        
//						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
//						{
//							NSString *http = [NSString stringWithFormat:@"http://%@", www];
//                            
//							url = [NSURL URLWithString:http]; // Proper http-based URL
//						}
//					}
//                    
//					if ([[UIApplication sharedApplication] openURL:url] == NO)
//					{
//#ifdef DEBUG
//                        NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
//#endif
//					}
//				}
//				else // Not a URL, so check for other possible object type
//				{
//					if ([target isKindOfClass:[NSNumber class]]) // Goto page
//					{
//						NSInteger value = [target integerValue]; // Number
//                        
//						[self showDocumentPage:value]; // Show the page
//					}
//				}
//			}
//			else // Nothing active tapped in the target content view
//			{
//				if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
//				{
//					if ((mainToolbar.hidden == YES) || (mainPagebar.hidden == YES))
//					{
//						[mainToolbar showToolbar]; [mainPagebar showPagebar]; // Show
//					}
//				}
//			}
        
			return;
		}
        
//		//CGRect nextPageRect = viewRect;
//		nextPageRect.size.width = TAP_AREA_SIZE;
//		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
//        
//		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
//		{
//			[self incrementPageNumber]; return;
//		}
//        
//		CGRect prevPageRect = viewRect;
//		prevPageRect.size.width = TAP_AREA_SIZE;
//        
//		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
//		{
//			[self decrementPageNumber]; return;
//		}
	//}
}

//- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
//{
//	if (recognizer.state == UIGestureRecognizerStateRecognized)
//	{
//		CGRect viewRect = recognizer.view.bounds; // View bounds
//        
//		CGPoint point = [recognizer locationInView:recognizer.view];
//        
//		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
//        
//		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
//		{
//			NSInteger page = [document.pageNumber integerValue]; // Current page #
//            
//			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
//            
//			ReaderContentView *targetView = [contentViews objectForKey:key];
//            
//			switch (recognizer.numberOfTouchesRequired) // Touches count
//			{
//				case 1: // One finger double tap: zoom ++
//				{
//					[targetView zoomIncrement]; break;
//				}
//                    
//				case 2: // Two finger double tap: zoom --
//				{
//					[targetView zoomDecrement]; break;
//				}
//			}
//            
//			return;
//		}
//        
//		CGRect nextPageRect = viewRect;
//		nextPageRect.size.width = TAP_AREA_SIZE;
//		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
//        
//		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
//		{
//			[self incrementPageNumber]; return;
//		}
//        
//		CGRect prevPageRect = viewRect;
//		prevPageRect.size.width = TAP_AREA_SIZE;
//        
//		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
//		{
//			[self decrementPageNumber]; return;
//		}
//	}
//}

#pragma mark ReaderContentViewDelegate methods

//- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
//{
//	if ((mainToolbar.hidden == NO) || (mainPagebar.hidden == NO))
//	{
//		if (touches.count == 1) // Single touches only
//		{
//			UITouch *touch = [touches anyObject]; // Touch info
//            
//			CGPoint point = [touch locationInView:self]; // Touch location
//            
//		//	CGRect areaRect = CGRectInset(self.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);
//            
//		//	if (CGRectContainsPoint(areaRect, point) == false) return;
//		}
//        
//		[mainToolbar hideToolbar]; [mainPagebar hidePagebar]; // Hide
//        
//		lastHideTime = [NSDate date];
//	}
//}

#pragma mark ReaderMainToolbarDelegate methods

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
//{
//#if (READER_STANDALONE == FALSE) // Option
//    
//	[document saveReaderDocument]; // Save any ReaderDocument object changes
//    
//	[[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:document.guid];
//    
//	[[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache
//    
//	if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss
//    
//	//if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
//	//{
//	//	[delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
//	//}
//	//else // We have a "Delegate must respond to -dismissReaderViewController: error"
//	//{
//	//	NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
//	//}
//    
//#endif // end of READER_STANDALONE Option
//}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button
//{
//	if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss
//    
//	ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:document];
//    
//	thumbsViewController.delegate = self; thumbsViewController.title = self.title;
//    
//	thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//	thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//    
//	[self presentModalViewController:thumbsViewController animated:NO];
//}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button
//{
//#if (READER_ENABLE_PRINT == TRUE) // Option
//    
//	Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
//    
//	if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
//	{
//		NSURL *fileURL = document.fileURL; // Document file URL
//        
//		printInteraction = [printInteractionController sharedPrintController];
//        
//		if ([printInteractionController canPrintURL:fileURL] == YES) // Check first
//		{
//			UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
//            
//			printInfo.duplex = UIPrintInfoDuplexLongEdge;
//			printInfo.outputType = UIPrintInfoOutputGeneral;
//			printInfo.jobName = document.fileName;
//            
//			printInteraction.printInfo = printInfo;
//			printInteraction.printingItem = fileURL;
//			printInteraction.showsPageRange = YES;
//            
//			if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//			{
//				[printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
//                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
//                 {
//#ifdef DEBUG
//                     if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
//#endif
//                 }
//                 ];
//			}
//			else // Presume UIUserInterfaceIdiomPhone
//			{
//				[printInteraction presentAnimated:YES completionHandler:
//                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
//                 {
//#ifdef DEBUG
//                     if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
//#endif
//                 }
//                 ];
//			}
//		}
//	}
//    
//#endif // end of READER_ENABLE_PRINT Option
//}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button
//{
//#if (READER_ENABLE_MAIL == TRUE) // Option
//    
//	if ([MFMailComposeViewController canSendMail] == NO) return;
//    
//	if (printInteraction != nil) [printInteraction dismissAnimated:YES];
//    
//	unsigned long long fileSize = [document.fileSize unsignedLongLongValue];
//    
//	if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
//	{
//		NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName; // Document
//        
//		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
//        
//		if (attachment != nil) // Ensure that we have valid document file attachment data
//		{
//			MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
//            
//			[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
//            
//			[mailComposer setSubject:fileName]; // Use the document file name for the subject
//            
//			mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//			mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
//            
//			mailComposer.mailComposeDelegate = self; // Set the delegate
//            
//			[self presentModalViewController:mailComposer animated:YES];
//            
//            
//		}
//	}

//#endif // end of READER_ENABLE_MAIL Option
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button
//{
//	if (printInteraction != nil) [printInteraction dismissAnimated:YES];
//    
//	NSInteger page = [document.pageNumber integerValue];
//    
//	if ([document.bookmarks containsIndex:page]) // Remove bookmark
//	{
//		[mainToolbar setBookmarkState:NO]; [document.bookmarks removeIndex:page];
//	}
//	else // Add the bookmarked page index to the bookmarks set
//	{
//		[mainToolbar setBookmarkState:YES]; [document.bookmarks addIndex:page];
//	}
//}

//#pragma mark MFMailComposeViewControllerDelegate methods
//
//- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//#ifdef DEBUG
//    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
//#endif
//    
//	[self dismissModalViewControllerAnimated:YES]; // Dismiss
//}

#pragma mark ThumbsViewControllerDelegate methods

//- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
//{
//	[self updateToolbarBookmarkIcon]; // Update bookmark icon
//    
//	[self dismissModalViewControllerAnimated:NO]; // Dismiss
//}

//- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
//{
//	[self showDocumentPage:page]; // Show the page
//}
//
//#pragma mark ReaderMainPagebarDelegate methods
//
//- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
//{
//	[self showDocumentPage:page]; // Show the page
//}

#pragma mark UIApplication notification methods

- (void)applicationWill:(NSNotification *)notification
{
//	[document saveReaderDocument]; // Save any ReaderDocument object changes
//    
//	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//	{
//		if (printInteraction != nil) [printInteraction dismissAnimated:NO];
//	}
}

@end
