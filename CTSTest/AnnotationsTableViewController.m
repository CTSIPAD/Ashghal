//
//  AnnotationsTableViewController.m
//  CTSTest
//
//  Created by DNA on 1/21/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "AnnotationsTableViewController.h"
#import "CAction.h"
@interface AnnotationsTableViewController ()

@end

@implementation AnnotationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.clearsSelectionOnViewWillAppear = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat red = 29.0f / 255.0f;
    CGFloat green = 29.0f / 255.0f;
    CGFloat blue = 29.0f / 255.0f;
    self.tableView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"annotationCell"];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.properties.count+2;// 2 for erase and save buttons
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *mainDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    static NSString *CellIdentifier = @"annotationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 37, 37)];

   UILabel *labelTitle= [[UILabel alloc] initWithFrame:CGRectMake(70, 5,cell.frame.size.width-140, 40)];
   labelTitle.textColor = [UIColor whiteColor];
   labelTitle.backgroundColor = [UIColor clearColor];

    if(indexPath.row==self.properties.count){
//        if(!mainDelegate.isAnnotated){
//            cell.userInteractionEnabled=NO;
//            cell.backgroundColor=[UIColor grayColor];
//        }
        labelTitle.text=NSLocalizedString(@"Erase",@"Erase");
        imageView.image=[UIImage imageNamed:@"erase.png"];
    }
    else if(indexPath.row==self.properties.count+1){
        if(!mainDelegate.isAnnotated){
            cell.userInteractionEnabled=NO;
            cell.backgroundColor=[UIColor grayColor];
        }
         labelTitle.text=NSLocalizedString(@"Save",@"Save");
        imageView.image=[UIImage imageNamed:@"save.png"];
    }
    else{
        NSString *varStr = self.properties[indexPath.row];
        NSString *string1 = NSLocalizedString(varStr,@"");
        labelTitle.text=string1;
        if([varStr isEqualToString:@"Highlight"]){
            imageView.image=[UIImage imageNamed:@"highlight.png"];
        }else if([varStr isEqualToString:@"Sign"]){
            imageView.image=[UIImage imageNamed:@"Sign.png"];
        } else if ([varStr isEqualToString:@"SignAndSend"]){
            imageView.image=[UIImage imageNamed:@"SignAndSend.png"];
        }else if([varStr isEqualToString:@"Note"]){
            imageView.image=[UIImage imageNamed:@"note.png"];
        }
       

    }
    if([mainDelegate.userLanguage.lowercaseString isEqualToString:@"ar"]){
        labelTitle.textAlignment=NSTextAlignmentRight;
        imageView.frame=CGRectMake(cell.frame.size.width-45, 5, 37, 37);
    }
   
        [cell addSubview:imageView];
        [cell addSubview:labelTitle];
    
    return cell;
}
typedef enum{
    Highlight,Sign,Note,Erase,Save
    
} AnnotationsType;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    int annotation;

    if(indexPath.row<self.properties.count){
    if([self.properties[indexPath.row] isEqualToString:@"SignAndSend"]){
        CAction *action=[[CAction alloc] initWithLabel:@"SignAndSend" icon:@"" action:@"SignAndSend"];
        [_delegate PopUpCommentDialog:self Action:action document:nil];
    }
    else{
         if([self.properties[indexPath.row] isEqualToString:@"Highlight"]){
            annotation=Highlight;
        }else if([self.properties[indexPath.row] isEqualToString:@"Sign"]){
            annotation=Sign;
        }else if([self.properties[indexPath.row] isEqualToString:@"Note"]){
            annotation=Note;
        }
    
    
        [self.delegate performaAnnotation:annotation];
    }}else{
        if(indexPath.row==self.properties.count){
            annotation= Erase;
            
        }else if(indexPath.row==self.properties.count+1){
            annotation=Save;
        }
        [self.delegate performaAnnotation:annotation];

    }
   
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
