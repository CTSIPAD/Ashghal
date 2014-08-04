//
//  ManageSignatureViewController.m
//  CTSIpad
//
//  Created by DNA on 2/5/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "ManageSignatureViewController.h"
#import "CUser.h"
#import "Base64.h"
#import "NSData-AES.h"

@interface ManageSignatureViewController ()

@end

@implementation ManageSignatureViewController{
    UITextField *txtPin;
    UITextField *txtWidth;
    UITextField *txtHeight;
     UITextField *txtRed;
     UITextField *txtBlue;
     UITextField *txtGreen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (id)initWithFrame:(CGRect)frame
{
    if (self) {

        self.view.layer.cornerRadius=5;
        self.view.clipsToBounds=YES;
        self.view.layer.borderWidth=1.0;
        self.view.layer.borderColor=[[UIColor grayColor]CGColor];
        self.view.backgroundColor= [UIColor colorWithRed:29/255.0f green:29/255.0f  blue:29/255.0f  alpha:1.0];
        UILabel *Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
        Titlelabel.text = NSLocalizedString(@"Signature",@"Signature");
        Titlelabel.textAlignment=NSTextAlignmentCenter;
        Titlelabel.backgroundColor = [UIColor clearColor];
        Titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        Titlelabel.textColor=[UIColor whiteColor];
        [self.view addSubview:Titlelabel];
        
        UILabel *lblPincode=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, frame.size.width-20, 20)];
        lblPincode.text = NSLocalizedString(@"Signature.PinCode",@"Pin Code");
        lblPincode.backgroundColor = [UIColor clearColor];
        lblPincode.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblPincode.textColor=[UIColor whiteColor];
        [self.view addSubview:lblPincode];
        
        txtPin=[[UITextField alloc]initWithFrame:CGRectMake(10, 65, frame.size.width-20, 30)];
        txtPin.backgroundColor = [UIColor whiteColor];
        txtPin.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPin.keyboardType = UIKeyboardTypeNumberPad;
        txtPin.secureTextEntry=YES;
        txtPin.delegate=self;
        [self.view addSubview:txtPin];
        
        UILabel *lblWidth=[[UILabel alloc]initWithFrame:CGRectMake(10, 105, frame.size.width/2-30, 20)];
        lblWidth.text = NSLocalizedString(@"Signature.Width",@"width");
        lblWidth.backgroundColor = [UIColor clearColor];
        lblWidth.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblWidth.textColor=[UIColor whiteColor];
       
        [self.view addSubview:lblWidth];
        
        txtWidth=[[UITextField alloc]initWithFrame:CGRectMake(10, 130, frame.size.width/2-30, 30)];
         txtWidth.backgroundColor = [UIColor whiteColor];
        txtWidth.text=[NSString stringWithFormat:@"%d",100];
         txtWidth.keyboardType = UIKeyboardTypeNumberPad;
        txtWidth.delegate=self;
        [self.view addSubview:txtWidth];
        
        UILabel *lblHeight=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2+20, 105, frame.size.width/2-30, 20)];
        lblHeight.text = NSLocalizedString(@"Signature.Height",@"Height");
        lblHeight.backgroundColor = [UIColor clearColor];
        lblHeight.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblHeight.textColor=[UIColor whiteColor];
        [self.view addSubview:lblHeight];
        
       
        
        txtHeight=[[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/2+20, 130, frame.size.width/2-30, 30)];
         txtHeight.backgroundColor = [UIColor whiteColor];
        txtHeight.keyboardType = UIKeyboardTypeNumberPad;
        txtHeight.text=[NSString stringWithFormat:@"%d",100];
         txtHeight.delegate=self;
        [self.view addSubview:txtHeight];
        
        UILabel *lblColor=[[UILabel alloc]initWithFrame:CGRectMake(10, 180, frame.size.width/2-30, 20)];
        lblColor.text = NSLocalizedString(@"Signature.Color",@"Color");
        lblColor.backgroundColor = [UIColor clearColor];
        lblColor.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblColor.textColor=[UIColor whiteColor];
        [self.view addSubview:lblColor];
        
        UILabel *lblRed=[[UILabel alloc]initWithFrame:CGRectMake(10, 205, frame.size.width/3-30, 20)];
        lblRed.text = NSLocalizedString(@"Signature.Red",@"Red");
        lblRed.backgroundColor = [UIColor clearColor];
        lblRed.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblRed.textColor=[UIColor whiteColor];
        [self.view addSubview:lblRed];
        txtRed=[[UITextField alloc]initWithFrame:CGRectMake(10, 230, frame.size.width/3-30, 30)];
        txtRed.backgroundColor = [UIColor whiteColor];
        txtRed.keyboardType = UIKeyboardTypeNumberPad;
        txtRed.text=[NSString stringWithFormat:@"%d",0];
        txtRed.delegate=self;
        [self.view addSubview:txtRed];
        
        UILabel *lblGreen=[[UILabel alloc]initWithFrame:CGRectMake(10+frame.size.width/3, 205, frame.size.width/3-30, 20)];
        lblGreen.text = NSLocalizedString(@"Signature.Green",@"Green");
        lblGreen.backgroundColor = [UIColor clearColor];
        lblGreen.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblGreen.textColor=[UIColor whiteColor];
        [self.view addSubview:lblGreen];
        txtGreen=[[UITextField alloc]initWithFrame:CGRectMake(10+frame.size.width/3, 230, frame.size.width/3-30, 30)];
        txtGreen.backgroundColor = [UIColor whiteColor];
        txtGreen.keyboardType = UIKeyboardTypeNumberPad;
        txtGreen.text=[NSString stringWithFormat:@"%d",0];
        txtGreen.delegate=self;
        [self.view addSubview:txtGreen];
        
        UILabel *lblBlue=[[UILabel alloc]initWithFrame:CGRectMake(10+(frame.size.width/3)*2, 205, frame.size.width/3-30, 20)];
        lblBlue.text = NSLocalizedString(@"Signature.Blue",@"Blue");
        lblBlue.backgroundColor = [UIColor clearColor];
        lblBlue.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblBlue.textColor=[UIColor whiteColor];
        [self.view addSubview:lblBlue];
        txtBlue=[[UITextField alloc]initWithFrame:CGRectMake(10+(frame.size.width/3)*2, 230, frame.size.width/3-30, 30)];
        txtBlue.backgroundColor = [UIColor whiteColor];
        txtBlue.keyboardType = UIKeyboardTypeNumberPad;
        txtBlue.text=[NSString stringWithFormat:@"%d",0];
        txtBlue.delegate=self;
        [self.view addSubview:txtBlue];
        
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake((frame.size.width-200)/3, 300, 100, 35);
        [closeButton setTitle:NSLocalizedString(@"Close",@"Close") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        closeButton.layer.cornerRadius=5;
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat selectedRed = 52.0f / 255.0f;
        CGFloat selectedGreen = 52.0f / 255.0f;
        CGFloat selectedBlue = 52.0f / 255.0f;
        closeButton.backgroundColor = [UIColor colorWithRed:selectedRed green:selectedGreen blue:selectedBlue alpha:1.0];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveButton.frame = CGRectMake(closeButton.frame.origin.x+100+((frame.size.width-200)/3), 300, 100, 35);
        [saveButton setTitle:NSLocalizedString(@"OK",@"OK") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        saveButton.layer.cornerRadius=5;
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor colorWithRed:selectedRed green:selectedGreen blue:selectedBlue alpha:1.0];
        [self.view addSubview:closeButton];
        [self.view addSubview:saveButton];

        
    }
    
    return self;
}

- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterNoStyle];
    
    NSString * newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSNumber * number = [nf numberFromString:newString];
    
    if (number)
        return YES;
    else
        return NO;
}

- (void)hide
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)disablesAutomaticKeyboardDismissal { return NO; }

-(void)save{
    UIAlertView *alertKO;
    if(txtPin.text.length==0 || txtWidth.text.length==0 ||txtHeight.text.length==0 ||txtBlue.text.length==0 ||txtRed.text.length==0 || txtGreen.text.length==0)
    {
        alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info",@"Info") message:NSLocalizedString(@"Alert.RequiredFields",@"PLease fill all required fields.";) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
        [alertKO show];
        
    }
    else if( ([txtBlue.text integerValue] <0 || [txtBlue.text integerValue]>255) || ([txtRed.text integerValue] <0 || [txtRed.text integerValue]>255) ||([txtGreen.text integerValue] <0 || [txtGreen.text integerValue]>255)){
        alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info",@"Info") message:NSLocalizedString(@"Alert.Colors",@"Color values must be between 0 and 255.";) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
        [alertKO show];
    }
    else{
        
      AppDelegate*  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString* pinCodeVal=appDelegate.user.pincode;
        NSData	*b64DecData = [Base64 decode:pinCodeVal];
        NSString *password = @"CTSEMEIPAD";
        
        NSData *decryptedData = [b64DecData AESDecryptWithPassphrase:password];
        NSString* alertPinTxt=txtPin.text;
        NSString* decryptedStr = [[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding];
        decryptedStr = [decryptedStr stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
        if  ([alertPinTxt isEqualToString:decryptedStr]) {
            [self.delegate tappedSaveSignatureWithWidth:txtWidth.text withHeight:txtHeight.text withRed:txtRed.text withGreen:txtGreen.text withBlue:txtBlue.text];
            [self hide];
            
        }
        else
        {
            UIAlertView *alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert",@"Alert") message:NSLocalizedString(@"Alert.IncorrectPin",@"Incorrect Pin Code") delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
            [alertKO show];
        }
        
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
