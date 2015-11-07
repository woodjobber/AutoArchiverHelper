//
//  ViewController.m
//  AutoArchiverHelper
//
//  Created by zcb on 15-11-8.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *file2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.data"];
    Person *person = [[Person alloc]init];
    person.name = @"jack";
    person.age =@"11";
    person.ID =@"510722199912121213x";
    person.sex = @"man";
    
    [NSKeyedArchiver archiveRootObject:person toFile:file2];
    
    Person *jack =[NSKeyedUnarchiver unarchiveObjectWithFile:file2];
    NSLog(@"jack.name =%@",jack.name);
    NSLog(@"jack.age =%@",jack.age);
    NSLog(@"jack.ID =%@",jack.ID);
    NSLog(@"jack.sex =%@",jack.sex);
    NSLog(@"%@",jack);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
