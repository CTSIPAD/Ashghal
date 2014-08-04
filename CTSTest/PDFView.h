//
//  PDFView.h
//  demo_form_field
//
//  Created by Foxit on 12-2-7.
//  Copyright 2012 Foxit Software Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fs_base.h"
#import "fpdf_base.h"
#import "fpdf_view.h"
#import "fpdf_annot.h"
#import "fpdf_document.h"
#import "fpdf_text.h"

@class PDFDocument;
@interface PDFView : UIView {
    CGPoint startLocation;
	CGPoint endLocation;
    CGPoint currentPoint;
    CGPoint previousPoint;
	PDFDocument* m_pDocument;
	//PDF page handle.
	FPDF_PAGE m_curPage;
	//The current page index.
    int m_pageIndex;
	
	//The width of display area.
	int m_nSizeX;
	//The Height of display area.
	int m_nSizeY;
	//The horizontal position at which page start to render.
	int m_nStartX;
	//The vertical position at which page start to render.
	int m_nStartY;
    //The Size of Phone Displaying View Area
    CGSize m_mainsize;
    //The Pos of Image Displayed To the Phone View Area
    CGRect m_viewRect;
    NSInteger annotationSignWidth;
    NSInteger annotationSignHeight;
    FS_FLOAT m_zoomLevel;
    
    FS_FLOAT m_pageWidth;
    FS_FLOAT m_pageHeight;
    
}
//zoom jen
@property (nonatomic,readwrite) BOOL zooming;
@property (nonatomic, readwrite) BOOL btnNote;
@property (nonatomic, readwrite) BOOL btnHighlight;
@property (nonatomic, readwrite) BOOL btnErase;
@property (nonatomic, readwrite) BOOL btnSign;
@property (nonatomic, strong) NSString* annotationNoteMsg;
@property (nonatomic, assign) NSInteger annotationSignWidth;
@property (nonatomic, assign) NSInteger annotationSignHeight;
@property(nonatomic,assign) NSInteger attachmentId;
@property (nonatomic, readwrite) CGPoint startLocation;
@property (nonatomic, readwrite) CGPoint endLocation;
@property (nonatomic,assign) PDFDocument *doc;

- (void) OnPrevPage;
- (void) OnNextPage;
-(void) OnZoomIn;
-(void) OnZoomOut;
-(FS_FLOAT)getWidth;
-(FS_FLOAT)getHeight;
- (void)initPDFDoc: (PDFDocument*)pdoc;
- (CGPoint)PageToDevicePoint:(FPDF_PAGE)page p1:(CGPoint)point;
- (CGPoint)DeviceToPagePoint:(FPDF_PAGE)page p1:(CGPoint)point;
@end
