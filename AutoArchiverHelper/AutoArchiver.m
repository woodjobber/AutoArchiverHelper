//
//  AutoArchiver.m
//  Load
//
//  Created by zcb on 15-11-7.
//  Copyright (c) 2015年 zcb. All rights reserved.
//

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "AutoArchiver.h"
#import <objc/message.h>

@implementation AutoArchiver

// 返回self的所有对象名称
+ (NSArray *)propertyOfSelf{
    unsigned int count = 0;
    // 1. 获得类中的所有成员变量
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *propertyNames =[NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        // 2.获得成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 3.判断是否有"_"
        NSString *key = nil;
        if ([name hasPrefix:@"_"]) {
            // 剔除下划线，从第一个索引开始截取 到 结尾
             key = [name substringFromIndex:1];
        }else{
             key = [name substringFromIndex:0];
        }
        [propertyNames addObject:key];
    }
    
    return [propertyNames copy];
}

// 归档
- (void)encodeWithCoder:(NSCoder *)enCoder{
    // 取得所有成员变量名
    NSArray *properNames = [[self class] propertyOfSelf];
    for (NSString *propertyName in properNames) {
        // 创建指向get方法
        SEL getSel = NSSelectorFromString(propertyName);
        // 对每一个属性实现归档
        SuppressPerformSelectorLeakWarning([enCoder encodeObject:[self performSelector:getSel] forKey:propertyName]);
        
    }
}
// 解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    // 取得所有成员变量名
    NSArray *properNames = [[self class] propertyOfSelf];
    for (NSString *propertyName in properNames) {
        // 创建指向属性的set方法
        // 1.获取属性名的第一个字符，变为大写字母
        NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
        // 2.替换掉属性名的第一个字符为大写字符，并拼接出set方法的方法名
        NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]];
        SEL setSel = NSSelectorFromString(setPropertyName);
        SuppressPerformSelectorLeakWarning( [self performSelector:setSel withObject:[aDecoder decodeObjectForKey:propertyName]]);
        
    }
    return  self;
}
- (NSString *)description{
    
    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"];

    NSArray *properNames = [[self class] propertyOfSelf];
    for (NSString *propertyName in properNames) {
    
        SEL getSel = NSSelectorFromString(propertyName);
        NSString *propertyNameString = nil;
        id _getSel = nil;
        SuppressPerformSelectorLeakWarning(_getSel=[self performSelector:getSel]);
        propertyNameString = [NSString stringWithFormat:@"%@:%@,\n",propertyName,_getSel];
        //[descriptionString appendString:propertyNameString];
        [descriptionString appendFormat:@"%@",propertyNameString];
    }
    NSString *str_l = @"{"; NSString *str_m = @"}";
    NSString *desc = [NSString stringWithFormat:@"\n%@%@%@",str_l,descriptionString,str_m];
    return [desc copy];
}

@end
