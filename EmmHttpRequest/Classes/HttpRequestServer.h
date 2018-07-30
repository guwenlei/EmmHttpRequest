//
//  HttpRequestServer.h
//  AFNetworking
//
//  Created by Emmm on 2018/7/26.
//

#import "BaseNetWork.h"

@interface HttpRequestServer : BaseNetWork
+ (HttpRequestServer *)shareInstance;


/**
 POST方式请求

 @param requestParams 请求参数:接受字典和对象
 @param url 接口名
 @param successBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sendRequestToPostData:(id) requestParams
                          url:(NSString *) url
                 successBlock:(HttpSuccessResultBlock) successBlock
                   errorBlock:(HttpErrorResultBlock) errorBlock;

/**
 POST方式请求

 @param requestParams 请求参数:接受字典和对象
 @param url 接口名
 @param isCache 缓存
 @param successBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sendRequestToPostData:(id) requestParams
                          url:(NSString *) url
                      isCache:(BOOL)isCache
                 successBlock:(HttpSuccessResultBlock) successBlock
                   errorBlock:(HttpErrorResultBlock) errorBlock;

/**
 * 取消一个请求
 */
-(void)requestCanelOne;

/**
 * 取消所有请求
 */
-(void)requestCanelAll;
@end
