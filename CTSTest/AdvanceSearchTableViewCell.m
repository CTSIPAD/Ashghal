//
//  AdvanceSearchTableViewCell.m
//  CTSTest
//
//  Created by DNA on 1/27/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "AdvanceSearchTableViewCell.h"
#import "CSearchCriteria.h"
#import "PMCalendar.h"
#import "DropDownView.h"

@implementation AdvanceSearchTableViewCell{
    UIButton *button;
    DropDownView* dropDownView;
    CSearchCriteria* criteria;
    
    ActionTaskController *actionController;
}
@synthesize txtCriteria,pmCC,criteria,lbltitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSLog(@"%f",self.frame.size.width);
        self.backgroundColor=[UIColor clearColor];
        lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 445, 25)];
        lbltitle.backgroundColor=[UIColor clearColor];
        lbltitle.textColor=[UIColor whiteColor];
        //lbltitle.font=[UIFont fontWithName:@"Helvetica" size:16.0];
        lbltitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        
        [self addSubview:lbltitle];
        
        txtCriteria=[[UITextField alloc]initWithFrame:CGRectMake(0, 30, 445, 45)];
        txtCriteria.backgroundColor=[UIColor whiteColor];
        txtCriteria.textColor=[UIColor blackColor];
        
        CGFloat red = 0.0f / 255.0f;
        CGFloat green = 155.0f / 255.0f;
        CGFloat blue = 213.0f / 255.0f;
        
//        [txtCriteria.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [txtCriteria.layer setBorderColor:[[[UIColor colorWithRed:red green:green blue:blue alpha:1.0] colorWithAlphaComponent:0.5] CGColor]];
               [txtCriteria.layer setBorderWidth:1.0];
       
        txtCriteria.layer.cornerRadius = 5;
        txtCriteria.clipsToBounds = YES;
       
        
        
        [self addSubview:txtCriteria];
        
    }
    return self;
}

-(void)updateCellwithCriteria:(CSearchCriteria*)searchCriteria{
    if(searchCriteria !=nil){
        criteria=searchCriteria;
        lbltitle.text=searchCriteria.label;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        if([ criteria.type.lowercaseString isEqualToString:@"date"]){
            txtCriteria.clearButtonMode = UITextFieldViewModeWhileEditing;
            [button setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(ShowCalendar) forControlEvents:UIControlEventTouchUpInside];
            
            txtCriteria.rightView = button;
            txtCriteria.rightViewMode = UITextFieldViewModeUnlessEditing;
            
        }
        else if([criteria.type.lowercaseString isEqualToString:@"list"]){
            txtCriteria.clearButtonMode = UITextFieldViewModeWhileEditing;
            [button setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
            
            txtCriteria.rightView = button;
            txtCriteria.rightViewMode = UITextFieldViewModeUnlessEditing;
            NSArray *array=[searchCriteria.options allValues];
            
            //jen dropdownview
            dropDownView = [[DropDownView alloc] initWithData:array cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:txtCriteria animation:BLENDIN openAnimationDuration:2 closeAnimationDuration:2];
            
            dropDownView.myDelegate = self;
            
            [self addSubview:dropDownView.view];
            
            
            
            
//            actionController = [[ActionTaskController alloc] initWithStyle:UITableViewStyleGrouped];
//            actionController.rectFrame=CGRectMake(0, 80, 300,200) ;
//            actionController.isDirection=YES;
//            actionController.actions =[NSMutableArray  arrayWithArray:array];
//            [self addSubview:actionController.view];

            
            
            
        }
    }
}

- (void)setFrame:(CGRect)frame {
    NSInteger i=0;
    if (self.superview){
        i=self.superview.frame.size.width;
        NSLog(@"%f",self.superview.frame.size.width);
        float cellWidth = 450.0;
        
        frame.origin.x = (i - cellWidth) / 2;
        frame.size.width = cellWidth;
        txtCriteria.frame=CGRectMake(0, 30, cellWidth-5, 40);
    }
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}
-(void)ShowCalendar{
    
    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = NO;
    [self.pmCC presentCalendarFromView:button.superview.superview.superview
              permittedArrowDirections:PMCalendarArrowDirectionUp
                             isPopover:isPopover
                              animated:YES custom:YES];

    
    self.pmCC.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
    [self calendarController:pmCC didChangePeriod:pmCC.period];
    [self bringSubviewToFront:self.pmCC.view];
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *currentDate = [[NSDate date] dateStringWithFormat:@"yyyy-MM-dd"];
    NSString *newPeriodDate = [newPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"];
    if(![newPeriodDate isEqualToString:currentDate])
    {
        txtCriteria.text = [NSString stringWithFormat:@"%@",newPeriodDate];
        
        [pmCC dismissCalendarAnimated:YES];
    }
    
}
BOOL opened=NO;
-(void)dropDownCellSelected:(NSInteger)returnIndex{
    opened=NO;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80);
	NSArray *keys=[criteria.options allKeys];
	txtCriteria.text=[criteria.options valueForKey:[keys objectAtIndex:returnIndex]];
    txtCriteria.tag=returnIndex;
}

-(void)list:(id)sender{
    opened =!opened;
    if(opened)
   self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300);
else self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80);
    [dropDownView openAnimation];
}
@end
