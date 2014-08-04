//
//  HomeViewController.m
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CUser.h"
#import "PdfGalleryCollectionViewCell.h"
#import "PdfThumbScrollView.h"
#import "CFolder.h"
#import "CAttachment.h"
#import "CCorrespondence.h"
#import "CParser.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "CMenu.h"
#import "MainMenuViewController.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSInteger page;
    NSInteger pages;
    NSInteger itemsNum;
    NSInteger itemsCount;
    NSInteger selectedItem;
    AppDelegate *mainDelegate;
    PdfThumbScrollView *attachmentsScrollView;
    UILabel *maskLabel;
    UILabel *pageNumberLabel;
    UIView *pageNumberView;
}

# define SECTION_ITEMS_NUM_PORTRAIT 4
# define SECTION_ITEMS_NUM_LANDSCAPE 4
#define PAGE_HEIGHT_LANDSCAPE 245
#define PAGE_HEIGHT_PORTRAIT 320
#define PAGE_NUMBER_WIDTH 96.0f
#define PAGE_NUMBER_HEIGHT 30.0f

static NSString *CellIdentifier;

//-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
//    return NO;
//}

-(void)deleteCachedFiles{
    
    @try{
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // TEMPORARY PDF PATH
        // Get the Caches directory
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSError *error = nil;
        for (NSString *file in [fm contentsOfDirectoryAtPath:cachesDirectory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", cachesDirectory, file] error:&error];
            if (!success || error) {
                // it failed.
                NSLog(@"%@",error);
            }
        }
        for (NSString *file in [fm contentsOfDirectoryAtPath:documentsDirectory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, file] error:&error];
            if (!success || error) {
                // it failed.
                NSLog(@"%@",error);
            }
        }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"HomeViewController" function:@"deleteCachedFiles" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
}

-(void)logout{
    NSString* message;
    message=NSLocalizedString(@"root.disconnectdialog",@"Do you really want to disconnect ?");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"root.disconnect",@"Sign out")
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"root.disconnect.NO",@"Stay Connected" )
                                          otherButtonTitles:NSLocalizedString(@"root.disconnect.YES",@"Sign Out" ),nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        
    }
    else if (buttonIndex == 1)
    {
        [self deleteCachedFiles];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.user=nil;
        delegate.searchModule=nil;
        delegate.selectedInbox=0;
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [delegate.window setRootViewController:(UIViewController*)loginView];
        
        [delegate.window makeKeyAndVisible];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
        //LoginViewController *loginView=[[LoginViewController alloc]init];
        // [self.navigationController presentViewController:loginView animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //jis toolbar
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width+90, 51);
    CGFloat red = 88.0f / 255.0f;
    CGFloat green = 96.0f / 255.0f;
    CGFloat blue = 104.0f / 255.0f;
    toolbar.layer.borderWidth = 2;
    toolbar.layer.borderColor = [[UIColor colorWithRed:red green:green blue:blue alpha:1.0]CGColor];

    toolbar.barTintColor = [UIColor blackColor];
    
    UILabel *userlabel =[[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 44)];
    userlabel.text = [NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName];
    userlabel.frame = CGRectMake(10, 0, 400, 60);
    userlabel.textColor = [UIColor whiteColor];
    userlabel.shadowColor = [UIColor colorWithRed:0.0f / 255.0f green:155.0f / 255.0f blue:213.0f / 255.0f alpha:1.0];
    //userlabel.shadowOffset = CGSizeMake(0.0, 2.0);
    userlabel.font =[UIFont fontWithName:@"Helvetica" size:20.0f];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:userlabel];
    
    
    UIBarButtonItem *separator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    separator.width = 270;
    
    UIButton *btnLogout=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 62, 37, 37)];
    [btnLogout setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Logout.png"]]forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemlogout = [[UIBarButtonItem alloc] initWithCustomView:btnLogout];
    toolbar.items = [NSArray arrayWithObjects:separator,item,itemlogout, nil];
    
    
    
    

    
    [self.view addSubview:toolbar];
    
    
    //end jis toolbar
    [self.navigationController setNavigationBarHidden:TRUE];
    CGFloat numberY ;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        itemsNum=SECTION_ITEMS_NUM_PORTRAIT;
        CellIdentifier = @"CellPortrait";
         numberY = (996 -PAGE_NUMBER_HEIGHT);
    } else {
        itemsNum=SECTION_ITEMS_NUM_LANDSCAPE;
        CellIdentifier = @"CellLandscape";
         numberY = (738 -PAGE_NUMBER_HEIGHT);
    }
    
    
    self.user =mainDelegate.user;
    itemsCount=((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList.count;
    float  numberofPages=((float)itemsCount/itemsNum);
    pages = ceil(numberofPages);
    page=1;

	[self setupCollectionView];
    
    CGFloat numberX = ((self.collectionView.bounds.size.width - PAGE_NUMBER_WIDTH));
    CGRect numberRect = CGRectMake(numberX, numberY, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
    
    pageNumberView = [[UIView alloc] initWithFrame:numberRect]; // Page numbers view
    
    pageNumberView.autoresizesSubviews = NO;
    pageNumberView.userInteractionEnabled = NO;
    pageNumberView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    pageNumberView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    pageNumberView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    pageNumberView.layer.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f].CGColor;
    pageNumberView.layer.shadowPath = [UIBezierPath bezierPathWithRect:pageNumberView.bounds].CGPath;
    pageNumberView.layer.shadowRadius = 2.0f; pageNumberView.layer.shadowOpacity = 1.0f;
    
    CGRect textRect = CGRectInset(pageNumberView.bounds, 4.0f, 2.0f); // Inset the text a bit
    
    pageNumberLabel = [[UILabel alloc] initWithFrame:textRect]; // Page numbers label
    
    pageNumberLabel.autoresizesSubviews = NO;
    pageNumberLabel.autoresizingMask = UIViewAutoresizingNone;
    pageNumberLabel.textAlignment = NSTextAlignmentCenter;
    pageNumberLabel.backgroundColor = [UIColor clearColor];
    pageNumberLabel.textColor = [UIColor whiteColor];
    pageNumberLabel.font = [UIFont systemFontOfSize:16.0f];
    pageNumberLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    pageNumberLabel.shadowColor = [UIColor blackColor];
    pageNumberLabel.adjustsFontSizeToFitWidth = YES;
   // pageNumberLabel.minimumFontSize = 12.0f;
    
    [pageNumberView addSubview:pageNumberLabel]; // Add label view
    
    [self.collectionView addSubview:pageNumberView]; // Add page numbers display view
    
    [self updatePageNumberText:page ofPages:pages];
    self.collectionView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

}

- (void)updatePageNumberText:(NSInteger)pageNum ofPages:(NSInteger)pagesNum
{
    if(pages==0)
        pageNum=0;
    
    NSString *format = NSLocalizedString(@"%d of %d", @"format"); // Format
    
    NSString *number = [NSString stringWithFormat:format, pageNum, pagesNum]; // Text
    
    pageNumberLabel.text = number; // Update the page number label text
    
    pageNumberLabel.tag = page; // Update the last page number tag
	
}
-(void)setupCollectionView {
    [self.collectionView registerClass:[PdfGalleryCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    UISwipeGestureRecognizer *swipeRecognizerLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeRecognizerLeft.direction=UISwipeGestureRecognizerDirectionUp;
    swipeRecognizerLeft.cancelsTouchesInView = NO;
    swipeRecognizerLeft.delaysTouchesEnded=NO;
    [self.view addGestureRecognizer:swipeRecognizerLeft];
    
    UISwipeGestureRecognizer *swipeLeftRecognizerRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeLeftRecognizerRight.direction=UISwipeGestureRecognizerDirectionDown;
    swipeLeftRecognizerRight.cancelsTouchesInView = NO;
    swipeLeftRecognizerRight.delaysTouchesEnded=NO;
    [self.view addGestureRecognizer:swipeLeftRecognizerRight];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark handle gesture methods

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [self TurnPageRight];
        
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        
        [self TurnPageLeft];
        
    }
}

-(void)TurnPageLeft{
    
    if(page>1){
        [attachmentsScrollView removeFromSuperview];
        [maskLabel removeFromSuperview];
        selectedItem=0;
        CATransition *transition = [CATransition animation];
        //[transition setDelegate:self];
        [transition setDuration:0.5f];
        
        
        [transition setSubtype:@"fromBottom"];
        [transition setType:@"pageUnCurl"];
        [self.view.layer addAnimation:transition forKey:@"UnCurlAnim"];
        
        
        page--;
        [self updatePageNumberText:page ofPages:pages];
        [self.collectionView reloadData];
        
    }
    
    
}
-(void)TurnPageRight{
    if(page<pages){
        [attachmentsScrollView removeFromSuperview];
        [maskLabel removeFromSuperview];
        selectedItem=0;
        CATransition *transition = [CATransition animation];
        // [transition setDelegate:self];
        [transition setDuration:0.5f];
        
        
        [transition setSubtype:@"fromBottom"];
        [transition setType:@"pageCurl"];
        [self.view.layer addAnimation:transition forKey:@"CurlAnim"];
        
        
        page++;
        [self updatePageNumberText:page ofPages:pages];
        [self.collectionView reloadData];
    }
}

-(void) handleTapFrom:(UITapGestureRecognizer*) tap{
    
    @try{
    CGPoint tapLocation = [tap locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    CGFloat contentHeight;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        contentHeight = PAGE_HEIGHT_PORTRAIT;
    } else {
        contentHeight = PAGE_HEIGHT_LANDSCAPE;
    }
    
    PdfGalleryCollectionViewCell *cell=(PdfGalleryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGPoint tapLocationInCell=[tap locationInView:cell];
    
    if(tapLocationInCell.x<=30 && tapLocationInCell.y<=30){
        
        
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=IsLockedCorrespondence&token=%@&transferId=%@",serverUrl,mainDelegate.user.token,((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]).TransferId];
        NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
        NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
        NSError *error;
        GDataXMLDocument *doc= [[GDataXMLDocument alloc] initWithData:searchXmlData options:0 error:&error];
        
        NSArray *result = [doc nodesForXPath:@"//Result" error:nil];
        GDataXMLElement *resultXML =  [result objectAtIndex:0];
        NSString* lockedby=[(GDataXMLElement *) [resultXML attributeForName:@"lockedby"] stringValue];
        
        if([lockedby isEqualToString:[NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName]] || [lockedby isEqualToString:@"none"]){
        
        
        if(cell.Locked){
     
            //if(cell.CanOpen){
                ((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]).Locked=NO;
                cell.correspondence=((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]);
                  [cell performLockAction];
            //}
//            else {
//
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tasktable.locked",@"Task is locked")
//                                                                    message:[NSString stringWithFormat:@"%@ %@",cell.LockedBy,NSLocalizedString(@"tasktable.locked.dialog",@"has locked the task.")]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                }
            
        }
        else{
             ((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]).Locked=YES;
//            ((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]).LockedBy=self.user.firstName;
            cell.correspondence=((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item]);
            [cell performLockAction];
        }
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tasktable.locked",@"Task is locked")
                                                            message:[NSString stringWithFormat:@"%@ %@",lockedby,NSLocalizedString(@"tasktable.locked.dialog",@"has locked the task.")]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

    }
    else{
    NSInteger cellTopPointY=cell.frame.origin.y;
    NSInteger cellTopPointX=0;
    //No items were selected before
    if(selectedItem==0){
        maskLabel= [[UILabel alloc] initWithFrame:CGRectMake(cellTopPointX,0,self.collectionView.frame.size.width,self.collectionView.frame.size.height)];
        CGFloat red = 0.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat blue = 0.0f / 255.0f;
        maskLabel.backgroundColor = [UIColor colorWithRed:red green:green  blue:blue  alpha:0.8];
        [self.collectionView addSubview:maskLabel];
        [self.collectionView bringSubviewToFront:cell];
        selectedItem=indexPath.item+1;
        [self GetDocumentAttachments:((page-1)*itemsNum)+indexPath.item PositionY:cellTopPointY PositionX:cellTopPointX PdfPageHeight:contentHeight CellHeight:cell.frame.size.height ];
    }
    else //same item is selected twice
        if(selectedItem==indexPath.item+1){
            [attachmentsScrollView removeFromSuperview];
            [self.collectionView sendSubviewToBack:cell];
            [maskLabel removeFromSuperview];
            
            selectedItem=0;
        }else{
            [attachmentsScrollView removeFromSuperview];
            PdfGalleryCollectionViewCell *lastCell=(PdfGalleryCollectionViewCell *)[self.collectionView  cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedItem-1 inSection:0]];
            [maskLabel removeFromSuperview];
            [self.collectionView sendSubviewToBack:lastCell];
            maskLabel= [[UILabel alloc] initWithFrame:CGRectMake(cellTopPointX,0,self.collectionView.frame.size.width,self.collectionView.frame.size.height)];
            CGFloat red = 0.0f / 255.0f;
            CGFloat green = 0.0f / 255.0f;
            CGFloat blue = 0.0f / 255.0f;
            maskLabel.backgroundColor = [UIColor colorWithRed:red green:green  blue:blue  alpha:0.8];
            [self.collectionView addSubview:maskLabel];
            [self.collectionView bringSubviewToFront:cell];
           [self GetDocumentAttachments:((page-1)*itemsNum)+indexPath.item  PositionY:cellTopPointY PositionX:cellTopPointX PdfPageHeight:contentHeight CellHeight:cell.frame.size.height];
            selectedItem=indexPath.item+1;
            
        }
    }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"HomeViewController" function:@"handleTapFrom" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }

}


#pragma mark collectionView methods

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50,2,2,2);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   
    return 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PdfGalleryCollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CCorrespondence *correspondence=((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[((page-1)*itemsNum)+indexPath.item];
    CAttachment *attachment;
    if(correspondence.attachmentsList.count != 0){
        attachment=correspondence.attachmentsList[0];
    }
    
    cell.Locked=correspondence.Locked;
    cell.Priority=correspondence.Priority;
    cell.New=correspondence.New;
    cell.LockedBy=correspondence.LockedBy;
    cell.CanOpen=correspondence.CanOpen;
    cell.showLocked = correspondence.ShowLocked;
    
  
    for (id key in correspondence.systemProperties) {
        
        NSDictionary *subDictionary = [correspondence.systemProperties objectForKey:key];
     
        NSArray *keys=[subDictionary allKeys];
            NSDictionary *subSubDictionary = [subDictionary objectForKey:[keys objectAtIndex:0]];
        NSArray *subkeys=[subSubDictionary allKeys];
        NSString *value=[subSubDictionary objectForKey:[subkeys objectAtIndex:0]];
        if([[keys objectAtIndex:0] isEqualToString:@"Sender"])
        {
            [cell setSender:value];
        }else if([[keys objectAtIndex:0] isEqualToString:@"Subject"])
        {
            [cell setSubject:value];
        }else if([[keys objectAtIndex:0] isEqualToString:@"Reference"])
        {
            [cell setNumber:value];
        }
        else if([[keys objectAtIndex:0] isEqualToString:@"Date"])
        {
            [cell setDate:value];
        }
    }
 
    [cell setImageThumbnailBase64:attachment.thumbnailBase64];
    [cell updateCell];
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    
    tapGestureRecognizer.delegate = self;
    
    [cell addGestureRecognizer:tapGestureRecognizer];
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(pages==0){
        return 0;
    }else
    if(page==pages){
        
        if(pages==1)
            return itemsCount;
        else{
            // NSLog(@"last secion number items %d",self.itemsCount-(section*self.itemsNum));
            return (itemsCount-((page-1)*itemsNum));
        }
    }else
        return itemsNum;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize;
    
    if(page==pages){
        switch ((itemsCount-((page-1)*itemsNum))) {
            case 1:
                itemSize= CGSizeMake(collectionView.frame.size.width-4, collectionView.frame.size.height-30);
                break;
            case 2:
               itemSize= CGSizeMake(collectionView.frame.size.width-4, collectionView.frame.size.height/2-30);
                break;
            case 3:
                if(indexPath.item==0 || indexPath.item==1)
                itemSize= CGSizeMake((collectionView.frame.size.width/2)-(10/2), (collectionView.frame.size.height/2)-30);
                else  itemSize= CGSizeMake(collectionView.frame.size.width-4, collectionView.frame.size.height/2-30);
                break;
            case 4:
                    itemSize= CGSizeMake((collectionView.frame.size.width/2)-(10/2), (collectionView.frame.size.height/2)-30);
                               break;
            default:
                break;
        }
    }
    else
        itemSize= CGSizeMake((collectionView.frame.size.width/2)-(10/2), (collectionView.frame.size.height/2)-30);
    
    
    
    return itemSize;
}
#pragma mark methods

-(void) GetDocumentAttachments:(NSInteger) documentId PositionY:(NSInteger)positionY PositionX:(NSInteger)positionX PdfPageHeight:(NSInteger)height CellHeight:(NSInteger)cellHeight{
 
    @try{
    CGRect rect=CGRectZero;
    if(positionY ==0){
        if(cellHeight>600){
            rect=CGRectMake(positionX, 0, self.collectionView.frame.size.width,height);
        }else
        rect=CGRectMake(positionX, cellHeight, self.collectionView.frame.size.width,height);
    }
    
    else  rect=CGRectMake(positionX, cellHeight-height+5, self.collectionView.frame.size.width,height);
    attachmentsScrollView = [[PdfThumbScrollView  alloc] initWithFrame:rect];
    attachmentsScrollView.delegate = self;
    
    
    //  if (document != nil)
    //  {
    CCorrespondence *doc;
        doc=((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[documentId];
    
    [attachmentsScrollView createReaderDocument:doc];
    
    [self.collectionView addSubview:attachmentsScrollView];
    [self.collectionView bringSubviewToFront:attachmentsScrollView];
    //  }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"HomeViewController" function:@"GetDocumentAttachments" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    
}

-(ReaderDocument*) OpenPdfReader:(NSString *) pdfPath{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSString *filePath = pdfPath;// [pdfs lastObject];
    assert(filePath != nil); // Path to last PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    return document;
}

-(void)performSelectFile:(NSString*)fileId{
    @try{
    mainDelegate.isSigned = FALSE;
        
    CCorrespondence *correspondence;
    correspondence=((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[selectedItem-1];
    bool openFile=YES;
    if(correspondence.Locked){
        if (!correspondence.CanOpen) {
            openFile=NO;
            [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tasktable.locked",@"Task is locked")
                                                            message:[NSString stringWithFormat: @"%@ %@",correspondence.LockedBy,NSLocalizedString(@"tasktable.locked.dialog",@"has locked the task.")]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
     
    if(openFile){
        //TODO:lock the task
        if(correspondence.New==YES){
        [correspondence performCorrespondenceAction:@"OpenCorrespondence"];
        ((CCorrespondence*)((CMenu*)self.user.menu[mainDelegate.menuSelectedItem]).correspondenceList[selectedItem-1]).New=NO;
        }
        CAttachment *fileToOpen=correspondence.attachmentsList[[fileId integerValue]];
        NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:correspondence.Id fromSharepoint:mainDelegate.isSharepoint];
        //  NSString *tempPdfLocation=[CParser loadPdfFile:fileToOpen.url inDirectory:correspondence.Id];
        
        if(![tempPdfLocation isEqualToString:@""]){
            //jen
//            if([ReaderDocument isPDF:(NSString *)filePath){
            
            if ([ReaderDocument isPDF:tempPdfLocation] == NO) // File must exist
            {
                [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",@"Warning")
                                                                message:NSLocalizedString(@"Alert.Extension",@"Document extension not supported.")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                                      otherButtonTitles:nil, nil];
                [alert show];

            }
            else {
            
            ReaderDocument *document=[self OpenPdfReader:tempPdfLocation];
            //jis signattachment
                
                if([fileId  isEqual: @"0"]){
                    document.isOriginalMail = [NSNumber numberWithInt:1];
                }
                else{
                    document.isOriginalMail = [NSNumber numberWithInt:0];
                }
  
                
            if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
            {
                ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document MenuId:mainDelegate.menuSelectedItem CorrespondenceId:selectedItem-1 AttachmentId:[fileId integerValue]];
               
                readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
                
                //[self.navigationController pushViewController:readerViewController animated:YES];
                
#else // present in a modal view controller
                
                readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentViewController:readerViewController animated:YES completion:^{
                    [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
                }];
                
#endif // DEMO_VIEW_CONTROLLER_PUSH
            }
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",@"Warning")
                                                            message:NSLocalizedString(@"Alert.fileNotFound",@"file not found.")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"HomeViewController" function:@"performSelectFile" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
}
- (void)dismiss {
	[SVProgressHUD dismiss];
}

- (void)scrollView:(PdfThumbScrollView *)scrollView
              file:(NSInteger)fileId{
    
    [self performSelectorOnMainThread:@selector(increaseProgress:) withObject:@"" waitUntilDone:YES];
    [self performSelectorInBackground:@selector(performSelectFile:) withObject:[NSString stringWithFormat:@"%d",fileId]];
    
    }
- (void)increaseProgress:(NSString*)UpdateProgress{
    //progress +=0.1f;
    [SVProgressHUD showWithStatus:@"loading ..." maskType:SVProgressHUDMaskTypeBlack];
    // if(progress < 1.0f)
    
    
    
}


- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
	[self.navigationController popViewControllerAnimated:YES];
    
	[viewController dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    HomeViewController *detailViewController = [[HomeViewController alloc]initWithCollectionViewLayout:flowLayout];
    
    UINavigationController *navController=[[UINavigationController alloc] init];
    [navController setNavigationBarHidden:YES animated:NO];
    [navController pushViewController:detailViewController animated:YES];
    
    
    NSArray *viewControllers=[[NSArray alloc] initWithObjects:[delegate.splitViewController.viewControllers objectAtIndex:0],navController,nil];
    delegate.splitViewController.delegate = detailViewController;
    delegate.splitViewController.viewControllers = viewControllers;
    
}


#pragma mark orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration
{
    [attachmentsScrollView removeFromSuperview];
    [maskLabel removeFromSuperview];
    selectedItem=0;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
   
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        itemsNum=SECTION_ITEMS_NUM_PORTRAIT;
        CellIdentifier = @"CellPortrait";
    } else {
        itemsNum=SECTION_ITEMS_NUM_LANDSCAPE;
        CellIdentifier = @"CellLandscape";
    }
    [self.collectionView registerClass:[PdfGalleryCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
	return YES;
}
@end
