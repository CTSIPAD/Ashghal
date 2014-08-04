//
//  ActionTaskController.m
//  cfsPad
//
//  Created by marc balas on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionTaskController.h"

#import "CRouteLabel.h"
#import "CDestination.h"

@implementation ActionTaskController
{
    CGRect rectFrame;
    AppDelegate *mainDelegate;
}
@synthesize delegate,actions,rectFrame,displayingLabel,sheet;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	//[super initWithStyle:UITableViewStyleGrouped];
    [super viewDidLoad];
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    displayingLabel = YES;
	searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate=self;
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.searchResultsDataSource=self;

    self.tableView.tableHeaderView=searchBar;
    searchData = [[NSMutableArray alloc] init];
	self.clearsSelectionOnViewWillAppear = NO;
    
	 [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:208/255.0f blue:208/255.0f alpha:1.0]];
    self.tableView.layer.borderColor=[[UIColor grayColor]CGColor];
    self.tableView.layer.borderWidth=2;
	self.clearsSelectionOnViewWillAppear = NO;
    NSInteger frameHeight=self.actions.count*30+50;
    if (frameHeight>135) {
        frameHeight=135;
    }
    
    self.view.frame=CGRectMake(rectFrame.origin.x,rectFrame.origin.y,rectFrame.size.width,frameHeight);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sections=1;
    /*if(tableView == self.searchDisplayController.searchResultsTableView){
        //[searchData count];
                sections = [searchData count];
    }*/
    return sections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int rows=0;
    if (tableView == self.tableView) {
	if([self.actions count]==0)
		rows= 1;
	else 
		rows= ([self.actions count]);
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
      //  tableView.backgroundColor = [UIColor redColor];
        rows =[searchData  count];

    }
    return  rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 30;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
       if(self.actions.count == 0)
		cell.textLabel.text = @"No action available";
	
	else {
         if (tableView == self.tableView) {
		if (indexPath.row<self.actions.count) {
            if(self.isDirection){
                //jen dropdownview
//                NSString* rl = [self.actions objectAtIndex:indexPath.row];
//                cell.textLabel.text = rl;
            CRouteLabel* rl = [self.actions objectAtIndex:indexPath.row];
            cell.textLabel.text =  rl.name;
            }else{
                CDestination* dest= [self.actions objectAtIndex:indexPath.row];
                cell.textLabel.text =  dest.name;
            }
        }
         }if(tableView == self.searchDisplayController.searchResultsTableView){
             //cell.textLabel.text = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
             if(self.isDirection){
                CRouteLabel* rl = [searchData objectAtIndex:indexPath.row];
                 cell.textLabel.text =  rl.name;
             }else{
                 CDestination* dest= [searchData objectAtIndex:indexPath.row];
                 cell.textLabel.text =  dest.name;
             }
         }
		
	}
    
    if([mainDelegate.ipadLanguage.lowercaseString isEqualToString:@"ar"]){
        cell.textLabel.textAlignment=NSTextAlignmentRight;
    }

    return cell;
}


#pragma mark -
#pragma mark Table view delegate
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//	if(section == 0)
//		return NSLocalizedString(@"taskdetail.actiontitle",@"Choose an action :");
//	else 
//	{
//		return @"Another section";
//	}
//}


-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	
	return 1;
	
}

#pragma mark -
#pragma mark Table view delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    
    CRouteLabel* routeLabel;
    CDestination* destination;
    if (self.isDirection) {
        for(routeLabel in self.actions)
        {
          //  NSMutableArray *newGroup = [[NSMutableArray alloc] init];
            
            NSRange range = [routeLabel.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) {
          //      [newGroup addObject:routeLabel.name];
                [searchData addObject:routeLabel];

            }
            
            
         /*   if ([newGroup count] > 0) {
                [searchData addObject:newGroup];
            }*/
            
           
        }
    }
    else
    {
        for(destination in self.actions)
        {
          //  NSMutableArray *newGroup = [[NSMutableArray alloc] init];
            
            
            NSRange range = [destination.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) {
             //   [newGroup addObject:destination.name];
                [searchData addObject:destination];

                
            }
            
         /*   if ([newGroup count] > 0) {
                [searchData addObject:newGroup];
            }*/
            
           
        }
        
    }
    
    
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*if(tableView == self.searchDisplayController.searchResultsTableView){
        NSLog(@"johnny row : %ld",(long)indexPath.row);
    }*/
    if([self.searchDisplayController isActive]){
        
        if (indexPath.row<actions.count) {
            if(self.isDirection){
                CRouteLabel* rl = searchData[indexPath.row];
                [delegate actionSelectedDirection:rl];
            }else{
                CDestination* dest = searchData[indexPath.row];
                [delegate actionSelectedDestination:dest];
            }
        }
    }
    else{
    
	if(delegate !=nil)
	{searchBar.text=@"";
        [searchBar resignFirstResponder];
        [searchDisplayController setActive:NO];
        
        if (indexPath.row<actions.count) {
            if(self.isDirection){
            CRouteLabel* rl = [self.actions objectAtIndex:indexPath.row];
            [delegate actionSelectedDirection:rl];
            }else{
              CDestination* dest = [self.actions objectAtIndex:indexPath.row];
              [delegate actionSelectedDestination:dest];
            }
        }
		
	}}
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
	[super viewDidUnload];
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	delegate=nil;
    //[super dealloc];
}


@end

