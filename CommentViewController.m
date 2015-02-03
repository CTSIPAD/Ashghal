//
//  AcceptWithCommentViewController.m
//  CTSIpad
//
//  Created by DNA on 6/12/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "CommentViewController.h"
#import "ActionTaskController.h"
#import "AppDelegate.h"
#import "CUser.h"
#import "PMCalendar.h"
#import "CRouteLabel.h"
#import "CDestination.h"
#import "SVProgressHUD.h"
#import "CParser.h"
#import "CFPendingAction.h"
#import "CMenu.h"
#import "CSearch.h"
#import "UserDetail.h"
@interface CommentViewController ()

@end

@implementation CommentViewController{
    CGRect _realBounds;
    ActionTaskController* actionController;
    AppDelegate *mainDelegate;
    BOOL isDirectionDropDownOpened;
    BOOL isTransferToDropDownOpened;
    CRouteLabel* routeLabel;
}
@synthesize txtNote,isShown,Action;
@synthesize delegate;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.superview.bounds = _realBounds;
}

- (void)viewDidLoad { _realBounds = self.view.bounds; [super viewDidLoad]; }
- (id)initWithActionName:(CGRect)frame Action:(CAction *)action {
    
        self.Action =action;
    self = [self initWithFrame:frame];

    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        originalFrame = frame;
        // self.view.alpha = 1;
        self.view.layer.cornerRadius=5;
        self.view.clipsToBounds=YES;
        self.view.layer.borderWidth=1.0;
        self.view.layer.borderColor=[[UIColor grayColor]CGColor];
        self.view.backgroundColor= [UIColor colorWithRed:29/255.0f green:29/255.0f  blue:29/255.0f  alpha:1.0];
        UILabel *Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 20)];
        NSString * nameAct=[NSString stringWithFormat:@"%@.%@Correspondence",self.Action.action,self.Action.action];



        Titlelabel.text = NSLocalizedString(nameAct,@"");
        Titlelabel.textAlignment=NSTextAlignmentCenter;
        Titlelabel.backgroundColor = [UIColor clearColor];
        Titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        Titlelabel.textColor=[UIColor whiteColor];
        
      
        
               UILabel *lblNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, frame.size.width-20, 20)];
        lblNote.text = NSLocalizedString(@"Accept.Note",@"Note");
        lblNote.textAlignment=NSTextAlignmentLeft;
        lblNote.backgroundColor = [UIColor clearColor];
        //lblNote.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblNote.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblNote.textColor=[UIColor whiteColor];
        
        txtNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 55, frame.size.width-20, frame.size.height-150)];
        txtNote.font = [UIFont systemFontOfSize:15];
        txtNote.delegate = self;
        
        txtNote.autocorrectionType = UITextAutocorrectionTypeNo;
        txtNote.keyboardType = UIKeyboardTypeDefault;
        txtNote.returnKeyType = UIReturnKeyDone;
        
        
        NSInteger btnWidth=115;
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame =CGRectMake(((frame.size.width-(2*btnWidth +50))/2)+btnWidth+50, 310, btnWidth, 35);
        closeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        [closeButton setTitle:NSLocalizedString(@"Cancel",@"Cancel") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveButton.frame = CGRectMake((frame.size.width-(2*btnWidth +50))/2, 310, btnWidth+20, 35);
        saveButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        [saveButton setTitle:NSLocalizedString(self.Action.action,@"Save") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([mainDelegate.userLanguage.lowercaseString isEqualToString:@"ar"]){
            lblNote.textAlignment=NSTextAlignmentRight;
        }
        
        
        
        
        [self.view addSubview:Titlelabel];
        [self.view addSubview:lblNote];
        
        [self.view addSubview:txtNote];
        [self.view addSubview:saveButton];
        [self.view addSubview:closeButton];
        
        
        
    }
    return self;
}



