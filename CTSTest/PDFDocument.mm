//
//  PDFDocument.mm
//  demo_form_field
//
//  Created by Foxit on 12-2-7.
//  Copyright 2012 Foxit Software Corporation. All rights reserved.
//
#import "AppDelegate.h"
#import "PDFDocument.h"
#import "GDataXMLNode.h"
#import "note.h"
#import "HighlightClass.h"
#define StampFileName @"FoxitLogo"
#define AttachFileName @"FoxitForm"

//Define a log function.
#define PRINT_RET(str, ret) if((ret)){NSLog(@"%@ failed(%i)", (str), (ret));return nil;}


//Begin implemention of struct FS_FileRead.
FS_DWORD FileGetSize(FS_LPVOID clientData)
{
    FILE* pfile = (FILE*) clientData;
    if(pfile != NULL)
    {
        fseek(pfile, 0, SEEK_END);
        return ftell(pfile);
    }
    else
        return 0;
}

FS_RESULT FileReadBlock(FS_LPVOID clientData, void* buffer, FS_DWORD offset, FS_DWORD size)
{
    FILE* pFile = (FILE*)clientData;
    FS_BOOL ret = FALSE;
    
    if(pFile != NULL)
    {
        ret = fseek(pFile, offset, SEEK_SET);
        if(fread(buffer, sizeof(char), size, pFile)==size)
            return FS_ERR_SUCCESS;
    }
    
    return FS_ERR_ERROR;
}

static void	FileReadRelease(FS_LPVOID clientData)
{
}
//End implemention of struct FS_FileRead.




//Begin implemention of struct FS_FileWrite.
FS_DWORD	FSFileWrite_GetSize(FS_LPVOID clientData)
{
	return 0;
}

FS_RESULT	FSFileWrite_WriteBlock(FS_LPVOID clientData, FS_LPCVOID buffer,
								   FS_DWORD offset, FS_DWORD size)
{
	FILE* fp = (FILE*)clientData;
	if(!fp)
		return -1;
	//fseek(fp, offset, SEEK_SET);
	fwrite(buffer, sizeof(char), size, fp);
	return 0;
}

FS_RESULT	FSFileWrite_Flush(FS_LPVOID clientData)
{
	return 0;
}
//End implemention of struct FS_FileWrite.




//Begin implemention of struct FS_MEM_FIXEDMGR.
static FS_BOOL emb_test_more(FS_LPVOID clientData, int alloc_size, void** new_memory, int* new_size)
{
	*new_size = alloc_size;
	if (*new_size < 1000000) *new_size = 1000000;
	*new_memory = malloc(*new_size);
    if (new_memory == NULL) 
        return FALSE;
	return TRUE;
}
static void emb_test_free(FS_LPVOID clientData, void* memory)
{
	free(memory);
}
//End implemention of struct FS_MEM_FIXEDMGR.

//Begin implemention of struct FPDFEMB_FONT_MAPPER

FS_BOOL MyMapFont(FS_LPVOID param, FS_LPCSTR name, FS_INT32 charset,
                  FS_DWORD flags, FS_INT32 weight,
                  FS_CHAR* path, FS_INT32* face_index)
{
    if(0 == charset)
        return TRUE;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"DroidSansFallback" ofType:@"ttf"];
    if(filepath != NULL)
    {
        strcpy(path, [filepath UTF8String]);
        *face_index = 0;        
    }
	return TRUE;
}
//End implemention of struct FPDFEMB_FONT_MAPPER





@implementation PDFDocument{
    AppDelegate *mainDelegate;
}
@synthesize annotPoint;
- (void)dealloc
{
	
}

- (void)initPDFSDK
{
    int size = 6*1024*1024;
	m_pBuffer = (void *)malloc(size);
	
	static FS_MEM_FIXEDMGR callbacks;
	callbacks.More = emb_test_more;
	callbacks.Free = emb_test_free;
	callbacks.clientData = m_pBuffer;
    
	FS_Memory_InitFixed(m_pBuffer, size, &callbacks);
	// Use the SN information to unlock the library
  //  FS_Library_Unlock("XXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
     FS_Library_Unlock("SDKEDFZ1097", "626B50E917321DA5B3D829ECF39F9387C3231CE0");
    FS_LoadJpeg2000Decoder();
    FS_LoadJbig2Decoder();
    FS_FontCMap_LoadGB();
    FS_FontCMap_LoadGBExt();
    FS_FontCMap_LoadCNS();
    FS_FontCMap_LoadKorea();
    FS_FontCMap_LoadJapan();
    FS_FontCMap_LoadJapanExt();
    
    m_fontMapper.MapFont = MyMapFont;
    FS_Font_SetFontFileMapper(&m_fontMapper);
}

- (void)releasePDFSDK
{
    [self closePDFDocument];
	FS_Memory_Destroy();
    free(m_pBuffer);
}

