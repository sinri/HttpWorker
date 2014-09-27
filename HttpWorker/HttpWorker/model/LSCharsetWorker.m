//
//  LSCharsetWorker.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSCharsetWorker.h"

static NSDictionary * encodingMapping=nil;

@implementation LSCharsetWorker

+(NSDictionary*)getEncodingMapping{
    if(!encodingMapping){
        encodingMapping=@{
                          @"ASCII":[NSNumber numberWithUnsignedInteger:NSASCIIStringEncoding],
                          @"UTF8": [NSNumber numberWithUnsignedInteger: NSUTF8StringEncoding],
                          @"Unicode": [NSNumber numberWithUnsignedInteger: NSUnicodeStringEncoding],
                          @"JapaneseEUC": [NSNumber numberWithUnsignedInteger: NSJapaneseEUCStringEncoding],
                          @"ShiftJIS": [NSNumber numberWithUnsignedInteger: NSShiftJISStringEncoding],
                          @"GBK": [NSNumber numberWithUnsignedInteger: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)],
                          @"BIG5": [NSNumber numberWithUnsignedInteger: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)],
                          };
    }
    return encodingMapping;
}
+(NSStringEncoding)getEncoding:(NSString*)name{
    NSNumber * num=[[LSCharsetWorker getEncodingMapping]objectForKey:name];
    if(num && ![num isEqual:[NSNull null]]){
        return [num unsignedIntegerValue];
    }else{
        return NSUTF8StringEncoding;
    }
}

//+(NSString*)dataToStringUsingGBK:(NSData*)data{
//    //声明一个gbk编码类型
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
//    NSString *zhuanHuanHouDeShuJu = [[NSString alloc] initWithData:data encoding:gbkEncoding];
//    return zhuanHuanHouDeShuJu;
//}
+(NSString*)dataToString:(NSData*)data usingEncoding:(NSString*)encodingName{
    if(!data || !encodingName){
        return nil;
    }else{
        NSStringEncoding encoding = [LSCharsetWorker getEncoding:encodingName];
        NSString * str=[[NSString alloc]initWithData:data encoding:encoding];
        return str;
    }
}
@end
