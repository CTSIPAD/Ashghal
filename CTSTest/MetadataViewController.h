//
//  MetadataViewController.h
//  CTSTest
//
//  Created by DNA on 1/10/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCorrespondence;
@interface MetadataViewController : UITableViewController
{
    UITableViewCell *cell;
}
@property(nonatomic,strong)CCorrespondence *currentCorrespondence;
@end
