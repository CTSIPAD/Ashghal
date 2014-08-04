//
//  TransferViewController.m
//  CTSTest
//
//  Created by DNA on 1/14/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "TransferViewController.h"
#import "ActionTaskController.h"
#import "AppDelegate.h"
#import "CUser.h"
#import "PMCalendar.h"
#import "CRouteLabel.h"
#import "CDestination.h"

@interface TransferViewController ()

@end

@implementation TransferViewController{
     CGRect _realBounds;
    ActionTaskController* actionController;

    BOOL isDirectionDropDownOpened;
    BOOL isTransferToDropDownOpened;
    UIButton *ddbtnDueDate ;
    CDestination* dest;
    CRouteLabel* routeLabel;
}
@synthesize txtDirection,txtDueDate,txtNote,txtTransferTo,isShown;
@synthesize pmCC;
@synthesize delegate;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.superview.bounds = _realBounds;
}

- (void)viewDidLoad { _realBounds = self.view.bounds; [super viewDidLoad]; }

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
        Titlelabel.text = NSLocalizedString(@"Transfer.TransferCorrespondence",@"Transfer Correspondence");
        Titlelabel.textAlignment=NSTextAlignmentCenter;
        Titlelabel.backgroundColor = [UIColor clearColor];
        Titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        Titlelabel.textColor=[UIColor whiteColor];
        
        UILabel *lblTransferTo = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, frame.size.width-20, 20)];
        lblTransferTo.text = NSLocalizedString(@"Transfer.TransferTo",@"Transfer To");
        lblTransferTo.textAlignment=NSTextAlignmentLeft;
        lblTransferTo.backgroundColor = [UIColor clearColor];
        //lblTransferTo.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblTransferTo.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblTransferTo.textColor=[UIColor whiteColor];
        
        txtTransferTo=[[UITextField alloc]initWithFrame:CGRectMake(10, 70, frame.size.width-20, 30)];
        txtTransferTo.backgroundColor = [UIColor whiteColor];
        UIButton *ddbtnDestination = [UIButton buttonWithType:UIButtonTypeCustom];
        [ddbtnDestination setImage:[UIImage imageNamed:@"dropdown-button.png"] forState:UIControlStateNormal];
        
        ddbtnDestination.frame = CGRectMake(frame.size.width-30, 70, 20, 30);

        [txtTransferTo setUserInteractionEnabled:NO];
        
        //ddbtnDestination.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
        [ddbtnDestination addTarget:self action:@selector(ShowDestinations) forControlEvents:UIControlEventTouchUpInside];
        //txtTransferTo.rightView = ddbtnDestination;
        
        txtTransferTo.rightViewMode = UITextFieldViewModeAlways;
        
        UILabel *lblDirection = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, frame.size.width/2-20, 20)];
        //lblDirection.text = NSLocalizedString(@"Transfer.Direction",@"Direction");
        lblDirection.text = NSLocalizedString(@"Transfer.Purpose",@"Purpose");
        lblDirection.textAlignment=NSTextAlignmentLeft;
        lblDirection.backgroundColor = [UIColor clearColor];
        //lblDirection.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblDirection.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblDirection.textColor=[UIColor whiteColor];
        
        txtDirection=[[UITextField alloc]initWithFrame:CGRectMake(10, 135, frame.size.width/2-20, 30)];
        txtDirection.backgroundColor = [UIColor whiteColor];
        UIButton *ddbtnDirection = [UIButton buttonWithType:UIButtonTypeCustom];
        [ddbtnDirection setImage:[UIImage imageNamed:@"dropdown-button.png"] forState:UIControlStateNormal];
        
        ddbtnDirection.frame = CGRectMake(frame.size.width/2 - 20, 135, 20, 30);
        
        [ddbtnDirection addTarget:self action:@selector(ShowDirections) forControlEvents:UIControlEventTouchUpInside];
        //txtDirection.rightView = ddbtnDirection;
        [txtDirection setUserInteractionEnabled:NO];
        
        txtDirection.rightViewMode = UITextFieldViewModeAlways;
        
        UILabel *lblDueDate = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+10, 110, frame.size.width/2-20, 20)];
        lblDueDate.text = NSLocalizedString(@"Transfer.DueDate",@"DueDate");
        lblDueDate.textAlignment=NSTextAlignmentLeft;
        lblDueDate.backgroundColor = [UIColor clearColor];
        //lblDueDate.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblDueDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblDueDate.textColor=[UIColor whiteColor];
        
        txtDueDate=[[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/2+10, 135, frame.size.width/2-20, 30)];
        txtDueDate.backgroundColor = [UIColor whiteColor];
        ddbtnDueDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [ddbtnDueDate setImage:[UIImage imageNamed:@"dropdown-button.png"] forState:UIControlStateNormal];
        ddbtnDueDate.frame = CGRectMake(frame.size.width-30, 135, 20, 30);
        [ddbtnDueDate addTarget:self action:@selector(ShowCalendar:) forControlEvents:UIControlEventTouchUpInside];
       // txtDueDate.rightView = ddbtnDueDate;
       // txtDueDate.rightViewMode = UITextFieldViewModeAlways;
       
        
        UILabel *lblNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, frame.size.width-20, 20)];
        lblNote.text = NSLocalizedString(@"Transfer.Note",@"Note");
        lblNote.textAlignment=NSTextAlignmentLeft;
        lblNote.backgroundColor = [UIColor clearColor];
        //lblNote.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblNote.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblNote.textColor=[UIColor whiteColor];
        
        txtNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 200, frame.size.width-20, 100)];
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
        saveButton.frame = CGRectMake((frame.size.width-(2*btnWidth +50))/2, 310, btnWidth, 35);
         saveButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        [saveButton setTitle:NSLocalizedString(@"Save",@"Save") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"]){
            lblTransferTo.textAlignment=NSTextAlignmentRight;
            lblDirection.textAlignment=NSTextAlignmentRight;
            lblDueDate.textAlignment=NSTextAlignmentRight;
            lblNote.textAlignment=NSTextAlignmentRight;
        }
        

       
        
        [self.view addSubview:Titlelabel];
        [self.view addSubview:lblTransferTo];
        [self.view addSubview:lblDirection];
        [self.view addSubview:lblDueDate];
        [self.view addSubview:lblNote];
        [self.view addSubview:txtTransferTo];
        [self.view addSubview:ddbtnDestination];
        
         [self.view addSubview:txtDirection];
        [self.view addSubview:ddbtnDirection];
        
         [self.view addSubview:txtDueDate];
        [self.view addSubview:txtNote];
         [self.view addSubview:ddbtnDueDate];
        [self.view addSubview:saveButton];
        [self.view addSubview:closeButton];

       
        
    }
    return self;
}