- (void) releasePDFPage:(FPDF_PAGE) page
{
	FPDF_Page_Close(page);
}

- (void)setPDFView:(PDFView*)pdfview
{
	m_pdfview = pdfview;
}

- (void)setCurPage:(FPDF_PAGE)pdfpage
{
	m_current_page = pdfpage;
}

- (FPDF_DOCUMENT) getPDFDoc
{
    return m_fpdfdoc;
}

- (void)invalidatePDFView:(FPDF_PAGE)page Region:(CGRect)rect
{
	CGPoint ptLeftTop = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint ptRightBottom = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
	ptLeftTop = [m_pdfview PageToDevicePoint:page p1:ptLeftTop];
	ptRightBottom = [m_pdfview PageToDevicePoint:page p1:ptRightBottom];
	
	CGRect rc = CGRectMake(ptLeftTop.x,ptLeftTop.y,ptRightBottom.x-ptLeftTop.x, ptRightBottom.y-ptLeftTop.y);
	
	[m_pdfview setNeedsDisplayInRect:rc];
}

-(BOOL) openPDFDocument: (const char*) file
{
    if(m_fpdfdoc != NULL)
    {
        FPDF_Doc_Close(m_fpdfdoc);
        m_fpdfdoc = NULL;
        m_pfilepath = NULL;
    }
    m_pfilepath = file;
    FILE* fp = fopen(m_pfilepath, "rb");
    if(fp == NULL)
    {
        NSLog(@"File %s is not exist!", file);
        return FALSE;
    }
    
    m_fileread.GetSize = FileGetSize;
    m_fileread.ReadBlock = FileReadBlock;
    m_fileread.Release = FileReadRelease;
    m_fileread.clientData = fp;
    
    
    FS_RESULT ret = FPDF_Doc_Load(&m_fileread, NULL, &m_fpdfdoc);
    ret = FPDF_Doc_GetPageCount(m_fpdfdoc, &m_pageCount);
	if(ret != FS_ERR_SUCCESS)
		return FALSE;
    
	m_pPageArray = new FPDF_PAGE[m_pageCount];
	memset(m_pPageArray, 0, sizeof(FPDF_PAGE)*(m_pageCount));
	m_current_page = [self getPDFPage:0];
	m_pPageArray[0] = m_current_page;
    m_nAnnotIndex = 0;
    m_bAddHight = FALSE;
    m_bAddNote = FALSE;
    m_bAddPencil = FALSE;
    m_bAddFileAttach = FALSE;
    m_bAddStamp = FALSE;
	return TRUE;
}

- (void)closePDFDocument
{
	if(m_pPageArray)
		delete[] m_pPageArray;
	if(m_fpdfdoc != NULL)
    {
        FPDF_Doc_Close(m_fpdfdoc);
        m_fpdfdoc = NULL;
        m_pfilepath = NULL;
    }
}

- (FPDF_PAGE) getPDFPage:(NSUInteger) aindex
{
	if(aindex<0 || aindex >= m_pageCount)
		return NULL;
	if(m_pPageArray[aindex])
		return m_pPageArray[aindex];
	FPDF_PAGE page;
	FS_RESULT ret = FPDF_Page_Load(m_fpdfdoc, aindex, &page);
	//PRINT_RET(@"load page", ret);
	ret = FPDF_Page_StartParse(page, 0, NULL);
	//PRINT_RET(@"parse page", ret);
	
	//form fill implemention.
	m_pPageArray[aindex] = page;
	
	return page;

}

- (FPDF_PAGE) getCurPDFPage
{
	//Get the pdf page which is current viewing.
	return m_current_page;
}

- (FS_BITMAP) getPageImageByRect:(FPDF_PAGE) page p1:(int) nstartx p2:(int) nstarty p3:(int) sizex p4:(int) sizey p5:(int) bmWidth p6:(int) bmHeight
{

	FS_BITMAP dib;
	FS_RESULT ret = FS_Bitmap_Create(bmWidth, bmHeight, FS_DIBFORMAT_RGBA, NULL, 0, &dib);
	PRINT_RET(@"create dib", ret);
	//void* pt = FS_Bitmap_GetBuffer(dib);
	//memset(pt, 0xff, FS_Bitmap_GetStride(dib)*bmHeight);
	
	FS_RECT rectClip;
	rectClip.left = -nstartx;
	rectClip.right = -nstartx+sizex;
	rectClip.top = -nstarty;
	rectClip.bottom = -nstarty+sizey;
    
    FPDF_RenderPage_SetHalftoneLimit(5000 * 5000);
	ret = FPDF_RenderPage_Start(dib, page, -nstartx, -nstarty, sizex, sizey, 0, FPDF_RENDER_ANNOT, &rectClip, NULL);
	PRINT_RET(@"render page", ret);
	
    return dib;
}

