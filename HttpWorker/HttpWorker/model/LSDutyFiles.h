//
//  LSDutyFiles.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSHttpDuty.h"


@interface LSDutyFiles : NSObject
+(NSMutableArray*)getDutyFileArray;
+(BOOL)saveDuty:(LSHttpDuty*)duty;
+(NSString*)pathForDutyName:(NSString*)name;
@end
