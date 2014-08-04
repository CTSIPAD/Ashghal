//
//	ReaderViewController.h
//	Reader v2.6.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
//#import"SearchViewController.h"
#import"NotesViewController.h"
#import "ReaderDocument.h"
#import "AnnotationsTableViewController.h"
#import "TransferViewController.h"
#import "ManageSignatureViewController.h"

#import "ActionsTableViewController.h"

@class ReaderViewController;
@class PDFDocument;
@class PDFView;
@protocol ReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols
- (void)dismissReaderViewControllerWithReload:(ReaderViewController *)viewController;
- (void)dismissReaderViewController:(ReaderViewController *)viewController;
-(void)dismissReaderViewControllerToShowResult:(ReaderViewController *)viewController;

@end

@interface ReaderViewController : UIViewController<NoteAlertViewDelegate,AnnotationsTableDelegate,TransferViewDelegate,ManageSignatureViewDelegate>
{
    PDFDocument* m_pdfdoc;
	PDFView* m_pdfview;
    UIAlertView* alertNote;
    NSString *currentFilePath;
    
    UIButton *openButton;
    UIButton *numberPages;
}

@property(nonatomic,strong)UILabel *counter;
@property(nonatomic,strong)UIPopoverController* notePopController ;
@property(nonatomic,assign) NSInteger menuId;
@property(nonatomic,assign) NSInteger correspondenceId;
@property(nonatomic,assign) NSInteger attachmentId;

@property (nonatomic,strong)UIButton *openButton;
@property (nonatomic,strong)UIButton *numberPages;
@property(nonatomic,strong)UIView *noteContainer;
@property (nonatomic, unsafe_unretained, readwrite) id <ReaderViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *selections;
@property (nonatomic, copy) NSString *keyword;
// zoom jen
@property (nonatomic,readwrite) int widthofopen;
@property (nonatomic,readwrite) int heightofopen;
- (id)initWithReaderDocument:(ReaderDocument *)object MenuId:(NSInteger)menuId CorrespondenceId:(NSInteger)correspondenceId AttachmentId:(NSInteger)attachmentId;


+(void)closeMetadata;

@end
