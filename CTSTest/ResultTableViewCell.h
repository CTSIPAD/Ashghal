//
//  SearchResultTableViewCell.h
//  iBoard
//
//  Created by DNA on 11/14/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell{
    
    UIImageView *imageView;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) NSString *imageThumbnailBase64;

-(void)updateCell;
@end
