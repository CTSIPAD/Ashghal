//
//  FileManager.h
//  CTSIpad
//
//  Created by DNA on 2/3/14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(void)appendToLogView:(NSString*)viewName function:(NSString*)functionName ExceptionTitle:(NSString*)title exceptionReason:(NSString*)reason;
+(void)deleteFileName:(NSString*)fileName;

@end
