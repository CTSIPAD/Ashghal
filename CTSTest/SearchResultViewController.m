//
//  SearchResultViewController.m
//  iBoard
//
//  Created by LBI on 11/14/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ResultTableViewCell.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "CSearch.h"
#import "CParser.h"
#import "CCorrespondence.h"
#import "CAttachment.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController{
    AppDelegate *appDelegate ;
    AppDelegate *mainDelegate ;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
        [FileManager appendToLogView:@"NorecordsViewController" function:@"deleteCachedFiles" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
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
    mainDelegate.attachmentSelected =0;
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
    //userlabel.text = [userlabel.text uppercaseString];
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
    
    
    //end jis toolbar
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar addSubview:toolbar];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden=YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0f / 255.0f green:29.0f / 255.0f blue:29.0f / 255.0f alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchResultCell"];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.searchResult=appDelegate.searchModule;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.correspondenceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"searchResultCell";
    ResultTableViewCell *cell = [[ResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    CCorrespondence *correspondence=self.searchResult.correspondenceList[indexPath.row];
    //jis attachment
    //CAttachment *attachment=correspondence.attachmentsList[0];
    //    CAttachment *attachment;
    //    if(correspondence.attachmentsList.count != 0){
    //        attachment=correspondence.attachmentsList[0];
    //    }
    for (id key in correspondence.systemProperties) {
        
        NSDictionary *subDictionary = [correspondence.systemProperties objectForKey:key];
        NSArray *keys=[subDictionary allKeys];
        NSDictionary *subSubDictionary = [subDictionary objectForKey:[keys objectAtIndex:0]];
        NSArray *subkeys=[subSubDictionary allKeys];
        NSString *value=[subSubDictionary objectForKey:[subkeys objectAtIndex:0]];
        if([[keys objectAtIndex:0] isEqualToString:@"Sender"])
        {
            if([appDelegate.userLanguage.lowercaseString isEqualToString:@"ar"])
                cell.label2.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
            else
                cell.label2.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
        }else if([[keys objectAtIndex:0] isEqualToString:@"Subject"])
        {
            cell.label1.text=value;
        }else if([[keys objectAtIndex:0] isEqualToString:@"Reference"])
        {
            if([appDelegate.userLanguage.lowercaseString isEqualToString:@"ar"])
                cell.label3.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
            else
                cell.label3.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
        }
        else if([[keys objectAtIndex:0] isEqualToString:@"Date"])
        {
            if([appDelegate.userLanguage.lowercaseString isEqualToString:@"ar"])
                cell.label4.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
            else
                cell.label4.text=[NSString stringWithFormat:@"%@: %@",[[subSubDictionary allKeys] objectAtIndex:0],value];
        }
    }
    
    //[cell setImageThumbnailBase64:attachment.thumbnailBase64];
    
    // [cell updateCell];
    if([appDelegate.userLanguage.lowercaseString isEqualToString:@"ar"]){
        cell.label1.textAlignment=NSTextAlignmentRight;
        cell.label2.textAlignment=NSTextAlignmentRight;
        cell.label3.textAlignment=NSTextAlignmentRight;
        cell.label4.textAlignment=NSTextAlignmentRight;
        cell.imageView.frame=CGRectMake(self.view.frame.size.width-122, 3, 119, 119);
        cell.label1.frame=CGRectMake(10, 5, 600, 30);
        cell.label2.frame=CGRectMake(10, 40, 600, 25);
        cell.label3.frame=CGRectMake(10, 65, 600, 20);
        cell.label4.frame=CGRectMake(10, 85, 600, 20);
        
        
    }
    if(indexPath.row % 2 ==0){
        CGFloat red = 53.0f / 255.0f;
        CGFloat green = 53.0f / 255.0f;
        CGFloat blue = 53.0f / 255.0f;
        
        cell.backgroundColor =[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexPath.row;
    button.frame = CGRectMake(cell.frame.origin.x + 650, cell.frame.origin.y + 20, 100, 30);
    
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(correspondence.ShowLocked){
        if(correspondence.Locked){
            [button setImage:[UIImage imageNamed:@"cts_Lock.png"] forState:UIControlStateNormal];
        }
        else{
            [button setImage:[UIImage imageNamed:@"cts_Unlock.png"] forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:button];
    }
    
    
    
    return cell;
}

-(void)performAction:(id)sender{
    NSLog(@"jessy");
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    
    CCorrespondence *correspondence=self.searchResult.correspondenceList[indexPath.row];
    
    
    
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=IsLockedCorrespondence&token=%@&transferId=%@",serverUrl,mainDelegate.user.token,correspondence.TransferId];
    NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
    NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
    NSError *error;
    GDataXMLDocument *doc= [[GDataXMLDocument alloc] initWithData:searchXmlData options:0 error:&error];
    
    NSArray *result = [doc nodesForXPath:@"//Result" error:nil];
    GDataXMLElement *resultXML =  [result objectAtIndex:0];
    NSString* lockedby=[(GDataXMLElement *) [resultXML attributeForName:@"lockedby"] stringValue];
    
    if([lockedby isEqualToString:[NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName]] || [lockedby isEqualToString:@"none"]){
        
        if(correspondence.Locked){
            if([correspondence performCorrespondenceAction:@"UnlockCorrespondence"]){
                correspondence.Locked=NO;
                [sender setImage:[UIImage imageNamed:@"cts_Unlock.png"] forState:UIControlStateNormal];
            }
        }else{
            if([correspondence performCorrespondenceAction:@"LockCorrespondence"]){
                correspondence.Locked=YES;
                mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                correspondence.LockedBy = [NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName];
                [sender setImage:[UIImage imageNamed:@"cts_Lock.png"] forState:UIControlStateNormal];
            }
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mainDelegate.Highlights removeAllObjects];
    [mainDelegate.Notes removeAllObjects];
    mainDelegate.searchSelected = indexPath.row;
    
    CCorrespondence *correspondence=self.searchResult.correspondenceList[indexPath.row];
    
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    
    if(mainDelegate.isBasketSelected){
        
        // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=IsLockedCorrespondence&token=%@&transferId=%@",serverUrl,mainDelegate.user.token,correspondence.TransferId];
        NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
        NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
        NSError *error;
        GDataXMLDocument *doc= [[GDataXMLDocument alloc] initWithData:searchXmlData options:0 error:&error];
        
        NSArray *result = [doc nodesForXPath:@"//Result" error:nil];
        GDataXMLElement *resultXML =  [result objectAtIndex:0];
        NSString* lockedby=[(GDataXMLElement *) [resultXML attributeForName:@"lockedby"] stringValue];
        
        if([lockedby isEqualToString:[NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName]] || [lockedby isEqualToString:@"none"]){
            [self performSelectorOnMainThread:@selector(increaseProgress) withObject:@"" waitUntilDone:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                //if(correspondence.attachmentsList == nil){
                    
                    mainDelegate.corresponenceId = correspondence.Id;
                    mainDelegate.transferId = correspondence.TransferId;
                    mainDelegate.IncomingNotes=[[NSMutableArray alloc]init];
                    mainDelegate.IncomingHighlights=[[NSMutableArray alloc]init];
                    NSString* attachmentUrl = [NSString stringWithFormat:@"http://%@?action=GetAttachments&token=%@&docId=%@",serverUrl,mainDelegate.user.token,correspondence.Id];
                    
                    NSURL *xmlUrl = [NSURL URLWithString:attachmentUrl];
                    NSData *attachmentXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
                    
                    NSMutableArray *attachments=[CParser loadSpecifiqueAttachment:attachmentXmlData];
                    
                    [correspondence setAttachmentsList:attachments];
                //}
                
                
                
                if([correspondence performCorrespondenceAction:@"LockCorrespondence"]){
                    correspondence.Locked=YES;
                    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    correspondence.LockedBy = [NSString stringWithFormat:@"%@ %@",mainDelegate.user.firstName,mainDelegate.user.lastName];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelectorInBackground:@selector(openDocument:) withObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                    
                });
            });
            
            
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
        [self performSelectorOnMainThread:@selector(increaseProgress) withObject:@"" waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            if(correspondence.attachmentsList.count == 0){
                
                mainDelegate.IncomingNotes=[[NSMutableArray alloc]init];
                mainDelegate.IncomingHighlights=[[NSMutableArray alloc]init];
                NSString* attachmentUrl = [NSString stringWithFormat:@"http://%@?action=GetAttachments&token=%@&docId=%@",serverUrl,mainDelegate.user.token,correspondence.Id];
                
                NSURL *xmlUrl = [NSURL URLWithString:attachmentUrl];
                NSData *attachmentXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
                
                NSMutableArray *attachments=[CParser loadSpecifiqueAttachment:attachmentXmlData];
                
                [correspondence setAttachmentsList:attachments];
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelectorInBackground:@selector(openDocument:) withObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                
                
            });
        });
        
        
    }
    
}

-(void)openDocument:(NSString*)documentId{
    @try{
        CCorrespondence *correspondence=self.searchResult.correspondenceList[[documentId integerValue]];
        CAttachment *fileToOpen=correspondence.attachmentsList[0];
        
        NSString *tempPdfLocation=[fileToOpen saveInCacheinDirectory:correspondence.Id fromSharepoint:appDelegate.isSharepoint];
        
        // NSString *tempPdfLocation=[CParser loadPdfFile:fileToOpen.url inDirectory:correspondence.Id];
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
        else{
            ReaderDocument *document=[self OpenPdfReader:tempPdfLocation];
            
            if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
            {
                ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document MenuId:100 CorrespondenceId:[documentId integerValue] AttachmentId:0];
                
                readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                
                
                readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentViewController:readerViewController animated:YES completion:^{
                    [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
                }];
                
            }
        }
    }
    @catch (NSException *ex) {
        NSLog(@"Exception%@",ex);
        [FileManager appendToLogView:@"SearchResultViewController" function:@"openDocument" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    @finally {
        // [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
    }
}

-(ReaderDocument*) OpenPdfReader:(NSString *) pdfPath{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSString *filePath = pdfPath;// [pdfs lastObject];
    assert(filePath != nil); // Path to last PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    return document;
}



- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // delegate.masterSelectedCell=@"Search";
    SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navController=[[UINavigationController alloc] init];
    [navController setNavigationBarHidden:YES animated:NO];
    [navController pushViewController:searchResultViewController animated:YES];
    
    
    
    
    NSArray *viewControllers=[[NSArray alloc] initWithObjects:[delegate.splitViewController.viewControllers objectAtIndex:0],navController,nil];
    delegate.splitViewController.delegate = (id)self;
    delegate.splitViewController.viewControllers = viewControllers;
}



/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsLandscape(orientation))
        return NO;
    else return YES;
}


- (void)increaseProgress{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Alert.Loading",@"Loading ...") maskType:SVProgressHUDMaskTypeBlack];
    
    
}
- (void)dismiss {
	[SVProgressHUD dismiss];
}

@end
