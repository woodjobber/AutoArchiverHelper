//
//  Person.h
//  Load
//
//  Created by zcb on 15-11-8.
//  Copyright (c) 2015年 zcb. All rights reserved.
//

#import "AutoArchiverHelper.h"

@interface Person : AutoArchiverHelper
{
    NSString *_name;
    NSString *age;
    NSString *sex;
    NSString *_ID;
}
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *age;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *ID;
@end