- (void)AddHighlightAnnot
{
    if(m_bAddHight)
        return;
    m_bAddHight = TRUE;
    FPDF_ANNOT_HIGHLIGHTINFO HightAnnot;
	memset(HightAnnot.author, 0, 64*2);
	HightAnnot.color=0xffff00;
	HightAnnot.opacity=100;
	HightAnnot.quad_count=1;
    FPDF_ANNOT_QUAD annot_quad;
    
    int count = 0;
    FPDF_Annot_GetCount(m_current_page,&count);
    FPDF_TEXTPAGE textPage = NULL;
    FPDF_Text_LoadPage(m_current_page, &textPage);
    FS_INT32 rectCount = 0;
    FPDF_Text_CountRects(textPage, 0, 5, &rectCount);
    for(int i=0; i<rectCount;i++)
    {
        FS_RECTF rect;
        FPDF_Text_GetRect(textPage, i, &rect);
        
        annot_quad.x1 = rect.left;
        annot_quad.y1 = rect.top;
        annot_quad.x2 = rect.right;
        annot_quad.y2 = rect.top;
        annot_quad.x3 = rect.left;
        annot_quad.y3 = rect.bottom;
        annot_quad.x4 = rect.right;
        annot_quad.y4 = rect.bottom;
        
        HightAnnot.size =  sizeof(FPDF_ANNOT_HIGHLIGHTINFO);
        HightAnnot.quads=&annot_quad;
        FPDF_Annot_Add(m_current_page,FPDF_ANNOTTYPE_HIGHLIGHT,&HightAnnot,sizeof(FPDF_ANNOT_HIGHLIGHTINFO), (FPDF_ANNOT*)&m_nAnnotIndex);
        m_nAnnotIndex++;
    }
    [m_pdfview setNeedsDisplay];
    
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
}
-(BOOL)searchArray:(CGPoint)pt1{
    BOOL found=NO;
    AppDelegate* mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(int i=[mainDelegate.Highlights count]-1;i>=0;i--){
        HighlightClass* obj=mainDelegate.Highlights[i];
        if(obj.abscissa==pt1.x && obj.ordinate==pt1.y){
            found=YES;
            break;
        }
        
    }
    return  found;
}
- (void)AddHighlightAnnot:(CGPoint)pt1 secondPoint:(CGPoint)pt2 previousPoint:(CGPoint)prevPt
{
     mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    m_bAddHight = TRUE;
    FPDF_ANNOT_HIGHLIGHTINFO HightAnnot;
	memset(HightAnnot.author, 0, 64*2);
	HightAnnot.color=0xffff00;
	HightAnnot.opacity=100;
	HightAnnot.quad_count=2;
    FPDF_ANNOT_QUAD annot_quad;
    int count = 0;
    FPDF_Annot_GetCount(m_current_page,&count);
    FS_RECTF rect={static_cast<FS_FLOAT>(pt1.x),static_cast<FS_FLOAT>(pt1.y),static_cast<FS_FLOAT>(pt2.x),static_cast<FS_FLOAT>(pt2.y)};
   

        annot_quad.x1 = rect.left;
        annot_quad.y1 = rect.top;
        annot_quad.x2 = rect.right;
        annot_quad.y2 = rect.top;
        annot_quad.x3 = rect.left;
        annot_quad.y3 = rect.bottom;
        annot_quad.x4 = rect.right;
        annot_quad.y4 = rect.bottom;
    
        HightAnnot.size =  sizeof(FPDF_ANNOT_HIGHLIGHTINFO);
        HightAnnot.quads=&annot_quad;
    if(mainDelegate.highlightNow)
        [self deleteAllAnnot];
        FPDF_Annot_Add(m_current_page,FPDF_ANNOTTYPE_HIGHLIGHT,&HightAnnot,sizeof(FPDF_ANNOT_HIGHLIGHTINFO), (FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
    [m_pdfview setNeedsDisplay];
    
}

- (void)AddPencilAnnot
{
    if(m_bAddPencil)
        return;
    m_bAddPencil = TRUE;
    int count=0;
    FPDF_Annot_GetCount(m_current_page,&count);
    
    FPDF_ANNOT_PENCILINFO pencilAnnot; 
    pencilAnnot.size = sizeof(pencilAnnot);
    pencilAnnot.color = 0x000000;
    pencilAnnot.busebezier = 1;
    pencilAnnot.boptimize = 1;
    pencilAnnot.reserved = 0;
    pencilAnnot.opacity = 80;
    pencilAnnot.line_width = 2;
    pencilAnnot.line_count = 2;
    
    FPDF_ANNOT_LINE* line = new FPDF_ANNOT_LINE[2];
    //FS_POINT point2[3];
    //FS_POINT point[2];
    
    FS_POINTF point[] = {300, 300, 400, 400};
    FS_POINTF point2[] = {400, 400, 500, 700, 400, 100};
    
    line[0].point_count = 2;
    line[0].points = point;
    line[1].point_count = 3;
    line[1].points = point2;
    pencilAnnot.lines = line;
    m_nAnnotIndex++;
    delete line; 
    [m_pdfview setNeedsDisplay];
    
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
}

- (void)AddNoteAnnot
{
    if(m_bAddNote)
        return;
    m_bAddNote = TRUE;
    int	nCount=0;
	FPDF_Annot_GetCount(m_current_page,&nCount);

	FPDF_ANNOT_NOTEINFO	noteAnnot;
	noteAnnot.size = sizeof(FPDF_ANNOT_NOTEINFO);
	noteAnnot.author[0] = 0;
	noteAnnot.opacity = 80;
	noteAnnot.icon = 0;
	noteAnnot.color = 0x00ff00;  
    NSString* string = [[NSString alloc] initWithFormat:@"This is a note!"];
    noteAnnot.contents = (FS_LPCWSTR)[string cStringUsingEncoding:NSUnicodeStringEncoding];
	
	
    CGPoint ptLeftTop = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(80,80)];
    CGPoint ptRightBottom = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(120, 120)];
    
    FS_RECTF rect = {static_cast<FS_FLOAT>(ptLeftTop.x), static_cast<FS_FLOAT>(ptLeftTop.y), static_cast<FS_FLOAT>(ptRightBottom.x), static_cast<FS_FLOAT>(ptRightBottom.y)};
	noteAnnot.rect = rect;//noteRect;
	FPDF_Annot_Add(m_current_page,FPDF_ANNOTTYPE_NOTE,&noteAnnot,noteAnnot.size,(FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    
   
    [m_pdfview setNeedsDisplay];
	
	
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
}

- (void)AddStampAnnot
{
    if(m_bAddStamp)
        return;
    m_bAddStamp = TRUE;
    int nCount=0;
	FPDF_Annot_GetCount(m_current_page,&nCount);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:StampFileName ofType:@"jpg"];
    
    const char* jpgpath = [path UTF8String];
    FILE* pf = fopen(jpgpath , "rb");
    if(!pf)
        return;
	fseek(pf, 0,SEEK_END);
	int len = ftell(pf);
	fseek(pf,0,SEEK_SET);
	unsigned char* buf = (unsigned char*)malloc(len);
	fread(buf, 1, len, pf);
	fclose(pf);
	//FS_RECT	noteRect;
	FPDF_ANNOT_STAMPINFO stampInfo;
	stampInfo.color = 0xff0000;
	stampInfo.size = sizeof(stampInfo);
    
    CGPoint ptLeftTop = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(120,120)];
    CGPoint ptRightBottom = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(160, 160)];
    
    FS_RECTF rect = {static_cast<FS_FLOAT>(ptLeftTop.x), static_cast<FS_FLOAT>(ptLeftTop.y), static_cast<FS_FLOAT>(ptRightBottom.x) ,static_cast<FS_FLOAT>(ptRightBottom.y)};
	stampInfo.rect = rect;
	stampInfo.imgtype = FPDF_IMAGETYPE_JPG; //bmp=1 jpg = 2
	stampInfo.imgdatasize = len;
	stampInfo.imgdata = (unsigned char*)buf;
    
    FPDF_Annot_Add(m_current_page, FPDF_ANNOTTYPE_STAMP, &stampInfo, sizeof(stampInfo), (FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    free(buf);
    [m_pdfview setNeedsDisplay];
	
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
}

-(void)AddNote:(CGPoint)pt1 secondPoint:(CGPoint)pt2 note:(NSString*)msg
{
   mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    mainDelegate.hasAnnotation=YES;
//    mainDelegate.AnnotationSaved=NO;
    int	nCount=0;
	FPDF_Annot_GetCount(m_current_page,&nCount);
    
	FPDF_ANNOT_NOTEINFO	noteAnnot;
	noteAnnot.size = sizeof(FPDF_ANNOT_NOTEINFO);
	noteAnnot.author[0] = 0;
	noteAnnot.opacity = 50;
	noteAnnot.icon = 0;
	noteAnnot.color = 0xffff00;
    NSString* string = [[NSString alloc] initWithFormat:@"%@",msg];
    noteAnnot.contents = (FS_LPCWSTR)[string cStringUsingEncoding:NSUnicodeStringEncoding];

    FS_RECTF rect = {static_cast<FS_FLOAT>(pt1.x - 12), static_cast<FS_FLOAT>(pt1.y -16),static_cast<FS_FLOAT>(pt1.x+ 12),static_cast<FS_FLOAT>(pt1.y+16)};
	noteAnnot.rect = rect;//noteRect;
    if(mainDelegate.highlightNow)
        [self deleteAllAnnot];
	FPDF_Annot_Add(m_current_page,FPDF_ANNOTTYPE_NOTE,&noteAnnot,noteAnnot.size,(FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;

    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
    [m_pdfview setNeedsDisplay];
    
}

- (void)AddStampAnnot:(CGPoint)ptLeftTop secondPoint:(CGPoint)ptRightBottom previousPoint:(CGPoint)prevPt
{
    
   // hasAnnotation=YES;
    
    
    // if(m_bAddStamp)
    //   return;
    m_bAddStamp = TRUE;
    int nCount=0;
	FPDF_Annot_GetCount(m_current_page,&nCount);
    //UIImage *myImage=[UIImage imageWithData:self.signatureData];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
							   stringByAppendingPathComponent:@"myimage.png"];
    // NSData *myImageData = UIImageJPEGRepresentation(UIImage *image, <#CGFloat compressionQuality#>)(myImage);
    [fileManager createFileAtPath:documentsPath contents:self.signatureData attributes:nil];
    
    NSLog(@"%@",documentsPath);
    const char* jpgpath = [documentsPath UTF8String];
    FILE* pf = fopen(jpgpath , "rb");
    
    if(!pf)
        return;
	fseek(pf, 0,SEEK_END);
	int len = ftell(pf);
	fseek(pf,0,SEEK_SET);
	unsigned char* buf = (unsigned char*)malloc(len);
	fread(buf, 1, len, pf);
	fclose(pf);
	//FS_RECT	noteRect;
	FPDF_ANNOT_STAMPINFO stampInfo;
	stampInfo.color = 0xff0000;
	stampInfo.size = sizeof(stampInfo);
    
    
    NSString* su=@"Signature";
   // NSString* su=[[NSString alloc]initWithString:@"Signature"];
    const unsigned char *intext=(unsigned char*)[su UTF8String];
    
    stampInfo.name[0]=intext[0];
    stampInfo.name[1]=intext[1];
    stampInfo.name[2]=intext[2];
    stampInfo.name[3]=intext[3];
    stampInfo.name[4]=intext[4];
    stampInfo.name[5]=intext[5];
    stampInfo.name[6]=intext[6];
    stampInfo.name[7]=intext[7];
    stampInfo.name[8]=intext[8];
    stampInfo.name[9]=intext[9];
    stampInfo.name[10]='\0';
    stampInfo.name[11]='\0';
    stampInfo.name[12]='\0';
    stampInfo.name[13]='\0';
    stampInfo.name[14]='\0';
    stampInfo.name[15]='\0';
    stampInfo.name[16]='\0';
    stampInfo.name[17]='\0';
    stampInfo.name[18]='\0';
    stampInfo.name[19]='\0';
    stampInfo.name[20]='\0';
    stampInfo.name[21]='\0';
    stampInfo.name[22]='\0';
    stampInfo.name[23]='\0';
    stampInfo.name[24]='\0';
    stampInfo.name[25]='\0';
    //    stampInfo.name[0]=c[0];
    
    
    //CGPoint ptLeftTop = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(120,120)];
    //CGPoint ptRightBottom = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(160, 160)];
    FS_RECTF rect = {static_cast<FS_FLOAT>(ptRightBottom.x - m_pdfview.annotationSignWidth/2), static_cast<FS_FLOAT>(ptRightBottom.y -m_pdfview.annotationSignHeight/2),static_cast<FS_FLOAT>(ptRightBottom.x+ m_pdfview.annotationSignWidth/2),static_cast<FS_FLOAT>(ptRightBottom.y+m_pdfview.annotationSignHeight/2)};
    //FS_RECTF rect = {ptRightBottom.x, ptRightBottom.y, ptLeftTop.x ,ptLeftTop.y};
	stampInfo.rect = rect;
	stampInfo.imgtype = FPDF_IMAGETYPE_JPG; //bmp=1 jpg = 2
	
    
    
    stampInfo.imgdatasize = len;
	stampInfo.imgdata = (unsigned char*)buf;
    //if(self.newAnnotation==NO)
    //{
   //Unused variable FPDF_ANNOT annot;
    //FPDF_Annot_GetAtPos(m_current_page, stampx,stampy, &annot);
    
    //FPDF_Annot_Delete(m_current_page,annot);
    m_nAnnotIndex--;
    //}
    
    stampx=ptRightBottom.x;
    stampy=ptRightBottom.y;
    FPDF_Annot_Add(m_current_page, FPDF_ANNOTTYPE_STAMP, &stampInfo, sizeof(stampInfo), (FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    free(buf);
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    
    
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
    [m_pdfview setNeedsDisplay];
	
    
}

-(CGPoint)searchNotesArray:(CGPoint)pt state:(NSString*)state{
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(note* obj in mainDelegate.Notes){
        if(pt.x<=obj.abscissa+12 && pt.x>=obj.abscissa-12 && pt.y<=obj.ordinate+16 && pt.y>=obj.ordinate-16){
            CGPoint pt1=CGPointMake(obj.abscissa,obj.ordinate);
            if([state isEqualToString:@"erase.."]){
                [mainDelegate.Notes removeObject:obj];
                mainDelegate.isAnnotated=YES;

            }
            else
                if(![state isEqualToString:@"search.."]){
                    int index=[mainDelegate.Notes indexOfObject:obj];
                    obj.note=state;
                    [mainDelegate.Notes setObject:obj atIndexedSubscript:index];
                    mainDelegate.isAnnotated=YES;
            }


            return pt1;
        }
    }
    for(note* obj in mainDelegate.IncomingNotes){
        if(pt.x<=obj.abscissa+12 && pt.x>=obj.abscissa-12 && pt.y<=obj.ordinate+16 && pt.y>=obj.ordinate-16){
            CGPoint pt1=CGPointMake(obj.abscissa,obj.ordinate);
            
            if([state isEqualToString:@"erase.."]){
                obj.status=@"DELETE";
            }
            else
                if(![state isEqualToString:@"search.."]){
                    obj.note=state;
                    obj.status=@"UPDATE";
                }
            if(![state isEqualToString:@"search.."]){
                [mainDelegate.Notes addObject:obj];
                [mainDelegate.IncomingNotes removeObject:obj];
                mainDelegate.isAnnotated=YES;
            }
            
            return pt1;
        }
    }

    return pt;
}
-(void)extractText:(CGPoint)pt1
{
    @try {
//       AppDelegate* mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        pt1=[self searchNotesArray:pt1 state:@"search.."];
        int annot_count = 0;
        FPDF_Annot_GetCount(m_current_page, &annot_count);
        
        FPDF_ANNOT annot;
        annotPoint=pt1;
        FS_RESULT res= FPDF_Annot_GetAtPos(m_current_page, pt1.x, pt1.y, &annot);
        
        // FPDF_Annot_Get(m_current_page, annot_count-1, &annot);
        
        int buf_size;
        if (res==FS_ERR_SUCCESS) {
            FPDF_Annot_GetInfo(m_current_page, annot, FPDF_ANNOTINFO_CONTENTS, NULL, (FS_LPDWORD)&buf_size);
            
            FS_WCHAR* char_buffer = new FS_WCHAR[buf_size];
            char_buffer[0] = '\0';
            
            FPDF_Annot_GetInfo(m_current_page, annot, FPDF_ANNOTINFO_CONTENTS, char_buffer, (FS_LPDWORD)&buf_size);
            buf_size=0;
            NSString* achived_string = [NSString stringWithFormat:@"%S", char_buffer];
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:achived_string delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            if (![achived_string isEqualToString:@""]) {
                
                
                UIView *myCustomView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
                [myCustomView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
                [myCustomView setAlpha:0.0f];
                
                
                
                UIButton *saveNote = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [saveNote addTarget:self action:@selector(saveCustomView:) forControlEvents:UIControlEventTouchUpInside];
                [saveNote setTitle:@"Save" forState:UIControlStateNormal];
                [saveNote setFrame:CGRectMake(20, 200, 240, 40)];
                [myCustomView addSubview:saveNote];
                
                
                UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [dismissButton addTarget:self action:@selector(dismissCustomView:) forControlEvents:UIControlEventTouchUpInside];
                [dismissButton setTitle:@"Close" forState:UIControlStateNormal];
                [dismissButton setFrame:CGRectMake(20, 250, 240, 40)];
                [myCustomView addSubview:dismissButton];
                
                
                textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 240, 150)];
                [textView setText:achived_string];
                [myCustomView addSubview:textView];
                
                [m_pdfview addSubview:myCustomView];
                
                [UIView animateWithDuration:0.2f animations:^{
                    [myCustomView setAlpha:1.0f];
                }];
                
                
            }
            
        }
    }  @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
        
    }
    
}

- (void)dismissCustomView:(UIButton *)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        [sender.superview setAlpha:0.0f];
    }completion:^(BOOL done){
        [sender.superview removeFromSuperview];
    }];
}

