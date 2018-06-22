//
//  NSObject+GTReflection.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * NSObject 类的底层内容
 */

@interface NSObject (GTReflection)

//类名
- (NSString *)gt_className;
+ (NSString *)gt_className;
//父类名称
- (NSString *)gt_superClassName;
+ (NSString *)gt_superClassName;

//实例属性字典
-(NSDictionary *)gt_propertyDictionary;

//属性名称列表
- (NSArray*)gt_propertyKeys;
+ (NSArray *)gt_propertyKeys;

//属性详细信息列表
- (NSArray *)gt_propertiesInfo;
+ (NSArray *)gt_propertiesInfo;

//格式化后的属性列表
+ (NSArray *)gt_propertiesWithCodeFormat;

//方法列表
-(NSArray*)gt_methodList;
+(NSArray*)gt_methodList;

-(NSArray*)gt_methodListInfo;

//创建并返回一个指向所有已注册类的指针列表
+ (NSArray *)gt_registedClassList;
//实例变量
+ (NSArray *)gt_instanceVariable;

//协议列表
-(NSDictionary *)gt_protocolList;
+ (NSDictionary *)gt_protocolList;


- (BOOL)gt_hasPropertyForKey:(NSString*)key;
- (BOOL)gt_hasIvarForKey:(NSString*)key;

@end
