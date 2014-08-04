//
//  NotesViewController.m
//  iBoard
//
//  Created by DNA on 11/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "NotesViewController.h"
#import "CUser.h"
#import "CMenu.h"
#import "CCorrespondence.h"
#import "CAttachment.h"
#import "NotesTableViewCell.h"
#import "CAnnotation.h"
#import "NoteAlertView.h"
#import "CParser.h"
#import "CFPendingAction.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
{
    NSMutableArray *notesArray;
    UIButton *button ;
    CCorrespondence *correspondence;
    CAttachment *attachment;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noteCell"];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

-(void) loadData{
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currentUser=mainDelegate.user;
   
    correspondence=((CMenu*)self.currentUser.menu[self.menuId]).correspondenceList[self.correspondenceId];
    attachment=correspondence.attachmentsList[self.attachmentId];
    notesArray=attachment.annotations;
   
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView superview].frame=CGRectMake([self.tableView superview].frame.origin.x, [self.tableView superview].frame.origin.y,[self.tableView superview].frame.size.width, self.tableHeight);
    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ShowMessage:(NSString*)message{
    
    NSString *msg = message;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Warning",@"Warning")
                          message: msg
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notesArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell=(NotesTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];   
   
    CGFloat authorLabelHeight = self.cell.author.frame.size.height;
    CGFloat noteLabelHeight = self.cell.note.frame.size.height;
   
    CGFloat combinedHeight = authorLabelHeight + noteLabelHeight +15;
  
   // NSLog(@"%f",self.view.frame.size.height);
    if(self.tableHeight>=self.view.frame.size.height){
        self.tableHeight=self.view.frame.size.height-100;
    }else self.tableHeight+=combinedHeight;
    
    return combinedHeight;

}

-(CGFloat)  tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	
	return 50;
	
}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
      AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
        
        view.frame=CGRectMake(0, 0, 400, 50);
        UIButton *AddNoteButton=[[UIButton alloc]init];
     if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"])
         [AddNoteButton setFrame:CGRectMake(400-120, 5, 120, 30)];
        else[AddNoteButton setFrame:CGRectMake(0, 5, 120, 30)];
    
        [AddNoteButton setTitle:NSLocalizedString(@"Note.AddNote",@"Add Note") forState:UIControlStateNormal];
        AddNoteButton.titleLabel.textColor=[UIColor whiteColor];
        [AddNoteButton setImage:[UIImage imageNamed:@"Annoter.png"] forState:UIControlStateNormal];
        [AddNoteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
        [AddNoteButton setTitleEdgeInsets:UIEdgeInsetsMake(10,5, 10,0)];
        [AddNoteButton setBackgroundColor:[UIColor clearColor]];
    [AddNoteButton addTarget:self action:@selector(AddNote) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:AddNoteButton];
    self.tableHeight+=100;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"noteCell";
    self.cell = [[NotesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if(indexPath.row==0){
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    separatorLineView.backgroundColor = [UIColor whiteColor];
    [self.cell.contentView addSubview:separatorLineView];
    }
     CAnnotation *note=notesArray[indexPath.row];
    //self.cell.tag=note.noteId;
    UIButton *btnDelete=[[UIButton alloc] initWithFrame:CGRectMake(0,12,20,20)];
    [btnDelete setImage:[UIImage imageNamed:@"btnDelete.png"] forState:UIControlStateNormal];
    btnDelete.tag=note.noteId;
    [btnDelete addTarget:self action:@selector(deleteNote:) forControlEvents:UIControlEventTouchUpInside];
   
   
    if (note.owner ==YES) {
       // self.cell.btnDelete.hidden=YES;
        [self.cell addSubview:btnDelete];
    }
    self.cell.author.text=[NSString stringWithFormat:@"%@ ( %@ ):",note.Author,note.CreationDate];
    //[self.cell.author resizeToStretchWidth];
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"]){
        btnDelete.frame=CGRectMake(500,12,20,20);
    //self.cell.creationDate.frame=CGRectMake(520-self.cell.author.frame.size.width-20-150, self.cell.creationDate.frame.origin.y, self.cell.creationDate.frame.size.width, self.cell.creationDate.frame.size.height);
         self.cell.author.textAlignment=NSTextAlignmentRight;
        self.cell.author.text=[NSString stringWithFormat:@"(%@) :%@ ",note.CreationDate,note.Author];
    }
    else{
        
       
         self.cell.creationDate.frame=CGRectMake(self.cell.author.frame.size.width+20, self.cell.creationDate.frame.origin.y, self.cell.creationDate.frame.size.width, self.cell.creationDate.frame.size.height);
    }
  //  self.cell.creationDate.text=[NSString stringWithFormat:@"( %@ ):",note.CreationDate];
    self.cell.note.text=[NSString stringWithFormat:@"\" %@ \"",note.note];
    [self.cell.note resizeToStretchHeight];
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return self.cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
		
        
		
    }
    else if (buttonIndex == 1)
    {
        @try{
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
        NSString* url = [NSString stringWithFormat:@"http://%@?action=DeleteComment&token=%@&correspondenceId=%@&docId=%@&noteId=%d",serverUrl,self.currentUser.token,correspondence.Id,attachment.docId,button.tag];
        NSURL *xmlUrl = [NSURL URLWithString:url ];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:xmlUrl];
        NSString *validationResultNote=[CParser ValidateWithData:xmlData];
        
        if(![validationResultNote isEqualToString:@"OK"])
        {
            
            if([validationResultNote isEqualToString:@"Cannot access to the server"])
            {
                //TODO: performAction
                NSMutableArray * array=[[NSMutableArray alloc] init];
                array=notesArray;
                int i=0;
                for(CAnnotation *note in array){
                    if(note.noteId==button.tag){
                        [array removeObjectAtIndex:i];
                        notesArray=array;
                        break;
                    }
                    i++;
                }
                
                [self.tableView reloadData];
            }else
            [self ShowMessage:validationResultNote];
            
        }
        else {
            
            NSMutableArray * array=[[NSMutableArray alloc] init];
            array=notesArray;
            int i=0;
            for(CAnnotation *note in array){
                if(note.noteId==button.tag){
                    [array removeObjectAtIndex:i];
                    notesArray=array;
                    break;
                }
                i++;
            }
            
            [self.tableView reloadData];
        }
        }
        @catch (NSException *ex) {
            [FileManager appendToLogView:@"NotesViewController" function:@"DeleteComment" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
        }

    }
}

