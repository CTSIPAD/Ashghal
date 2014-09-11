//
//  MainMenuViewController.m
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//
#import "mach/mach.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "CUser.h"
#import "CMenu.h"
#import "CSearch.h"
#import "CParser.h"
#import "HomeViewController.h"
#import "SignatureViewController.h"
#import "SimpleSearchViewController.h"
#import "GDataXMLNode.h"
#import "LoginViewController.h"
#import "SignatureViewController.h"
#import "NorecordsViewController.h"
#import "SearchResultViewController.h"
@interface MainMenuViewController ()
{
    AppDelegate* mainDelegate;
    NSInteger menuItemsCount;
    NSInteger totalMenuItemsCount;
    BOOL canFound;
    UIViewController  *localdetailViewController;
    
}
@end

@implementation MainMenuViewController

#pragma mark Constants
#define ICON_HEIGHT 68
#define ICON_WIDTH 68
#define TITLE_HEIGHT 30


vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

-(void)logMemUsage{
    // compute memory usage and log if different by >= 100k
    static long prevMemUsage = 0;
    long curMemUsage = usedMemory();
    long memUsageDiff = curMemUsage - prevMemUsage;
    
    if (memUsageDiff > 100000 || memUsageDiff < -100000) {
        prevMemUsage = curMemUsage;
        NSLog(@"Memory used %7.1f (%+5.0f), free %7.1f kb", curMemUsage/1000.0f, memUsageDiff/1000.0f, freeMemory()/1000.0f);
        
        
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString *str =[NSString stringWithFormat:@"Memory used %7.1f (%+5.0f), free %7.1f kb", curMemUsage/1000.0f, memUsageDiff/1000.0f, freeMemory()/1000.0f];
        NSString* urlTextEscaped = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* urllog = [NSString stringWithFormat:@"http://%@?action=logtesting&message=%@",serverUrl,urlTextEscaped];
        NSURL *logUrl = [NSURL URLWithString:urllog];
        NSData *logXmlData = [[NSMutableData alloc] initWithContentsOfURL:logUrl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    
    CGFloat redsep = 88.0f / 255.0f;
    CGFloat greensep = 96.0f / 255.0f;
    CGFloat bluesep = 104.0f / 255.0f;
    self.tableView.opaque=NO;
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:redsep green:greensep blue:bluesep alpha:1.0]];
    self.tableView.backgroundColor =[UIColor colorWithRed:redsep green:greensep blue:bluesep alpha:1.0];
    
    
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    menuItemsCount=mainDelegate.user.menu.count;
    totalMenuItemsCount=menuItemsCount+2;//logo+search
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //self.tableView.backgroundColor = [UIColor blackColor];
    
    self.tableView.layer.borderWidth=2;
    self.tableView.layer.borderColor=[[UIColor colorWithRed:redsep green:greensep blue:bluesep alpha:1.0]CGColor];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainDelegate.selectedInbox inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
    return totalMenuItemsCount;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(menuItemsCount>4)
        return (764-20)/6;
    else{
        if(indexPath.section==0)//logo
            return (764-20)/6;
        else  return 764/totalMenuItemsCount;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width-ICON_WIDTH)/2, (cell.frame.size.height-ICON_HEIGHT-30)/2, ICON_WIDTH, ICON_HEIGHT) ];
    UILabel *labelText =[[UILabel alloc] initWithFrame:CGRectMake(10, imageView.frame.size.height+imageView.frame.origin.y+5, cell.frame.size.width-20, TITLE_HEIGHT)];
    labelText.textAlignment=  NSTextAlignmentCenter;
    labelText.textColor=[UIColor whiteColor];
    labelText.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    labelText.layer.shadowOpacity = 0.6;
    labelText.layer.shadowRadius = 2.0;
    labelText.layer.shadowColor = [UIColor blackColor].CGColor;
    labelText.layer.shadowOffset = CGSizeMake(4.0, 2.0);
    labelText.lineBreakMode = NSLineBreakByWordWrapping;
    labelText.numberOfLines = 0;
    UIView *bgColorView = [[UIView alloc] init];
    
    
    NSInteger rowsNumber=totalMenuItemsCount;
    if(indexPath.row==0){//logo
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.backgroundColor = [UIColor blackColor];
        
        //        UIButton *btnSync=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 62, 37, 37)];
        //        [btnSync setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sync.png"]]forState:UIControlStateNormal];
        //        [btnSync addTarget:self action:@selector(performSync) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:btnSync];
        //
        //        //y=42
        //        UIButton *btnSettings=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 62, 37, 37)];
        //        [btnSettings setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings.png"]]forState:UIControlStateNormal];
        //        [btnSettings addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:btnSettings];
        //
        //        //y=82
        //        UIButton *btnLogout=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 62, 37, 37)];
        //        [btnLogout setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Logout.png"]]forState:UIControlStateNormal];
        //        [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:btnLogout];
        
        CGFloat redview = 88.0f / 255.0f;
        CGFloat greenview = 96.0f / 255.0f;
        CGFloat blueview = 104.0f / 255.0f;
        
        
        // UIView *bl = [[UIView alloc] initWithFrame:CGRectMake(5, 55, self.tableView.frame.size.width-10, 64)];
        
        UIView *bl = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width-10, 114)];
        
        
        bl.backgroundColor = [UIColor colorWithRed:redview green:greenview blue:blueview alpha:1.0];
        bl.layer.contents = (id)[UIImage imageNamed:@"Ashghal_logo.jpg"].CGImage;
        //bl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cts_Logo.png"]];
        
        //cell.backgroundColor = [UIColor colorWithRed:redview green:greenview blue:blueview alpha:1.0];
        cell.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:bl];
    }
    else
        if(indexPath.row==rowsNumber-1){//search
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"cts_Search.png"]];
            labelText.text=NSLocalizedString(@"Search",@"Search");
            CGFloat red = 88.0f / 255.0f;
            CGFloat green = 96.0f / 255.0f;
            CGFloat blue = 104.0f / 255.0f;
            cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            
        }
        else {
            CGFloat red = 88.0f / 255.0f;
            CGFloat green = 96.0f / 255.0f;
            CGFloat blue = 104.0f / 255.0f;
            cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            if(indexPath.row == 3){
                NSData * data= [NSData dataWithBase64EncodedString:((CMenu*)mainDelegate.user.menu[indexPath.row-1]).icon];
                UIImage *cellImage = [UIImage imageWithData:data];
                [imageView setImage:cellImage];
                //imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"cts_Inbound.png"]];
            }
            else
                if(indexPath.row==2){
                    NSData * data= [NSData dataWithBase64EncodedString:((CMenu*)mainDelegate.user.menu[indexPath.row-1]).icon];
                    UIImage *cellImage = [UIImage imageWithData:data];
                    [imageView setImage:cellImage];
                    
                    //imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"cts_Outbound.png"]];
                    //                cell.layer.borderWidth = 1;
                    //                cell.layer.borderColor = [[UIColor colorWithRed:redcel green:greencel blue:bluecel alpha:1.0] CGColor];
                }
                else{
                    
                    NSData * data= [NSData dataWithBase64EncodedString:((CMenu*)mainDelegate.user.menu[indexPath.row-1]).icon];
                    UIImage *cellImage = [UIImage imageWithData:data];
                    [imageView setImage:cellImage];
                    //imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"cts_Internal.png"]];
                    
                }
            labelText.text=((CMenu*)mainDelegate.user.menu[indexPath.row-1]).name;
            
            
        }
    //
    //    CGFloat red = 88.0f / 255.0f;
    //    CGFloat green = 96.0f / 255.0f;
    //    CGFloat blue = 104.0f / 255.0f;
    //    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:labelText];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.0f / 255.0f green:155.0f / 255.0f blue:213.0f / 255.0f alpha:1.0];//blue
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    //[self logMemUsage];
    @try{
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        
        BOOL isOfflineMode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"offline_mode"] boolValue];
        if(indexPath.row==0){
        }
        else{
            localdetailViewController = nil;
            
            if(indexPath.row==totalMenuItemsCount-1){
                CMenu* currentInbox=((CMenu*)mainDelegate.user.menu[0]);
                mainDelegate.Inboxselected=currentInbox.menuId;

                mainDelegate.selectedInbox=indexPath.row-1;
                if(mainDelegate.searchModule ==nil){
                    NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=BuildAdvancedSearch&token=%@",serverUrl,mainDelegate.user.token];
                    NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
                    NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
                    
                    NSString *validationResult=[CParser ValidateWithData:searchXmlData];
                    if(![validationResult isEqualToString:@"OK"]){
                        [self ShowMessage:validationResult];
                    }
                    else{
                        
                        
                        mainDelegate.searchModule=[CParser loadSearchWithData:searchXmlData];
                    }
                    
                }
                //    self.navigationController.navigationBarHidden = YES;
                //   self.navigationController.toolbarHidden=YES;
                SimpleSearchViewController *simpleSearchView=[[SimpleSearchViewController alloc] init];
                localdetailViewController=simpleSearchView;
                
                mainDelegate.isBasketSelected = NO;
                UINavigationController *navController=[[UINavigationController alloc] init];
                [navController setNavigationBarHidden:NO animated:YES];
                [navController pushViewController:localdetailViewController animated:YES];
                
                
                NSArray *viewControllers=[[NSArray alloc] initWithObjects:[mainDelegate.splitViewController.viewControllers objectAtIndex:0],navController,nil];
                
                mainDelegate.splitViewController.delegate = (id)self;
                mainDelegate.splitViewController.viewControllers = viewControllers;
            }
            
            else{
                
                
                mainDelegate.isBasketSelected = YES;
                CMenu* currentInbox=((CMenu*)mainDelegate.user.menu[indexPath.row-1]);
                mainDelegate.Inboxselected=currentInbox.menuId;
                mainDelegate.inboxForArchiveSelected = indexPath.row-1;
                
                if(isOfflineMode){
                    canFound=NO;
                    [self ShowMessage:NSLocalizedString(@"Alert.NoTask",@"No Tasks Found")];
                    
                }
                else{
                    [NSThread detachNewThreadSelector:@selector(increaseLoading) toTarget:self withObject:nil];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        
                        NSString* correspondenceUrl = [NSString stringWithFormat:@"http://%@?action=GetCorrespondences&token=%@&inboxIds=%d",serverUrl,mainDelegate.user.token,currentInbox.menuId];
                        NSURL *xmlUrl = [NSURL URLWithString:correspondenceUrl];
                        NSData *menuXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
                        
                        NSMutableDictionary *correspondences=[CParser loadCorrespondencesWithData:menuXmlData];
                        
                        if(mainDelegate.searchModule ==nil){
                            NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=BuildAdvancedSearch&token=%@",serverUrl,mainDelegate.user.token];
                            NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
                            NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
                            
                            NSString *validationResult=[CParser ValidateWithData:searchXmlData];
                            if(![validationResult isEqualToString:@"OK"]){
                                [self ShowMessage:validationResult];
                            }
                            else{
                                
                                
                                mainDelegate.searchModule=[CParser loadSearchWithData:searchXmlData];
                            }
                        }
                        
                        // mainDelegate.searchModule.correspondenceList = [CParser loadSearchCorrespondencesWithData:menuXmlData];
                        
                        mainDelegate.searchModule.correspondenceList = [correspondences objectForKey:[NSString stringWithFormat:@"%ld",(long)currentInbox.menuId]];
                        
                        
                        
                        ((CMenu*)mainDelegate.user.menu[indexPath.row-1]).correspondenceList=[correspondences objectForKey:[NSString stringWithFormat:@"%d",currentInbox.menuId]];
                        
                        
                        
                        if(((CMenu*)mainDelegate.user.menu[indexPath.row-1]).correspondenceList.count ==0){
                            canFound=NO;
                            NorecordsViewController *norecordsView=[[NorecordsViewController alloc] init];
                            localdetailViewController=norecordsView;
                            UINavigationController *navController=[[UINavigationController alloc] init];
                            [navController setNavigationBarHidden:YES animated:NO];
                            [navController pushViewController:localdetailViewController animated:YES];
                            
                            
                            NSArray *viewControllers=[[NSArray alloc] initWithObjects:[mainDelegate.splitViewController.viewControllers objectAtIndex:0],navController,nil];
                            
                            mainDelegate.splitViewController.delegate = (id)self;
                            mainDelegate.splitViewController.viewControllers = viewControllers;
                            mainDelegate.selectedInbox =tableView.indexPathForSelectedRow.row;
                            //[self ShowMessage:NSLocalizedString(@"Alert.NoTask",@"No Tasks Found")];
                            
                        }
                        else{
                            canFound=YES;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(canFound){
                                mainDelegate.selectedInbox=indexPath.row;
                                SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
                                mainDelegate.menuSelectedItem=indexPath.row-1;
                                localdetailViewController=searchResultViewController;
                            }
                            else{
                                
                                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainDelegate.selectedInbox inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                                
                            }
                            
                            UINavigationController *navController=[[UINavigationController alloc] init];
                            [navController setNavigationBarHidden:NO animated:YES];
                            [navController pushViewController:localdetailViewController animated:YES];
                            
                            
                            NSArray *viewControllers=[[NSArray alloc] initWithObjects:[mainDelegate.splitViewController.viewControllers objectAtIndex:0],navController,nil];
                            
                            mainDelegate.splitViewController.delegate = (id)self;
                            mainDelegate.splitViewController.viewControllers = viewControllers;
                            [NSThread detachNewThreadSelector:@selector(dismiss) toTarget:self withObject:nil];
                            
                        });
                        
                    });
                    
                }
                
            }
            
            
        }
    }
    @catch (NSException *ex) {
        
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString *str = @"got_into_exception";
        NSString* urllog = [NSString stringWithFormat:@"http://%@?action=logtesting&message=%@",serverUrl,str];
        NSURL *logUrl = [NSURL URLWithString:urllog];
        NSData *logXmlData = [[NSMutableData alloc] initWithContentsOfURL:logUrl];
        
        [FileManager appendToLogView:@"MainMenuViewController" function:@"didSelectRowAtIndexPath" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    
}

-(void)performSync{
    [self performSelectorOnMainThread:@selector(increaseProgress) withObject:@"" waitUntilDone:YES];
    [self performSelectorInBackground:@selector(synchronization) withObject:nil];
}

-(void)synchronization
{
    
    @try {
        
        if ([mainDelegate.user processPendingActions]) {
            
            //upload signature document
            [self uploadSignatureXml];
            
            //upload pending documents
            [self uploadPendingXml];
            
            
            //reload baskets if no pendings left
            NSString *inboxIds=@"";
            for(CMenu *menu in mainDelegate.user.menu){
                inboxIds=[NSString stringWithFormat:@"%@%d,",inboxIds,menu.menuId];
            }
            
            NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
            NSString* homeUrl = [NSString stringWithFormat:@"http://%@?action=GetCorrespondences&token=%@&inboxIds=%@",serverUrl,mainDelegate.user.token,inboxIds];
            NSURL *xmlUrl = [NSURL URLWithString:homeUrl];
            NSData *homeXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
            
            
            NSMutableDictionary *correspondences=[CParser loadCorrespondencesWithData:homeXmlData];
            for (CMenu* menu in mainDelegate.user.menu)
            {
                menu.correspondenceList=[correspondences objectForKey:[NSString stringWithFormat:@"%d",menu.menuId]];
                
            }
            mainDelegate.selectedInbox =1;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainDelegate.selectedInbox inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:mainDelegate.selectedInbox inSection:0]] ;
            [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
            [self ShowMessage:NSLocalizedString(@"Alert.Connection",@"Connection not found")];
        }
        
        
        
        
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"MainMenuViewController" function:@"synchronization" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    
    
}
-(void)settings{
    SignatureViewController *signatureView = [[SignatureViewController alloc] initWithFrame:CGRectMake(310, 100, 400, 500)];
    signatureView.modalPresentationStyle = UIModalPresentationFormSheet;
    signatureView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:signatureView animated:YES completion:nil];
    signatureView.view.superview.frame = CGRectMake(310, 100, 400, 500); //it's important to do this after presentModalViewController
    // noteView.view.superview.center = self.view.center;
    // transferView.delegate=self;
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
        delegate.selectedInbox=1;
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [delegate.window setRootViewController:(UIViewController*)loginView];
        
        [delegate.window makeKeyAndVisible];
		//[self.navigationController popToRootViewControllerAnimated:YES];
        
		//LoginViewController *loginView=[[LoginViewController alloc]init];
        // [self.navigationController presentViewController:loginView animated:YES completion:nil];
    }
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
        [FileManager appendToLogView:@"MainMenuViewController" function:@"deleteCachedFiles" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
}

