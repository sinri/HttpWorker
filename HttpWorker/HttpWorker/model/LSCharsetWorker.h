//
//  LSCharsetWorker.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCharsetWorker : NSObject
+(NSStringEncoding)getEncoding:(NSString*)name;
+(NSString*)dataToString:(NSData*)data usingEncoding:(NSString*)encodingName;
@end