- (void)deleteNote:(id)sender
{
   button = (UIButton *)sender;
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",@"Warning")
                                                    message:NSLocalizedString(@"Alert.DeleteNote",@"Are you sure you want to delete this note?")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"NO",@"NO")
                                          otherButtonTitles:NSLocalizedString(@"YES",@"YES"), nil];
    [alert show];
    
}

-(void)AddNote{
  //  NoteAlertView *alertSettings = [[NoteAlertView alloc] initWithFrame:CGRectMake(80, 100, 430, 450)];
   // [self.view addSubview:alertSettings];
  //  [alertSettings show];
    NoteAlertView *noteView = [[NoteAlertView alloc] initWithFrame:CGRectMake(0, 300, 400, 250) fromComment:YES];
    noteView.modalPresentationStyle = UIModalPresentationFormSheet;
    noteView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:noteView animated:YES completion:nil];
    noteView.view.superview.frame = CGRectMake(300, 300, 400, 250); //it's important to do this after presentModalViewController
   // noteView.view.superview.center = self.view.center;
    noteView.delegate=self;
    
}

- (void)tappedSaveNoteText:(NSString*)text private:(BOOL)isPrivate{
    
    @try{
    NSString *securityLevel=@"Public";
    if(isPrivate){
        securityLevel=@"Private";
    }
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_preference"];
    
    NSString* url = [NSString stringWithFormat:@"http://%@",serverUrl];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // action parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"AddComment" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // token parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.currentUser.token dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // correspondenceId parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"correspondenceId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[correspondence.Id dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // docId parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"docId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[attachment.docId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // comment parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // security level parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"securityLevel\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[securityLevel dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
   
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSString *validationResultNote=[CParser ValidateWithData:returnData];
    
    if(![validationResultNote isEqualToString:@"OK"])
    {
//        if([validationResultNote isEqualToString:@"Cannot access to the server"])
//        {
//             AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            CFPendingAction*pa = [[CFPendingAction alloc] initWithActionUrl:url];
//            [mainDelegate.user addPendingAction:pa];
//            CAnnotation *annotation=[[CAnnotation alloc] initWithId:0 author:self.currentUser.firstName securityLevel:securityLevel note:text creationDate:dateString owner:YES];
//            [notesArray addObject:annotation];
//            
//            [self.tableView reloadData];
//        }else
            [self ShowMessage:validationResultNote];
        
    }
    else {
    
    NSInteger noteId=[CParser GetNoteIdWithData:returnData];
    

   
    CAnnotation *annotation=[[CAnnotation alloc] initWithId:noteId author:[NSString stringWithFormat:@"%@ %@", self.currentUser.firstName,self.currentUser.lastName ] securityLevel:securityLevel note:text creationDate:dateString owner:YES];
    [notesArray addObject:annotation];
    
    [self.tableView reloadData];
    }
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"NotesViewController" function:@"tappedSaveNoteText" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
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

@end
