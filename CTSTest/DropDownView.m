    //
//  DropDownView.m
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DropDownView

//@synthesize uiTableView;

@synthesize arrayData, heightOfCell,refView;

@synthesize paddingLeft,paddingRight,paddingTop;

@synthesize open,close;

@synthesize heightTableView;

@synthesize myDelegate;



- (id)initWithData:(NSArray*)array cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration{

	if ((self = [super init])) {
		
		self.arrayData=array;
		
		self.heightOfCell = cHeight;
		
		self.refView = rView;
		
		self.paddingTop = tPaddingTop;
		
		self.paddingLeft = tPaddingLeft;
		
		self.paddingRight = tPaddingRight;
		
		self.heightTableView = tHeightTableView;
		
		self.open = openDuration;
		
		self.close = closeDuration;
		
		CGRect refFrame = refView.frame;
		
		self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop,refFrame.size.width+paddingRight, arrayData.count*heightOfCell);
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		
		self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
		
		self.view.layer.shadowOpacity =1.0f;
		
		self.view.layer.shadowRadius = 5.0f;
		
		animationType = tAnimation;
		
	}
	
	return self;
	
}	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	CGRect refFrame = refView.frame;
   
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,refFrame.size.width+paddingRight, (animationType == BOTH || animationType == BLENDIN)?arrayData.count*heightOfCell:1) style:UITableViewStylePlain];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
     self.tableView.separatorColor = [UIColor colorWithRed:152.0f/255.0f green:45.0f/255.0f blue:20.0f/255.0f alpha:1.0];
	self.tableView.dataSource = self;
	self.tableView.userInteractionEnabled=YES;
    [self.tableView setAllowsSelection:YES];
	//self.tableView.delegate = self;
	
	//[self.view addSubview:uiTableView];
	
	self.view.hidden = YES;
	
	if(animationType == BOTH || animationType == BLENDIN)
		[self.view setAlpha:1];
	
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}


- (void)dealloc {
//    [super dealloc];
//	[uiTableView release];
//	[arrayData,refView release];
	
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return heightOfCell;
	
	
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return arrayData.count;
	
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        CGFloat red = 0.0f / 255.0f;
        CGFloat green = 155.0f / 255.0f;
        CGFloat blue = 213.0f / 255.0f;
        
//        cell.backgroundColor=[UIColor colorWithRed:195.0/255.0f green:61.0/255.0f blue:24.0/255.0f alpha:1.0];
        cell.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
		
    }
    
	cell.textLabel.text =[arrayData objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    cell.textLabel.textColor=[UIColor whiteColor];
	return cell;
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[myDelegate dropDownCellSelected:indexPath.row];
	
	[self hideView];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

	return 0;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

	return 0;
	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

	return @"";
	
}	

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
	
}	

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
	
    if(self.view.hidden==YES)
	self.view.hidden = NO;
    else self.view.hidden = YES;
    
	self.tableView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width, heightTableView);
//	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center] ;
//	
//	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
//	
//	[UIView setAnimationDuration:open];
//	
//	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
//	
//	[UIView setAnimationRepeatCount:1];
//	
//	[UIView setAnimationDelay:0];
//	
//	if(animationType == BOTH || animationType == GROW)
//		self.tableView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width, heightTableView);
//	
//	if(animationType == BOTH || animationType == BLENDIN)
//		self.view.alpha = 1;
//	
//	[UIView commitAnimations];
//	
	
	
	
	
}

-(void)closeAnimation{
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center] ;
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:close];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.tableView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width, 1);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 0;
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideView) withObject:nil afterDelay:close];
	
	
		
}

	 
-(void)hideView{
	
	self.view.hidden = YES;

}	 


@end
