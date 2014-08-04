//
//  PdfThumbScrollView.h
//  iBoard
//
//  Created by DNA on 10/30/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCorrespondence;

@protocol PdfThumbScrollViewDelegate;

@interface PdfThumbScrollView : UIScrollView

@property (nonatomic, weak) id delegate;


- (void)createReaderDocument:(CCorrespondence *)object;
@end

@protocol PdfThumbScrollViewDelegate <NSObject>

- (void)scrollView:(PdfThumbScrollView *)scrollView
             file:(NSInteger)fileId;

@end

