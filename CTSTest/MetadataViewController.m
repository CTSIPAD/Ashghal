//
//  MetadataViewController.m
//  CTSTest
//
//  Created by DNA on 1/10/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "MetadataViewController.h"
#import "CCorrespondence.h"
#import "ReaderViewController.h"
@interface MetadataViewController ()

@end

@implementation MetadataViewController{
    NSMutableDictionary* properties;
    AppDelegate *mainDelegate;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setUserInteractionEnabled:NO];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"metadataCell"];
    
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
}

-(void)viewWillAppear:(BOOL)animated{
    properties = [[NSMutableDictionary alloc] init];
    
    int i=0;
    NSMutableDictionary *subDictionary;
    for( i=0;i< self.currentCorrespondence.systemProperties.count; i++)
        {
            NSString *s=[NSString stringWithFormat:@"%d",i];
            subDictionary = [self.currentCorrespondence.systemProperties objectForKey:s];
            
            [properties setObject:subDictionary forKey:s];
           
        }
        
    for (int j=0;j< self.currentCorrespondence.properties.count;j++) {
        NSMutableDictionary *mainDictionary=[[NSMutableDictionary alloc] init];
         NSString *s1=[NSString stringWithFormat:@"%d",j];
        subDictionary = [self.currentCorrespondence.properties objectForKey:s1];
       NSString *s=[NSString stringWithFormat:@"%d",j+i];
        [mainDictionary setObject:subDictionary forKey:s];
        [properties setObject:mainDictionary forKey:s];
       
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return properties.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[NSString stringWithFormat:@"%d",indexPath.section];
    NSDictionary *subDictionary = [properties objectForKey:key];
    NSArray *keys=[subDictionary allKeys];
    if([[keys objectAtIndex:0] isEqualToString:@"Subject"])
        return 150;
    return 50;
    
}

-(CGFloat)  tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	
	return 1;
	
}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50;
}

-(void)hide{
    [ReaderViewController closeMetadata];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    //jen metadata color
    CGFloat red=0.0f/255.0f;
    CGFloat green=155.0f/255.0f;
    CGFloat blue=213.0f/255.0f;
    view.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    view.frame=CGRectMake(0, 0, 350, 50);
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
  //lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    NSString *key=[NSString stringWithFormat:@"%d",section];
    NSDictionary *subDictionary = [properties objectForKey:key];
    NSArray *keys=[subDictionary allKeys];
     NSDictionary *subSubDictionary=[subDictionary objectForKey:[keys objectAtIndex:0]];
    lblTitle.text=[[subSubDictionary allKeys] objectAtIndex:0];
    
     if([mainDelegate.userLanguage.lowercaseString isEqualToString:@"ar"])
         lblTitle.textAlignment=NSTextAlignmentRight;
   
    [view addSubview:lblTitle];

    return view;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"metadataCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:239.0/255.0f alpha:1.0];
    NSString *key=[NSString stringWithFormat:@"%d",indexPath.section];
    NSDictionary *subDictionary = [properties objectForKey:key];
    
   NSArray *keys=[subDictionary allKeys];
    cell.textLabel.numberOfLines=0;
    NSDictionary *subSubDictionary=[subDictionary objectForKey:[keys objectAtIndex:0]];
    NSArray *subkeys=[subSubDictionary allKeys];
    NSLog(@"%@",[subSubDictionary objectForKey:[subkeys objectAtIndex:0]]);
    cell.textLabel.text= [subSubDictionary objectForKey:[subkeys objectAtIndex:0]];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    if([mainDelegate.userLanguage.lowercaseString isEqualToString:@"ar"])
        cell.textLabel.textAlignment=NSTextAlignmentRight;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [ReaderViewController closeMetadata];
    
}


@end
