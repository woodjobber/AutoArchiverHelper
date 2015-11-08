
//
//  AutoArchiverHelper.m
//  Load
//
//  Created by chengbin on 15-11-8.
//  Copyright (c) 2015年 chengbin(woodjobber). All rights reserved.
//
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#import "AutoArchiverHelper.h"
#import <objc/message.h>
/*!
 获得类中所有的成员变量
 @param cls 当前类 即 self 
 @return 成员变量数组
*/
static NSArray *GetIvarList(Class cls)
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc]initWithCapacity:0];
    unsigned int IvarCount = 0;
    Ivar*ivars= class_copyIvarList(cls, &IvarCount);
    unsigned int i;
    for (i = 0; i < IvarCount; i++) {
        Ivar aIvar = ivars[i];
        const char *name = ivar_getName(aIvar);
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [propertyNames addObject:nameStr];
    }
    free(ivars);
    return propertyNames.copy;
}
@interface AutoArchiverHelper()<NSCoding>

@end

@implementation AutoArchiverHelper
#pragma mark -- 实现 NSCoding 协议

//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *propertyNames = GetIvarList([self class]);
  
    for (NSString *name in propertyNames) {
        id value = [self valueForKey:name];
        [encoder encodeObject:value forKey:name];
    }
}

//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        NSArray *propertyNames = GetIvarList([self class]);
        
        for (NSString *key in propertyNames) {
        
            id value = [decoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
        
    }

    return self;
}
//重写 desctiption 方法
- (NSString *)description{
    
    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"];

    NSArray *properNames = GetIvarList([self class]);
    
    for (NSString *propertyName in properNames) {
    
        NSString *key = nil;
        
        // 在这里一定要注意，需要除去'_'
        if ([propertyName hasPrefix:@"_"]) {
            
            key = [propertyName substringFromIndex:1];
        }else{
            key = [propertyName substringFromIndex:0];
        }
        SEL getSel = NSSelectorFromString(key);
        
        NSString *propertyNameString = nil;
        
        id _getSel = nil;
        
        SuppressPerformSelectorLeakWarning(_getSel=[self performSelector:getSel]);
        
        propertyNameString = [NSString stringWithFormat:@"%@:%@,\n",key,_getSel];

        [descriptionString appendFormat:@"%@",propertyNameString];
    }
    NSString *str_n = @"{";
    
    NSString *str_m = @"}";
    
    NSString *desc = [NSString stringWithFormat:@"\n%@%@%@",str_n,descriptionString,str_m];
    
    return [desc copy];
}
@end
