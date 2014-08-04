//
//  NoteAlertView.h
//  iBoard
//
//  Created by DNA on 11/13/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteAlertViewDelegate <NSObject>

@required // Delegate protocols

- (void)tappedSaveNoteText:(NSString*)text private:(BOOL)isPrivate;

@end

@interface NoteAlertView : UIViewController<UITextViewDelegate>
{
    CGRect originalFrame;
    UITextView *txtNote;
    UISwitch *publicSwitch;
}
@property (nonatomic, unsafe_unretained, readwrite) id <NoteAlertViewDelegate> delegate;
@property (nonatomic,retain) UITextView *txtNote ;
@property (nonatomic,retain)UISwitch *publicSwitch;


- (id)initWithFrame:(CGRect)frame fromComment:(BOOL)isComment;
-(void)show;
-(void)hide;
-(void)save;

@end
