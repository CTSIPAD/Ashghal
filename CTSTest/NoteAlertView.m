//
//  NoteAlertView.m
//  iBoard
//
//  Created by DNA on 11/13/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "NoteAlertView.h"

@implementation NoteAlertView
{
    CGRect _realBounds;
}
@synthesize txtNote,delegate,publicSwitch;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.superview.bounds = _realBounds;
}

- (void)viewDidLoad { _realBounds = self.view.bounds; [super viewDidLoad]; }

- (id)initWithFrame:(CGRect)frame fromComment:(BOOL)isComment
{
       if (self) {
        originalFrame = frame;
       // self.view.alpha = 1;
           self.view.layer.cornerRadius=5;
           self.view.clipsToBounds=YES;
           self.view.layer.borderWidth=1.0;
           self.view.layer.borderColor=[[UIColor grayColor]CGColor];
        self.view.backgroundColor= [UIColor colorWithRed:29/255.0f green:29/255.0f  blue:29/255.0f  alpha:1.0];
        UILabel *Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
        Titlelabel.text = NSLocalizedString(@"Note",@"Note");
        Titlelabel.textAlignment=NSTextAlignmentCenter;
        Titlelabel.backgroundColor = [UIColor clearColor];
        Titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
           Titlelabel.textColor=[UIColor whiteColor];
        
        txtNote = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, 390, 100)];
        txtNote.font = [UIFont systemFontOfSize:15];
           txtNote.delegate = self;

        txtNote.autocorrectionType = UITextAutocorrectionTypeNo;
        txtNote.keyboardType = UIKeyboardTypeDefault;
        txtNote.returnKeyType = UIReturnKeyDone;
       
           if (isComment) {
                UILabel *publiclabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 90, 20)];
                publiclabel.text =NSLocalizedString(@"Note.Private", @"Private");
                publiclabel.backgroundColor = [UIColor clearColor];
                publiclabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
              
                 publiclabel.textColor=[UIColor whiteColor];
               
                publicSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(90, 150, 150, 30)];
               publicSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
               
               AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
               if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"]){
                   publiclabel.frame=CGRectMake(300, 155, 90, 20);
                   publicSwitch.frame=CGRectMake(400-150, 150, 150, 30);
               }
               [self.view addSubview:publiclabel];
               [self.view addSubview:publicSwitch];
           }

          

       
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(130, 200, 115, 35);
        [closeButton setTitle:NSLocalizedString(@"Close",@"Close") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
           [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveButton.frame = CGRectMake(10, 200, 115, 35);
        [saveButton setTitle:NSLocalizedString(@"Save",@"Save") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        clearButton.frame = CGRectMake(250, 200, 115, 35);
        [clearButton setTitle:NSLocalizedString(@"Clear",@"Clear") forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
         [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           
        [self.view addSubview:Titlelabel];
        [self.view addSubview:txtNote];
         

        [self.view addSubview:closeButton];
        [self.view addSubview:saveButton];
        [self.view addSubview:clearButton];

    }
    return self;
}



- (void)show
{

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
    if(txtNote.text.length==0)
    {
        alertKO=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info",@"Info") message:NSLocalizedString(@"Note.Message",@"Please fill note field.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
        [alertKO show];
        
    }
    else{
        BOOL isPrivate=[publicSwitch isOn];
        [delegate tappedSaveNoteText:self.txtNote.text private:isPrivate];
        [self hide];
    }
}

@end
