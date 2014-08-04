//
//  ViewController.m
//  CTSTest
//
//  Created by DNA on 12/11/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "HomeViewController.h"
#import "StringEncryption.h"
#import "CParser.h"
#import "CUser.h"
#import "CMenu.h"
#import "CCorrespondence.h"
#import "CAttachment.h"
#import "CSearch.h"
#import "SearchResultViewController.h"
#define TAG_OK 1
#define TAG_NO 2
@interface LoginViewController ()

@end

@implementation LoginViewController
{
    BOOL isChecking;
    AppDelegate *appDelegate;
    UILabel *lblTitle;
    UILabel *lblLogin;
    UILabel *lblPass;
}
@synthesize activityIndicatorObject;
////jis dismiss keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//Dismiss the keyboard.
    [self connect];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(340,40,400,150)];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text =@"EverSuite For iPad";
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font =[UIFont fontWithName:@"Helvetica" size:40.0f];
   // [self.view addSubview:lblTitle];
    
    lblLogin=[[UILabel alloc]initWithFrame:CGRectMake(300,250,200,40)];
    lblLogin.textColor = [UIColor whiteColor];
    lblLogin.text =NSLocalizedString(@"Login",@"Login");
    
    lblLogin.backgroundColor = [UIColor clearColor];
    lblLogin.font =[UIFont fontWithName:@"Helvetica" size:24.0f];
    //[self.view addSubview:lblLogin];
    
    txtUsername=[[UITextField alloc]initWithFrame:CGRectMake(300, 290, 200, 45)];
    txtUsername.layer.borderWidth=2;
    txtUsername.backgroundColor=[UIColor whiteColor];
    txtUsername.layer.borderColor=[[UIColor grayColor] CGColor];
    txtUsername.layer.cornerRadius=10;
    txtUsername.clipsToBounds=YES;
    txtUsername.delegate = self;
    txtUsername.returnKeyType = UIReturnKeyGo;
     txtUsername.leftViewMode = UITextFieldViewModeAlways;
    txtUsername.autocorrectionType=FALSE;

    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 35)];
     txtUsername.leftView= paddingView;
   
    [self.view addSubview:txtUsername];
    
    lblPass=[[UILabel alloc]initWithFrame:CGRectMake(520,250,200,40)];
    lblPass.textColor = [UIColor whiteColor];
    lblPass.text =@"Password";
    
    lblPass.backgroundColor = [UIColor clearColor];
    lblPass.font =[UIFont fontWithName:@"Helvetica" size:24.0f];
   // [self.view addSubview:lblPass];
    
    txtPassword=[[UITextField alloc]initWithFrame:CGRectMake(520, 290, 200, 45)];
    txtPassword.layer.borderWidth=2;
    txtPassword.backgroundColor=[UIColor whiteColor];
    txtPassword.layer.borderColor=[[UIColor grayColor] CGColor];
    txtPassword.layer.cornerRadius=10;
    txtPassword.clipsToBounds=YES;
    txtPassword.delegate = self;
    txtPassword.secureTextEntry=YES;
    txtPassword.returnKeyType = UIReturnKeyGo;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 35)];
     txtPassword.leftView= paddingView2;
    [self.view addSubview:txtPassword];

    btnLogin=[[UIButton alloc]initWithFrame:CGRectMake(440, 360, 150, 40)];
    [btnLogin setTitle:NSLocalizedString(@"Login",@"Login") forState:UIControlStateNormal];
    btnLogin.backgroundColor=[UIColor colorWithRed:37/255.0f green:96/255.0f blue:172/255.0f alpha:1.0];
    
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGFloat red = 0.0f / 255.0f;
    CGFloat green = 155.0f / 255.0f;
    CGFloat blue = 213.0f / 255.0f;
    [btnLogin setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0] forState:UIControlStateHighlighted];
    
    btnLogin.layer.borderColor=[[UIColor grayColor] CGColor];
    btnLogin.layer.cornerRadius=10;
    //btnLogin.clipsToBounds=YES;
    [btnLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
 
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self adjustControls:orientation];
    [self getLicense];
    
    //jen
    activityIndicatorObject=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorObject.center=CGPointMake(517, 420);
    activityIndicatorObject.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self.view addSubview:activityIndicatorObject];
 
    

}



-(void)startIndicator{
    [activityIndicatorObject startAnimating];
}
-(void)stopIndicator{
    [activityIndicatorObject stopAnimating];
}



- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    [self adjustControls:interfaceOrientation];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
	if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginPortrait1.jpg"]];
        
        
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginLandscape1.jpg"]];
        
    }
	
}


-(void)getLicense{
    isChecking=YES;
   // NSString* language=[[[NSBundle mainBundle] preferredLocalizations]objectAtIndex:0];
   	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *active = [prefs stringForKey:@"Activated"];
    NSString *trialDate = [prefs stringForKey:@"trialStartDate"];
    NSString *trialEndDate = [prefs stringForKey:@"trialEndDate"];
    NSString *licenseKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"licenseKey_preference"];
    if([licenseKey length]>0)
    {
        if ([active isEqualToString:@"Active"]) {
            [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            NSString *licenseKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"licenseKey_preference"];
            if([licenseKey isEqualToString:@"MNADNAMNADNA"]){
                [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [self validateKey];
                
            }
        }
    }
    else if ([licenseKey length]==0 && [active length]==0 && [trialDate length]==0) {
    
        alertLicense=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Login.Licence",@"License Key") message:NSLocalizedString(@"Alert.LicenceAlert",@"License Key unavailable,please provide a key or continue as trial") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles:NSLocalizedString(@"Continue",@"Continue"),nil];
        
        alertLicense.tag=TAG_OK;
        //[alertLicense addTextFieldWithValue:@""label:@"License"];
        [alertLicense show];
        // Customise name field
        
    }
    else if([trialDate length]>0 && [trialEndDate length]>0)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        NSDate *myDate = [df dateFromString: trialEndDate];
        
        NSTimeInterval dateDiff=[myDate timeIntervalSinceNow];
        if (dateDiff<0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert",@"Alert") message:NSLocalizedString(@"Alert.Trial" ,@"Trial expired please insert license key in settings menu") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles: nil  ] ;
            [alert show];
        }
        else
        {
             [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    else{
         [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        if(alertView.tag==TAG_NO)
        {
            [alertLicense show];
        }
    }
    else if (buttonIndex == 1)
    {
        if(alertView.tag==TAG_OK)
        {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDate *dt=[NSDate date];
            int daysToAdd = 30;  // or 60 :-)
            NSDate *endDate = [dt dateByAddingTimeInterval:60*60*24*daysToAdd];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
            
            
            
            NSString *stringFromDate = [formatter stringFromDate:dt];
            NSString *stringEndDate= [formatter stringFromDate:endDate];
            [prefs setObject:stringFromDate forKey:@"trialStartDate"];
            [prefs setObject:stringEndDate forKey:@"trialEndDate"];
            [prefs setObject:@"Trial" forKey:@"Activated"];
            //if ([self checkLicense:licenseKey]) {
            // [prefs setObject:licenseKey forKey:@"LicenseKey"];
            [prefs synchronize];
            [btnLogin addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [super viewDidLoad];
                   }
        else
        {
            [alertLicense show];
        }
       
        
    }
}

-(void)validateKey{
    
    recordResults=FALSE;
    CFUUIDRef UIID = CFUUIDCreate(NULL);
    CFStringRef UIIDString = (CFUUIDCreateString(NULL, UIID));
    NSString *deviceId = [NSString stringWithFormat:@"%@",UIIDString];
    //NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
  	NSString *licenseKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"licenseKey_preference"];
   
    NSString *companyName = [[NSUserDefaults standardUserDefaults] stringForKey:@"company_preference"];

    
    NSString *soapMessage=  [NSString stringWithFormat:
                             
                             @" <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "  <soap:Body>"
                             " <iValidate xmlns=\"http://tempuri.org/\">"
                             " <encrSerialId>%@</encrSerialId>"
                             " <encrLicenseKey>%@</encrLicenseKey>"
                             " <encrCompany>%@</encrCompany>"
                             " </iValidate>"
                             " </soap:Body>"
                             " </soap:Envelope>",[self EncryptWord:deviceId],[self EncryptWord:licenseKey],[self EncryptWord:companyName]];
  
    NSURL *url = [NSURL URLWithString:@"http://www.eversuite.net/EverSuiteValidation.asmx"];
    //  NSURL *url = [NSURL URLWithString:@"http://192.168.30.209:8081/esvalidate/EverSuiteValidation.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/iValidate" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
    {
        conWebData = [NSMutableData data];
        NSLog(@"%@",conWebData);
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
}

-(NSString*)EncryptWord:(NSString*) word{

    
    NSString * _key = @"LebanonSurface10452";
	
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData *_secretData = [word dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	
    return [encryptedData base64EncodingWithLineLength:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self connect];
//    //[textField resignFirstResponder];
//    return YES;
//}



-(void)connect{
    @try
    {
    [NSThread detachNewThreadSelector:@selector(startIndicator) toTarget:self withObject:nil];
 
    NSString *username = txtUsername.text;
    NSString *password = txtPassword.text;
    if([username isEqual:@""] == FALSE && [password isEqual:@""] == FALSE)
    {
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString * _key = @"EverTeamYears202020";
        StringEncryption *crypto = [[StringEncryption alloc] init];
        NSData *_secretData = [password dataUsingEncoding:NSUTF8StringEncoding];
        CCOptions padding = kCCOptionPKCS7Padding;
        NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
        NSLog(@"%@",[encryptedData base64EncodingWithLineLength:0]);
        NSString* url = [NSString stringWithFormat:@"http://%@?action=Login&usercode=%@&password=%@",serverUrl,username,[encryptedData base64EncodingWithLineLength:0]];
        
        [self performConnecting:url];
        
//        NSURL *xmlUrl = [NSURL URLWithString:url];
//        
//        NSMutableURLRequest* request=[[NSMutableURLRequest alloc]initWithURL:xmlUrl];
//        [request addValue:username forHTTPHeaderField:@"usercode"];
//        [request addValue:password forHTTPHeaderField:@"password"];
//        
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            if(connection)
//            {
//          //  NSMutableData* receivedData=[NSMutableData data];
//                [self performSelectorOnMainThread:@selector(increaseProgress) withObject:nil waitUntilDone:YES];
//                [connection start];
//            }
//            else
//            {
//                [self ShowMessage:NSLocalizedString(@"Alert.Connection",@"Connection not found")];
//            }
    }
    else
    {
        [self ShowMessage:NSLocalizedString(@"Alert.EmptyUser",@"Username or password is Empty")];
        [self stopIndicator];
    }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"LoginViewController" function:@"Connect" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    //jis [self performSelector:@selector(performConnecting:) withObject:data];
//    [self performConnecting:data];
//}

//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//     [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
//}

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
//     [self ShowMessage:NSLocalizedString(@"Alert.Connection",@"Connection not found")];
//}



-(void)performConnecting:(NSString *)url{
    @try{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.ipadLanguage=[[[NSBundle mainBundle] preferredLocalizations]objectAtIndex:0];
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    BOOL isOfflineMode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"offline_mode"] boolValue];

    CUser * user;

        
        
        user = [CParser loadUserWithData:url];
        
        
        
        if(user.firstName == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid user" message:@"Wrong username or password please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            txtUsername.text=@"";
            txtPassword.text=@"";
            [self stopIndicator];
            return;
        }

        
        
        user.loginName=txtUsername.text;
        appDelegate.userLanguage=user.language;
        if([user.serviceType.lowercaseString isEqualToString:@"sharepoint"])
        {
            appDelegate.isSharepoint=YES;
        }
        if(user.menu.count>0)
        {
            NSString *inboxIds=@"";
            if(isOfflineMode)
            {
                for(CMenu *menu in user.menu)
                {
                    inboxIds=[NSString stringWithFormat:@"%@%d,",inboxIds,menu.menuId];
                }
            }
            else
            {
                inboxIds=[NSString stringWithFormat:@"%d",((CMenu*)user.menu[0]).menuId];
            }
            NSLog(@"Before GetCorrespondence");
            
//           NSString* homeUrl = [NSString stringWithFormat:@"http://%@?action=GetCorrespondences&token=%@&inboxIds=%@",serverUrl,user.token,inboxIds];
//            NSURL *xmlUrl = [NSURL URLWithString:homeUrl];
//            NSData *homeXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
//            NSLog(@"After GetCorrespondence");
//            
//                NSLog(@"Before Loading Data");
//
//             NSMutableDictionary *correspondences=[CParser loadCorrespondencesWithData:homeXmlData];
//
//            if(appDelegate.searchModule ==nil){
//                NSString* searchUrl = [NSString stringWithFormat:@"http://%@?action=BuildAdvancedSearch&token=%@",serverUrl,appDelegate.user.token];
//                NSURL *xmlUrl = [NSURL URLWithString:searchUrl];
//                NSData *searchXmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
//                
//                NSString *validationResult=[CParser ValidateWithData:searchXmlData];
//                if(![validationResult isEqualToString:@"OK"]){
//                    [self ShowMessage:validationResult];
//                }
//                else{
//                    
//
//                    appDelegate.searchModule=[CParser loadSearchWithData:searchXmlData];
//                }
//                
//            }
//            
//
//            
//            appDelegate.searchModule.correspondenceList = [correspondences objectForKey:@"1"];
            
//            
//                for (CMenu* menu in user.menu)
//                {
//                    menu.correspondenceList=[correspondences objectForKey:[NSString stringWithFormat:@"%d",menu.menuId]];
//
//                    
//                }

                appDelegate.user=user;
                
                if(isOfflineMode)
                {
                    [self SaveDocsBaskets:user ];
                }
                MainMenuViewController *root = [[MainMenuViewController alloc] init];
            
            
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
            
                appDelegate.menuSelectedItem=0;
                
                UINavigationController *rootNavigation = [[UINavigationController alloc] initWithRootViewController:root];
            
                UINavigationController *detailNavigation = [[UINavigationController alloc] initWithRootViewController:searchResultViewController];
            
                appDelegate.splitViewController.delegate = searchResultViewController;
                appDelegate.splitViewController.viewControllers = [NSArray arrayWithObjects:rootNavigation, detailNavigation, nil];

                
                [appDelegate.window setRootViewController:(UIViewController*)appDelegate.splitViewController];
                [appDelegate.window makeKeyAndVisible];
        }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"LoginViewController" function:@"performConnecting" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
}




-(void)SaveDocsBaskets:(CUser*) user
{
    for(CMenu* inbox in user.menu )
	{
		if (inbox.correspondenceList.count>0)
        {
            for(CCorrespondence* correspondence in inbox.correspondenceList)
            {
                if (correspondence.attachmentsList.count>0)
                {
                    for(CAttachment* doc in correspondence.attachmentsList)
                    {
                        [self saveDocInCache:doc inDirectory:correspondence.Id];
                    }
                }
               // NSLog(@"task name : %@ id : %@ ",task.name,task.tid);
            }
        }
	}
}
-(void)saveDocInCache:(CAttachment*)firstDoc inDirectory:(NSString*)dirName
{
	[firstDoc saveInCacheinDirectory:dirName fromSharepoint:appDelegate.isSharepoint];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        
        const int movementDistance = -50; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else{
        if (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
            const float movementDuration = 0.3f; // tweak as needed
            
            [UIView beginAnimations: @"animateTextField" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            if(up)
                self.view.frame = CGRectOffset(self.view.frame,220, 0);
            else
                self.view.frame = CGRectOffset(self.view.frame,-220, 0);
            
            [UIView commitAnimations];
        }
        if (self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            const float movementDuration = 0.3f; // tweak as needed
            
            [UIView beginAnimations: @"animateTextField" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            if(up)
                self.view.frame = CGRectOffset(self.view.frame, -220, 0);
            else
                self.view.frame = CGRectOffset(self.view.frame, 220, 0);
            
            [UIView commitAnimations];
        }}
    activityIndicatorObject.center=CGPointMake(btnLogin.frame.origin.x+btnLogin.frame.size.width+20,btnLogin.frame.origin.y+20);
    
}

-(void)adjustControls:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginPortrait1.jpg"]];
        //lblTitle.frame=CGRectMake(240,40,400,150);
        // lblLogin.frame=CGRectMake(200,250,200,40);
        txtUsername.frame=CGRectMake(220, 440, 350, 40);
        // lblPass.frame=CGRectMake(420,250,200,40);
        txtPassword.frame=CGRectMake(220, 505, 350, 40);
        btnLogin.frame=CGRectMake(180, 580, 120, 40);
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginLandscape1.jpg"]];
        //lblTitle.frame=CGRectMake(340,40,400,150);
        //lblLogin.frame=CGRectMake(300,250,200,40);
        txtUsername.frame=CGRectMake(350, 450, 350, 40);
        //  lblPass.frame=CGRectMake(520,250,200,40);
        txtPassword.frame=CGRectMake(350, 510, 350, 40);
        btnLogin.frame=CGRectMake(350, 570, 140, 50);
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

- (void)increaseProgress{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress.Connecting",@"Connecting ...") maskType:SVProgressHUDMaskTypeBlack];
}

- (void)dismiss {
	[SVProgressHUD dismiss];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
	return YES;
}

@end