- (void)saveCustomView:(UIButton *)sender
{
    int annot_count = 0;
    FPDF_Annot_GetCount(m_current_page, &annot_count);
    FPDF_ANNOT annot;
    int index=0;
    FPDF_Annot_GetAtPos(m_current_page, annotPoint.x,annotPoint.y, &annot);
    FPDF_Annot_GetIndex(m_current_page, annot, &index);

    annotPoint=[self searchNotesArray:annotPoint state:textView.text];
    FPDF_Annot_Delete(m_current_page,annot);
    [self deleteAllAnnot];
    
    CGPoint XH,YH,ZH;
    for(HighlightClass* obj in mainDelegate.IncomingHighlights){
        XH=CGPointMake(obj.abscissa, obj.ordinate);
        YH=CGPointMake(obj.x1, obj.y1);
        [obj setIndex:([mainDelegate.IncomingHighlights indexOfObject:obj])];
        [self AddHighlightAnnot:XH secondPoint:YH previousPoint:ZH];
        mainDelegate.highlightNow=NO;
    }

    for(HighlightClass* obj in mainDelegate.Highlights){
        XH=CGPointMake(obj.abscissa, obj.ordinate);
        YH=CGPointMake(obj.x1, obj.y1);
        if(![obj.status isEqualToString:@"DELETE"]){
            [obj setIndex:([mainDelegate.Highlights indexOfObject:obj]+[mainDelegate.IncomingHighlights count])];
            [self AddHighlightAnnot:XH secondPoint:YH previousPoint:ZH];
        }
        mainDelegate.highlightNow=NO;
    }
    
    for(note* obj in mainDelegate.Notes){
        CGPoint point=CGPointMake(obj.abscissa, obj.ordinate);
        if(![obj.status isEqualToString:@"DELETE"])
            [self AddNote:point secondPoint:point  note:obj.note];
        mainDelegate.highlightNow=NO;
    }
        for(note* obj in mainDelegate.IncomingNotes){
        CGPoint point=CGPointMake(obj.abscissa, obj.ordinate);
        [self AddNote:point secondPoint:point  note:obj.note];
        mainDelegate.highlightNow=NO;
    }
    [m_pdfview setNeedsDisplay];

   // [self AddReplaceNote:annotPoint note:textView.text];
   // [m_pdfview setNeedsDisplay];

    [UIView animateWithDuration:0.2f animations:^{
        [sender.superview setAlpha:0.0f];
    }completion:^(BOOL done){
        [sender.superview removeFromSuperview];
    }];
}