- (void)show
{
    // NSLog(@"show");
    
    isShown = YES;
    self.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.view.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 12, 1, 1, 1.0);
    self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.view.alpha = 1;
    [UIView commitAnimations];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self hide];
        
        //cancel clicked ...do your action
    }
    else if (buttonIndex == 1)
    {
        //[alertView textFieldAtIndex:0].text
        
    }
}
-(void)clear{
    txtNote.text=@"";
}
- (void)hide
{
  //  [delegate ActionMoveHome:self];//Use to move home

   [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (BOOL)disablesAutomaticKeyboardDismissal { return NO; }

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}




-(void)save{
    UIAlertView *alertKO;
    
    if([self.txtNote.text stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert",@"Alert") message:NSLocalizedString(@"Transfer.Message",@"Please fill the note fields.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"OK") otherButtonTitles: nil];
        [alertKO show];
    }
    else{
        NSString* res=@"";
    [NSThread detachNewThreadSelector:@selector(increaseLoading) toTarget:self withObject:nil];
    if([self.Action.action isEqualToString:@"SignAndSend"]){
        res=[delegate SignAndSendIt:self.Action.action document:self.document note:self.txtNote.text];
    }
    else{
        res=[self executeAction:self.Action.action];
    }
        if([res isEqualToString:@"OK"])
           {
    [self dismissViewControllerAnimated:YES  completion:^{
            [delegate ActionMoveHome:self];
       // [self ShowMessage:@"Action successfuly done."];
    }];
        }
        else{
           // [self ShowMessage:res];
        }
    
    [NSThread detachNewThreadSelector:@selector(dismiss) toTarget:self withObject:nil];
    }

}
-(NSString*)executeAction:(NSString*)action{
    
    @try{
        
        NSString* DelegateToken=@"";
        if(mainDelegate.user.UserDetails.count>0){
            DelegateToken=((UserDetail*)mainDelegate.user.UserDetails[0]).Token;
        }
        else
            DelegateToken=mainDelegate.user.token;
        NSString* params=[NSString stringWithFormat:@"action=ExecuteCustomActions&token=%@&DelegateToken=%@&correspondenceId=%@&docId=%@&actionType=%@&transferId=%@&comment=%@", mainDelegate.user.token,DelegateToken,self.correspondence.Id,self.attachment.docId,action,self.correspondence.TransferId,[self.txtNote.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString* url = [NSString stringWithFormat:@"http://%@?%@",serverUrl,params];
        NSURL *xmlUrl = [NSURL URLWithString:url];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
        NSString *validationResultAction=[CParser ValidateWithData:xmlData];
        
        if(![validationResultAction isEqualToString:@"OK"])
        {
            if([validationResultAction isEqualToString:@"Cannot access to the server"])
            {
                CFPendingAction*pa = [[CFPendingAction alloc] initWithActionUrl:url];
                [mainDelegate.user addPendingAction:pa];
            }else
                
                [self ShowMessage:validationResultAction];
            return validationResultAction;
        }else {
            
            int nb;
            
            NSString *t=((CMenu*)mainDelegate.user.menu[mainDelegate.selectedInbox-1]).name;
            
            if([t isEqual:@"Outgoing Correspondence"]){
                nb=2;
            }
            else{
                if([t isEqual:@"Incoming Correspondence"]){
                    nb=1;
                }
                else{
                    if([t isEqual:@"Internal Correspondence"]){
                        nb=5;
                    }
                    else{
                        if([t isEqual:@"Delivery Notes"]){
                            nb=8;
                        }
                    }
                }
            }
            
            NSString* correspondenceUrl = [NSString stringWithFormat:@"http://%@?action=GetCorrespondences&token=%@&inboxIds=%d",serverUrl,mainDelegate.user.token,nb];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:correspondenceUrl] cachePolicy:0 timeoutInterval:3600];
            NSData *menuXmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            NSURL *xmlUrl = [NSURL URLWithString:correspondenceUrl];
//            NSData *menuXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
            
            NSMutableDictionary *correspondences=[CParser loadCorrespondencesWithData:menuXmlData];
            
            //((CMenu*)mainDelegate.user.menu[mainDelegate.inboxForArchiveSelected]).correspondenceList=[correspondences objectForKey:[NSString stringWithFormat:@"%d",nb]];
            mainDelegate.searchModule.correspondenceList = [correspondences objectForKey:[NSString stringWithFormat:@"%d",nb]];
            
            [self ShowMessage:@"Action successfuly done."];
            
            
            return @"OK";
            
            
        }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"ActionsTableViewController" function:@"executeAction" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
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
#pragma mark delegate methods

-(void)actionSelectedDirection:(CRouteLabel*)route{
    
    
    routeLabel=route;
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
        }
        
    }
}
-(void)actionSelectedDestination:(CDestination *)destination{
    
    
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
        }
        
    }
}

-(void)increaseLoading{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Alert.Loading", @"Loading...") maskType:SVProgressHUDMaskTypeBlack];
}
-(void)dismiss{
    [SVProgressHUD dismiss];
}
@end

