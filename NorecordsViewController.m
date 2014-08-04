//
//  NorecordsViewController.m
//  CTSIpad
//
//  Created by EVER-ME EME on 5/8/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "NorecordsViewController.h"
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

@interface NorecordsViewController ()

@end

@implementation NorecordsViewController{
    AppDelegate *mainDelegate;
    BOOL blinkStatus;
    UILabel *noRecords;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    userlabel.text = [userlabel.text uppercaseString];
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
    
    
    
    noRecords = [[UILabel alloc] initWithFrame:CGRectMake(180, 220, 500, 40)];
    //noRecords.font =[UIFont fontWithName:@"AppleGothic" size:25.0f];
    noRecords.font =[UIFont fontWithName:@"Helvetica-Bold" size:25.0f];
    noRecords.text = [[NSString alloc] initWithFormat:@"No %@ To Display",((CMenu*)mainDelegate.user.menu[mainDelegate.selectedInbox-1]).name];
    
    noRecords.shadowColor = [UIColor colorWithRed:0.0f / 255.0f green:155.0f / 255.0f blue:213.0f / 255.0f alpha:1.0];
    noRecords.shadowOffset = CGSizeMake(0.0, 1.0);
    noRecords.textColor = [UIColor whiteColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
    [self.view addSubview:noRecords];
	[SVProgressHUD dismiss];
    
	// Do any additional setup after loading the view.
}

-(void)blink{
    if(blinkStatus == NO){
        noRecords.textColor = [UIColor colorWithRed:0.0f/255.0f green:155.0f/255.0f blue:213.0f/255.0f alpha:1.0];
        blinkStatus = YES;
    }
    else{
        noRecords.textColor = [UIColor whiteColor];
        blinkStatus = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
