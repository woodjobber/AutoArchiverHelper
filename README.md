# AutoArchiverHelper
##利用Runtime 实现自动化归档与解档

##说明:
      要实现自动化归档，需要继承 AutoArchiverHelper 类,子类中不需要再遵循NSCoding协议,以及不需要实现
   ```- (void)encodeWithCoder:(NSCoder *)encoder```;  ```- (id)initWithCoder:(NSCoder *)decoder``` 方法.
   
      使用方法，很简单 仅仅是继承这个类就行，无论你的 成员变量 带与不带 “_”,都可以正确归档与解挡。像这样:
 
###1.建立`Person`类

     #import "Person.h"

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
 
       Person.m中
   
         @implementation Person
   
         @synthesize name=_name,ID=_ID,age=age,sex=sex;
   
         @end
 ###2.在其他类使用导入 `#import"AutoArchiverHelper.h"`.
 
 ####xxx.m中
 
        NSString *file2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject        stringByAppendingPathComponent:@"person.data"];
   
         Person *person = [[Person alloc]init];
   
        person.name = @"jack";
   
        person.age =@"11";
   
        person.ID =@"510722199912121212";
  
        person.sex = @"man";
   
       [NSKeyedArchiver archiveRootObject:person toFile:file2];

       Person *jack =[NSKeyedUnarchiver unarchiveObjectWithFile:file2];
   
       NSLog(@"%@",jack.name);
   
       NSLog(@"%@",jack.age);
   
       NSLog(@"%@",jack.ID);
   
      NSLog(@"%@",jack.sex);
   
       NSLog(@"%@",jack);
   
