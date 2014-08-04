//
//  CAttachment.m
//  CTSTest
//
//  Created by DNA on 12/12/13.
//  Copyright (c) 2013 LBI. All rights reserved.
//

#import "CAttachment.h"

@implementation CAttachment{
    NSMutableData *_responseData;
    NSString *tempPdfLocation;
    AppDelegate *mainDelegate;
}
@synthesize tempPdfLocation,HighlightAnnotations,NoteAnnotations;
-(id) initWithTitle:(NSString*)title docId:(NSString*)did url:(NSString*)url  thumbnailBase64:(NSString*)thumbnailBase64 location:(NSString*)folderName{
    self.NoteAnnotations=[[NSMutableArray alloc]init];
    self.HighlightAnnotations=[[NSMutableArray alloc]init];
    if ((self = [super init])) {
        self.title=title;
        self.docId=did;
        self.url=url;
        self.thumbnailBase64=thumbnailBase64;
        self.location=folderName;
    }
    return self;
    
}

-(id) initWithTitle:(NSString*)title docId:(NSString*)did url:(NSString*)url  thumbnailBase64:(NSString*)thumbnailBase64 location:(NSString*)folderName SiteId:(NSString*)SiteId FileId:(NSString*)FileId FileUrl:(NSString *)FileUrl ThubnailUrl:(NSString*)ThubnailUrl isOriginalMail:(NSString*)isOriginalMail{
    
    self.NoteAnnotations=[[NSMutableArray alloc]init];
    self.HighlightAnnotations=[[NSMutableArray alloc]init];

    if ((self = [super init])) {
        self.title=title;
        self.docId=did;
        self.url=url;
        self.thumbnailBase64=thumbnailBase64;
        self.location=folderName;
        self.FileId = FileId;
        self.FileUrl = FileUrl;
        self.SiteId = SiteId;
        self.ThubnailUrl = ThubnailUrl;
        self.isOriginalMail=isOriginalMail;
    }
    
    
    return self;
}


-(NSString *)saveInCacheinDirectory:(NSString*)dirName fromSharepoint:(BOOL)isSharePoint
{
    
    @try {
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        tempPdfLocation=@"";
       
        NSString*strUrl;
        
        strUrl= [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mainDelegate.docUrl = strUrl;
        mainDelegate.SiteId = self.SiteId;
        mainDelegate.FileId = self.FileId;
        mainDelegate.FileUrl = self.FileUrl;
        mainDelegate.AttachmentId=self.AttachmentId;
        [mainDelegate.IncomingHighlights removeAllObjects];
        [mainDelegate.IncomingNotes removeAllObjects];
        [mainDelegate.IncomingHighlights addObjectsFromArray:self.HighlightAnnotations];
        [mainDelegate.IncomingNotes addObjectsFromArray:self.NoteAnnotations];
        //strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"%5C"];

        NSRange findit = [strUrl rangeOfString:@"%5C" options:NSBackwardsSearch];
        if(findit.location!=NSNotFound){
            NSLog(@"it is find");
        }
        else{
            
            NSRange lastComma = [strUrl rangeOfString:@"/" options:NSBackwardsSearch];
            
            if(lastComma.location != NSNotFound) {
                strUrl = [strUrl stringByReplacingCharactersInRange:lastComma
                                                         withString: @"%5C"];
            }
        }


        
        
        NSURL *url=[NSURL URLWithString:strUrl];

        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *path = [cachesDirectory stringByAppendingPathComponent:dirName];
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {
                NSLog(@"Create directory error: %@", error);
            }
        }
        
        
        NSString* pdfCacheName = [self.url lastPathComponent];
        
        tempPdfLocation = [path stringByAppendingPathComponent:pdfCacheName];
         BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:tempPdfLocation];
         if(!fileExists){
        if(isSharePoint==YES)
        {
          //  NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:url];
           // NSLog(@"%@",url);
         //  NSLog(@"%@",tempPdfLocation);
         // NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
           //jen sharepoint connection
            NSData *data = [NSData dataWithContentsOfURL:url ];
            if(data.length!=0)
                [data writeToFile:tempPdfLocation atomically:TRUE];
            else tempPdfLocation=@"";
        }
        else
        {
         
                NSData *data = [NSData dataWithContentsOfURL:url ];
            if(data.length!=0)
                [data writeToFile:tempPdfLocation atomically:TRUE];
            else tempPdfLocation=@"";
                   }
         }
        
      //   }
      //  else tempPdfLocation=@"Document extension not supported.";
        
    }
    @catch (NSException *ex) {
        [FileManager appendToLogView:@"CAttachment" function:@"saveInCacheinDirectory" ExceptionTitle:[ex name] exceptionReason:[ex reason]];
    }
    @finally {
        
    }
    return tempPdfLocation;
    
    
	
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"ever-me\\moss.account" password:@"moss.account" persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    NSFileHandle *hFile = [NSFileHandle fileHandleForWritingAtPath:tempPdfLocation];
    if (!hFile)
    {   //nope->create that file!
        [[NSFileManager defaultManager] createFileAtPath:tempPdfLocation contents:nil attributes:nil];
        //try to open it again...
        hFile = [NSFileHandle fileHandleForWritingAtPath:tempPdfLocation];
    }
    //did we finally get an accessable file?
    if (!hFile)
    {   //nope->bomb out!
        NSLog(@"could not write to file %@", tempPdfLocation);
        return;
    }
    //we never know - hence we better catch possible exceptions!
    @try
    {
        //seek to the end of the file
        [hFile seekToEndOfFile];
        //finally write our data to it
        [hFile writeData:data];
        
    }
    @catch (NSException * e)
    {
        NSLog(@"exception when writing to file %@", tempPdfLocation);
        // result = NO;
    }
    [hFile closeFile];
    [_responseData appendData:data];
    
    // [data writeToFile:tempPdfLocation atomically:TRUE];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}



@end
