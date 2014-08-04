//
//  NotesTableViewCell.h
//  iBoard
//
//  Created by DNA on 11/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableViewCell : UITableViewCell
{
    UILabel *author;
    UILabel *note;
    UILabel *creationDate;
    UIButton *btnDelete;
}
@property(nonatomic,strong)IBOutlet UILabel *author;
@property(nonatomic,strong)IBOutlet UILabel *creationDate;
@property(nonatomic,strong)IBOutlet UILabel *note;
@property(nonatomic,strong) UIButton *btnDelete;
@end

@interface UILabel (dynamicSizeWidth)
-(void)resizeToStretchWidth;
-(void)resizeToStretchHeight;
@end