-(void)AddReplaceNote:(CGPoint)pt1  note:(NSString*)msg
{

    int	nCount=0;
	FPDF_Annot_GetCount(m_current_page,&nCount);
    
	FPDF_ANNOT_NOTEINFO	noteAnnot;
	noteAnnot.size = sizeof(FPDF_ANNOT_NOTEINFO);
	noteAnnot.author[0] = 0;
	noteAnnot.opacity = 50;
	noteAnnot.icon = 0;
	noteAnnot.color = 0xffff00;
    NSString* string = [[NSString alloc] initWithFormat:@"%@",msg];
    noteAnnot.contents = (FS_LPCWSTR)[string cStringUsingEncoding:NSUnicodeStringEncoding];
	
	
    FS_RECTF rect = {static_cast<FS_FLOAT>(pt1.x - 12), static_cast<FS_FLOAT>(pt1.y -16),static_cast<FS_FLOAT>(pt1.x+ 12),static_cast<FS_FLOAT>(pt1.y+16)};
	noteAnnot.rect = rect;//noteRect;
	FPDF_Annot_Add(m_current_page,FPDF_ANNOTTYPE_NOTE,&noteAnnot,noteAnnot.size,(FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    
    
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
    [m_pdfview setNeedsDisplay];
	
    
}



- (void)AddFileAttachment
{		
    if(m_bAddFileAttach)
        return;
    m_bAddFileAttach = TRUE;
    int nCount = 0;
	FPDF_Annot_GetCount(m_current_page,&nCount);
    NSString *path = [[NSBundle mainBundle] pathForResource:AttachFileName ofType:@"pdf"];
    
    const char* attachpath = [path UTF8String];
    FILE* pfileattch = fopen(attachpath,"rb");
    if(!pfileattch)
        return;
	fseek(pfileattch, 0,SEEK_END);
	int filelen = ftell(pfileattch);
	fseek(pfileattch,0,SEEK_SET);
	unsigned char* fileattachBuf = (unsigned char*)malloc(filelen );
	fread(fileattachBuf , 1, filelen , pfileattch );
	fclose(pfileattch);
    

	FPDF_ANNOT_FILEATTACHMENTINFO attachInfo;
	attachInfo.size =sizeof(attachInfo);
	attachInfo.author[0] = 0;

    CGPoint ptLeftTop = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(160,160)];
    CGPoint ptRightBottom = [m_pdfview DeviceToPagePoint:m_current_page p1:CGPointMake(200, 200)];
    
    FS_RECTF rect = {static_cast<FS_FLOAT>(ptLeftTop.x), static_cast<FS_FLOAT>(ptLeftTop.y), static_cast<FS_FLOAT>(ptRightBottom.x), static_cast<FS_FLOAT>(ptRightBottom.y)};
	attachInfo.rect = rect;//noteRect;
	attachInfo.color = 0xff0000;
	attachInfo.opacity = 80;
	attachInfo.file_data = fileattachBuf;
	attachInfo.file_size = filelen;
	attachInfo.icon=0;
    FPDF_Annot_Add(m_current_page, FPDF_ANNOTTYPE_FILEATTACHMENT, &attachInfo, sizeof(attachInfo), (FPDF_ANNOT*)&m_nAnnotIndex);
    m_nAnnotIndex++;
    free(fileattachBuf);
    [m_pdfview setNeedsDisplay];
	
	
    NSString* dir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [dir stringByAppendingString:@"/FoxitSaveAnnotation.pdf"];
    const char* file = [path UTF8String];
    
    FILE* fp = fopen(file, "wb");
    FS_FILEWRITE fw;
    fw.clientData = fp;
    fw.Flush = FSFileWrite_Flush;
    fw.GetSize = FSFileWrite_GetSize;
    fw.WriteBlock = FSFileWrite_WriteBlock;
    
    FPDF_Doc_SaveAs(m_fpdfdoc, &fw, FPDF_SAVEAS_INCREMENTAL, NULL);
    fclose(fp);
}

- (void)deleteAnnot
{
  //  FPDF_Annot_GetInfo(m_current_page, FPDF_ANNOTTYPE_HIGHLIGHT, FS_INT32 infotype, FPDF_ANNOTINFO_RECT, sizeof(FPDF_ANNOTINFO_RECT));
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	m_nAnnotIndex--;
//    if(mainDelegate.Highlights.count<=m_nAnnotIndex)
//        m_nAnnotIndex=mainDelegate.Highlights.count-1;
//    if(mainDelegate.Highlights.count>0)
//    [mainDelegate.Highlights removeObjectAtIndex:m_nAnnotIndex];
    FPDF_Annot_Delete(m_current_page,(FPDF_ANNOT)m_nAnnotIndex);
    if(m_nAnnotIndex < 0)
        m_nAnnotIndex = 0;
	[m_pdfview setNeedsDisplay];
    

}

-(void)searchHighlightArray:(CGPoint)pt state:(NSString*)state index:(int)index{
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(HighlightClass* obj in mainDelegate.Highlights){
        
        if(obj.index == index){
            if([state isEqualToString:@"erase.."]){
                if(![obj.status isEqualToString:@"DELETE"])
                    [mainDelegate.Highlights removeObject:obj];
                mainDelegate.isAnnotated=YES;
                
            }
           
            return;
        }
    }
    for(HighlightClass* obj in mainDelegate.IncomingHighlights){
        if(obj.index == index){
            if([state isEqualToString:@"erase.."]){
                obj.status=@"DELETE";
            }
            if(![state isEqualToString:@"search.."]){
                [mainDelegate.Highlights addObject:obj];
                [mainDelegate.IncomingHighlights removeObject:obj];
                mainDelegate.isAnnotated=YES;
            }
            
            return;
        }
    }
    
    return;
}
- (void)deleteAllAnnot
{
    int count=0;
    FPDF_Annot_GetCount(m_current_page, &count);
 while(count>0){
	count--;
    FPDF_Annot_Delete(m_current_page,(FPDF_ANNOT)count);
	[m_pdfview setNeedsDisplay];
    
   }
    m_nAnnotIndex=count;

}
-(void)eraseAnnotation:(CGPoint)pt1 secondPoint:(CGPoint)pt2 {
    FPDF_ANNOT annot;
    
    pt1=[self searchNotesArray:pt1 state:@"erase.."];
    FPDF_Annot_GetAtPos(m_current_page, pt1.x,pt1.y, &annot);
    int index=0;
    FPDF_Annot_GetIndex(m_current_page, annot, &index);
    [self searchHighlightArray:pt1 state:@"erase.." index:index];
    FPDF_Annot_Delete(m_current_page,annot);
    [m_pdfview setNeedsDisplay];
    //[self deleteAnnot];
    [self deleteAllAnnot];
    CGPoint XH,YH,ZH;

    for(HighlightClass* obj in mainDelegate.IncomingHighlights){
        XH=CGPointMake(obj.abscissa, obj.ordinate);
        YH=CGPointMake(obj.x1, obj.y1);
        [obj setIndex:[mainDelegate.IncomingHighlights indexOfObject:obj]];
        
        [self AddHighlightAnnot:XH secondPoint:YH previousPoint:ZH];
        mainDelegate.highlightNow=NO;
    }
    for(HighlightClass* obj in mainDelegate.Highlights){
        XH=CGPointMake(obj.abscissa, obj.ordinate);
        YH=CGPointMake(obj.x1, obj.y1);
        if(![obj.status isEqualToString:@"DELETE"]){
            [obj setIndex:([mainDelegate.Highlights indexOfObject:obj]+[mainDelegate.IncomingHighlights count])];
            [self AddHighlightAnnot:XH secondPoint:YH previousPoint:ZH];
        }
        mainDelegate.highlightNow=NO;
    }
    
    for(note* obj in mainDelegate.Notes){
        CGPoint point=CGPointMake(obj.abscissa, obj.ordinate);
        if(![obj.status isEqualToString:@"DELETE"])
            [self AddNote:point secondPoint:point  note:obj.note];
        mainDelegate.highlightNow=NO;
    }
    
    for(note* obj in mainDelegate.IncomingNotes){
        CGPoint point=CGPointMake(obj.abscissa, obj.ordinate);
        [self AddNote:point secondPoint:point  note:obj.note];
        mainDelegate.highlightNow=NO;
    }

}

@end
