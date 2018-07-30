//
//  DSZ.h
//  AFNetworking
//
//  Created by Emmm on 2018/7/26.
//

#import <Foundation/Foundation.h>

@interface DSZ : NSObject
/**
 *  对象转换为字典
 *
 *  @param obj 需要转化的对象
 *
 *  @return 转换后的字典
 */
+ (NSDictionary*)getObjectData:(id)obj;
/**
 获取阿拉伯数字类型版本号
 
 @return 版本号字符串
 */
+(NSString *)getAppVersionNumber;
@end
