//
//  FileManager.m
//  CTSIpad
//
//  Created by DNA on 2/3/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager



+(void)appendToLogView:(NSString*)viewName function:(NSString*)functionName ExceptionTitle:(NSString*)title exceptionReason:(NSString*)reason{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"CTSLog.txt"];
    
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSData data] writeToFile:path atomically:YES];
    }
    
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[[NSString stringWithFormat:@"%@ Function:%@ Exception: %@:%@ \n",viewName,functionName,title,reason] dataUsingEncoding:NSUTF8StringEncoding]];
}

+(void)deleteFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString *myFilePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:myFilePath error:NULL];
    
}
@end
