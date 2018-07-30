//
//  BaseNetWork.h
//  AFNetworking
//
//  Created by Emmm on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, HttpResponseType) {
    HttpSysError = 10,
    HttpApiError = 11,
    HttpSuccess  = 12
};
typedef NS_ENUM(NSInteger,HttpResponseCode) {
    //请求超时
    HttpResponseSysTimeOut = -1001,
    HttpResponseSysNoNetWork = -1009,
    HttpResponseSysSuccess
};
typedef void (^HttpErrorResultBlock)(HttpResponseType httpResponseType ,NSError *error, NSString *errorMsg, HttpResponseCode code,id responseData);
typedef void (^HttpSuccessResultBlock)(HttpResponseType httpResponseType,id responseData);
@interface BaseNetWork : NSObject
@property (nonatomic,strong) AFHTTPSessionManager *httpManager;

/**
 http失败回调
 */
- (void)requestError:(NSError *)error
          errorBlock:(HttpErrorResultBlock) errorBlock;

/**
 http成功回调
 */
- (void)requestSuccess:(id)requestData
          successBlock:(HttpSuccessResultBlock ) successBlock
            errorBlock:(HttpErrorResultBlock) errorBlock;

/**
 添加公共请求信息

 @param params 请求参数
 @return 最终请求参数
 */
- (NSMutableDictionary *)addCommoneRequestParams:(id)params;


/**
 日期格式化
 */
- (NSString *)dateToString:(NSDate *)date
              formatString:(NSString *)formatString;

/**
 检查参数
 */
- (BOOL)checkRejectWithResponseObject:(id)responseObject;
@end
