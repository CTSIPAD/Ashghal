//
//	ReaderMainToolbar.h
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
#import "CUser.h"
#import "ReaderDocument.h"
#import "UIXToolbarView.h"
//#import "CSearch.h"
//#import "CMeeting.h"

@class ReaderMainToolbar;
@class ReaderDocument;

@protocol ReaderMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar homeButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar attachmentButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar actionsButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar commentButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar metadataButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar transferButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar annotationButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar lockButton:(UIButton *)button message:(NSString*)msg;
//jen PreviousNext
//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar nextButton:(UIButton *)button documentReader:(ReaderDocument*)reader correspondenceId:(NSInteger)correspondenceId;
//-(void)tappedInToolbar:(ReaderMainToolbar *)toolbar previousButton:(UIButton *)button documentReader:(ReaderDocument*)reader correspondenceId:(NSInteger)correspondenceId;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar nextButton:(UIButton *)button documentReader:(ReaderDocument*)reader correspondenceId:(NSInteger)correspondenceId attachementId:(NSInteger)attachementId;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar previousButton:(UIButton *)button documentReader:(ReaderDocument*)reader correspondenceId:(NSInteger)correspondenceId attachementId:(NSInteger)attachementId;
@end

@interface ReaderMainToolbar : UIXToolbarView{
    UIButton *nextButton;
    UIButton *previousButton;
    UIButton *lockButton;
    UIButton *homeButton;
    UIButton *actionsButton;
    UIButton *transferButton;
    UIButton *commentsButton;
    UIButton *attachmentButton;
    UIButton *metadataButton;
    UIButton *annotationButton;
    UILabel *lblTitle;
    
    UIButton *closeButton;
}

@property (nonatomic, unsafe_unretained, readwrite) id <ReaderMainToolbarDelegate> delegate;
@property (nonatomic,assign) NSInteger menuId;
@property (nonatomic,assign) NSInteger correspondenceId;
@property (nonatomic,assign) NSInteger attachmentId;
@property (nonatomic,strong) CUser* user;

@property (nonatomic,strong)UILabel *lblTitle;
@property (nonatomic,strong)UIButton *nextButton;
@property (nonatomic,strong)UIButton *previousButton;
@property (nonatomic,strong)UIButton *lockButton;
@property (nonatomic,strong)UIButton *actionsButton;

@property (nonatomic,strong)UIButton *transferButton;
@property (nonatomic,strong)UIButton *commentsButton;
@property (nonatomic,strong)UIButton *attachmentButton;
@property (nonatomic,strong)UIButton *metadataButton;
@property (nonatomic,strong)UIButton *annotationButton;

@property (nonatomic,strong)UIButton *closeButton;


- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object CorrespondenceId:(NSInteger)correspondenceId MenuId:(NSInteger)menuId AttachmentId:(NSInteger)attachmentId;
-(void) updateTitleWithLocation:(NSString*)location withName:(NSString*)name;
- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;
-(void)adjustButtons:(UIInterfaceOrientation)orientation;

-(void)desableButtons;
@end