-(void)uploadPendingXml{
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentsPath = [documentsDirectory
                                   stringByAppendingPathComponent:@"pending.xml"];
        NSLog(@"%@",documentsPath);
        
        NSLog(@"Saving xml data to %@...", documentsPath);
        
        NSData *fileData= [NSData dataWithContentsOfFile:documentsPath] ;
        // setting up the URL to post to
        
        if(fileData.length !=0){
            NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
            NSString* urlString = [NSString stringWithFormat:@"http://%@",serverUrl];
            
            // setting up the request object now
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            // action parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"UpdateDocument" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            // file
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".xml\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:fileData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            if(returnData.length!=0){
                [FileManager deleteFileName:@"pending.xml"];
            }
        }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"MainMenuViewController" function:@"uploadPendingXml" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    
}

-(void)uploadSignatureXml{
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentsPath = [documentsDirectory
                                   stringByAppendingPathComponent:@"signature.xml"];
        NSLog(@"%@",documentsPath);
        
        NSData *fileData= [NSData dataWithContentsOfFile:documentsPath] ;
        // setting up the URL to post to
        if(fileData.length !=0){
            NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
            NSString* urlString = [NSString stringWithFormat:@"http://%@",serverUrl];
            
            // setting up the request object now
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            
            // action parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"UpdateSignature" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // token parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[mainDelegate.user.token dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // file
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"signatureFile\"; filename=\".xml\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:fileData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if(returnData.length!=0){
                [FileManager deleteFileName:@"signature.xml"];
            }
        }
        
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"MainMenuViewController" function:@"uploadSignatureXml" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
	return YES;
}

- (void)increaseProgress{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Alert.Sync",@"Synchronizing ...") maskType:SVProgressHUDMaskTypeBlack];
}
- (void)increaseLoading{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Alert.Loading",@"Loading ...") maskType:SVProgressHUDMaskTypeBlack];
}

- (void)dismiss {
	[SVProgressHUD dismiss];
}

@end
