//
//  BaseNetWork.m
//  AFNetworking
//
//  Created by Emmm on 2018/7/26.
//

#import "BaseNetWork.h"
#import "DSZ.h"

#define SYS_TIME_OUT 60

@implementation BaseNetWork
- (id)init{
    if (self = [super init]) {
        [self configManager];
    }
    return self;
}
- (void)configManager{
    self.httpManager = [AFHTTPSessionManager manager];
    self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.httpManager.requestSerializer.timeoutInterval = SYS_TIME_OUT;
    
    self.httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    self.httpManager.securityPolicy.allowInvalidCertificates = YES;
    [self.httpManager.securityPolicy setValidatesDomainName:NO];
    
    //关闭缓存避免干扰测试
    self.httpManager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
    
}

/**
 成功回调
 */
- (void)requestSuccess:(id)requestData
          successBlock:(HttpSuccessResultBlock)successBlock
            errorBlock:(HttpErrorResultBlock)errorBlock{
    if ([self checkRejectWithResponseObject:requestData] == NO) return;
    
    NSString *responseString = [[NSString alloc] initWithData: requestData
                                                     encoding: NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (![responseDictionary isKindOfClass:[NSDictionary class]]) {
        errorBlock(HttpApiError,nil,responseString,HttpResponseSysSuccess,responseDictionary);
        return;
    }
    successBlock(HttpSuccess,responseDictionary);
    //data如果有状态码code可去掉注释
//    NSNumber *reNum = responseDictionary[@"code"];
//    // 成功
//    if (reNum && [reNum isKindOfClass:[NSNumber class]] && reNum.integerValue == 1){
//        successBlock(HttpSuccess,responseDictionary);
//    }
//    // 失败
//    else{
//        NSString *msg = @"未知错误";
//        if (responseDictionary[@"msg"]) {
//            msg = responseDictionary[@"msg"];
//        }else if (responseDictionary[@"message"]){
//            msg = responseDictionary[@"message"];
//        }
//
//        errorBlock(HttpApiError,nil,msg,HttpResponseSysSuccess,responseDictionary);
//
//    }
}

/**
 失败回调
 */
-(void)requestError:(NSError *)error errorBlock:(HttpErrorResultBlock) errorBlock{
    
    // 访问被限制
    if (error.code == -1005) {
        
    }
    // 请求被中断
    else if(error.code == -999) {
        
    }
    // 请求超时
    else if (error.code == -1001){
        errorBlock(HttpSysError,error,@"请求超时",HttpResponseSysTimeOut,nil);
    }
    // 没有网络、网络连接失败
    else if (error.code == -1009){
        errorBlock(HttpSysError,error,@"网络连接失败",HttpResponseSysNoNetWork,nil);
    }
    else{
        errorBlock(HttpSysError,error,error.description,HttpResponseSysTimeOut,nil);
    }
}

/**
 检查参数
 */
- (BOOL)checkRejectWithResponseObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSNumber *num = responseObject[@"code"];
        if ([num isKindOfClass:[NSNumber class]] && (num.integerValue == 40006))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LGreject" object:nil];
            return NO;
        }
    }
    return YES;
}
/**
 添加公共的请求信息
 
 @param entity 请求实体
 @return 最终的请求参数
 */
-(NSMutableDictionary *)addCommoneRequestParams:(id)params{
    NSMutableDictionary *postBody = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        postBody = [NSMutableDictionary dictionaryWithDictionary:params];
    }else{
        postBody = (NSMutableDictionary*)[DSZ getObjectData:params];
    }
    if (postBody == nil) {
        postBody = [[NSMutableDictionary alloc ] init];
    }
    
    
    return postBody;
}
- (NSString *)dateToString:(NSDate *)date
              formatString:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc ] init];
    [NSTimeZone resetSystemTimeZone];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:formatString];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    return [dateFormatter stringFromDate:date];
}

@end