-(void)ShowDestinations{
    isTransferToDropDownOpened =NO;
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
            isTransferToDropDownOpened =YES;
        }
        
    }
    if (!isTransferToDropDownOpened) {
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CUser* userTemp =  mainDelegate.user;
        actionController = [[ActionTaskController alloc] initWithStyle:UITableViewStyleGrouped];
        actionController.rectFrame=CGRectMake(10, 100, self.view.frame.size.width-20,150) ;
        actionController.isDirection=NO;
        actionController.delegate = self;
        actionController.actions =[NSMutableArray  arrayWithArray:userTemp.destinations];
        [self addChildViewController:actionController];
        [self.view addSubview:actionController.view];
        
    }
}

-(void)ShowDirections{
    isDirectionDropDownOpened=NO;
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
            isDirectionDropDownOpened=YES;
        }
        
    }
    if (!isDirectionDropDownOpened) {
        //jen dropdown
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CUser* userTemp =  mainDelegate.user;
        actionController = [[ActionTaskController alloc] initWithStyle:UITableViewStyleGrouped];
        actionController.rectFrame=CGRectMake(10, 165, self.view.frame.size.width/2-20,150) ;
        actionController.isDirection=YES;
        actionController.delegate = self;
        actionController.actions =[NSMutableArray  arrayWithArray:userTemp.routeLabels];
        [self addChildViewController:actionController];
        [self.view addSubview:actionController.view];
       
    }
   
}

-(IBAction)ShowCalendar:(id)sender{
    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    
     self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = NO;
    [self.pmCC presentCalendarFromView:ddbtnDueDate
              permittedArrowDirections:PMCalendarArrowDirectionUp
                             isPopover:isPopover
                              animated:YES];

self.pmCC.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
[self calendarController:pmCC didChangePeriod:pmCC.period];
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
    //    NSLog(@"hide");
    //    isShown = NO;
    //    [UIView beginAnimations:@"hideAlert" context:nil];
    //    [UIView setAnimationDelegate:self];
    //    self.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    //    self.view.alpha = 0;
    //    [UIView commitAnimations];
    
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
    if(txtDirection.text.length==0 || txtTransferTo.text.length==0 || txtDueDate.text.length==0)
    {
        alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert",@"Alert") message:NSLocalizedString(@"Transfer.Message",@"Please fill all fields.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"OK") otherButtonTitles: nil];
        [alertKO show];
    }
    else{
        //jen transfer loader
        [NSThread detachNewThreadSelector:@selector(increaseLoading) toTarget:self withObject:nil];
        // [self dismissViewControllerAnimated:YES completion:nil];
        [delegate destinationSelected:dest withRouteLabel:routeLabel routeNote:txtNote.text withDueDate:txtDueDate.text viewController:self ] ;
        [NSThread detachNewThreadSelector:@selector(dismiss) toTarget:self withObject:nil];
        //[self hide];
    }
}

#pragma mark delegate methods

-(void)actionSelectedDirection:(CRouteLabel*)route{
    
   
        txtDirection.text=route.name;
    routeLabel=route;

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
        }
        
    }
}
-(void)actionSelectedDestination:(CDestination *)destination{
    
    
    txtTransferTo.text=destination.name;
    
    dest=destination;
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]]){
            [view removeFromSuperview];
        }
        
    }
}


- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *currentDate = [[NSDate date] dateStringWithFormat:@"yyyy-MM-dd"];
    NSString *newPeriodDate = [newPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"];
    if(![newPeriodDate isEqualToString:currentDate])
    {
        txtDueDate.text = [NSString stringWithFormat:@"%@",newPeriodDate];
        
        [pmCC dismissCalendarAnimated:YES];
    }
    
}
-(void)increaseLoading{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Alert.Loading", @"Loading...") maskType:SVProgressHUDMaskTypeBlack];
}
-(void)dismiss{
    [SVProgressHUD dismiss];
}

@end
