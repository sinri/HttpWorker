//
//  LSDutyFiles.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSDutyFiles.h"

static NSMutableArray * dutyFileArray=nil;
@implementation LSDutyFiles
+(NSMutableArray*)getDutyFileArray{
//    if(!dutyFileArray){
        dutyFileArray=[[NSMutableArray alloc]init];
//    }
    
    // 获取程序Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError * error=nil;
    NSArray * files=[[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if(files && [files count]){
        for (NSString * fn in files) {
            if([fn hasSuffix:@".json"]){
                [dutyFileArray addObject:[documentsDirectory stringByAppendingPathComponent:fn]];
            }
        }
    }
//    NSLog(@"get duties: %@",dutyFileArray);
    return dutyFileArray;
}
+(BOOL)saveDuty:(LSHttpDuty*)duty{
    NSString * json=[duty toJSON];
    // 获取程序Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fn= [[documentsDirectory stringByAppendingPathComponent:duty.dutyName]stringByAppendingPathExtension:@"json"];
    //save
    NSError * error=nil;
    BOOL done=[json writeToFile:fn atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"save duty: file=%@ json=%@ done=%@ error=%@",fn,json,(done?@"Y":@"N"),error);
    return done;
}
+(NSString*)pathForDutyName:(NSString*)name{
    // 获取程序Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fn= [[documentsDirectory stringByAppendingPathComponent:name]stringByAppendingPathExtension:@"json"];
    return name;
}
@end
