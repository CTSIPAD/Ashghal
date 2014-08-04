//
//  AdvanceSearchTableViewCell.h
//  CTSTest
//
//  Created by DNA on 1/27/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendarController.h"
#import "DropDownView.h"

#import "ActionTaskController.h"
@class CSearchCriteria;
@interface AdvanceSearchTableViewCell : UITableViewCell<PMCalendarControllerDelegate,DropDownViewDelegate>
{
    UITextField* txtCriteria;
    UILabel *lbltitle;
}


@property(nonatomic,strong)UITextField* txtCriteria;
@property(nonatomic,strong)UILabel *lbltitle;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property (nonatomic, strong) CSearchCriteria* criteria;


-(void)updateCellwithCriteria:(CSearchCriteria*)searchCriteria;
@end
