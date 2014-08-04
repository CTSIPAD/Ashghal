//
//  PDFDocument.h
//  demo_form_field
//
//  Created by Foxit on 12-2-7.
//  Copyright 2012 Foxit Software Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFView.h"

@interface PDFDocument : NSObject {
	//A full path of PDF file.
    const char* m_pfilepath;
	//Page count of PDF.
    FS_INT32 m_pageCount;
	//A buffer allocated by application to set extra memory to SDK.
    void  * m_pBuffer;  
	//A custom way to read file.
    FS_FILEREAD m_fileread;
	//PDF document bandler.
    FPDF_DOCUMENT m_fpdfdoc;
    //PDF Mapper Handler.
    FS_FONT_FILE_MAPPER m_fontMapper;
	

	PDFView* m_pdfview;
	
	FPDF_PAGE m_current_page;
	FPDF_PAGE* m_pPageArray;
	
    int m_nAnnotIndex;
    int stampx;
    int stampy;
    UITextView *textView;
    Boolean m_bAddHight;
    Boolean m_bAddPencil;
    Boolean m_bAddNote;
    Boolean m_bAddStamp;
    Boolean m_bAddFileAttach;
}
@property(nonatomic)  CGPoint annotPoint;
@property(nonatomic,strong)NSData* signatureData;

//Open the PDF document.
- (BOOL) openPDFDocument:(const char*) file; 
//Close the PDF document.
- (void) closePDFDocument;
- (FPDF_DOCUMENT) getPDFDoc;
//Load the specified pdf page. 
- (FPDF_PAGE) getPDFPage:(NSUInteger) aindex;
//Get the current displayed pdf page.
- (FPDF_PAGE) getCurPDFPage;
//Render the pdf page to image, could render only a specified page area.
- (FS_BITMAP) getPageImageByRect:(FPDF_PAGE) page p1:(int) nstartx p2:(int) nstarty p3:(int) sizex p4:(int) sizey p5:(int) bmWidth p6:(int) bmHeight;
//Release the loaded pdf page.
- (void) releasePDFPage:(FPDF_PAGE) page;

//Initialise the fpdfemb library.
- (void) initPDFSDK;
//Release the fpdfemb library.
- (void) releasePDFSDK;

- (void)setPDFView:(PDFView*)pdfview;
- (void)setCurPage:(FPDF_PAGE)pdfpage;
- (void)invalidatePDFView:(FPDF_PAGE)page Region:(CGRect)rect;

- (void)AddHighlightAnnot;
- (void)AddPencilAnnot;
- (void)AddNoteAnnot;
- (void)AddStampAnnot;
- (void)AddFileAttachment;
- (void)deleteAnnot;
-(void)AddHighlightAnnot:(CGPoint)pt1 secondPoint:(CGPoint)pt2 previousPoint:(CGPoint)prevPt;
- (void)AddStampAnnot:(CGPoint)ptLeftTop secondPoint:(CGPoint)ptRightBottom previousPoint:(CGPoint)previousPoint;
-(void)AddNote:(CGPoint)pt1 secondPoint:(CGPoint)pt2 note:(NSString*)msg;
-(void)extractText:(CGPoint)point;
- (void)eraseAnnotation:(CGPoint)pt1 secondPoint:(CGPoint)pt2;
- (void)deleteAllAnnot;

@end
