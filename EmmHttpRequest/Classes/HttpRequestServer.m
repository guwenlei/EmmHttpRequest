//
//  HttpRequestServer.m
//  AFNetworking
//
//  Created by Emmm on 2018/7/26.
//

#import "HttpRequestServer.h"
#import "DSZ.h"
#import "YYCache.h"

#define WEAKSELF __weak __typeof(self) weakSelf = self;
static NSString *const cacheName=@"DSZHttpJsonString";
@implementation HttpRequestServer
+ (HttpRequestServer *)shareInstance{
    static HttpRequestServer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpRequestServer alloc]init];
    });
    return instance;
}
- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)requestCanelOne {
    [[[[self.httpManager operationQueue] operations] lastObject] cancel];
}
- (void)requestCanelAll {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self.httpManager operationQueue] cancelAllOperations];
}
/**
 POST方式请求
 
 @param requestParams 请求参数:接受字典和对象
 @param url 接口名
 @param successBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sendRequestToPostData:(id)requestParams
                          url:(NSString *)url
                 successBlock:(HttpSuccessResultBlock)successBlock
                   errorBlock:(HttpErrorResultBlock)errorBlock{
    NSLog(@"✋ sendRequestToPostURL: %@",url);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    // api 参数
    NSMutableDictionary *postData = [[NSMutableDictionary alloc ] init];
    if ([requestParams isKindOfClass:[NSDictionary class]]) {
        postData = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    }else if (requestParams!=nil){
        postData = (NSMutableDictionary *)[DSZ getObjectData:requestParams];
    }
    
    // 添加公共参数
    //[postData addEntriesFromDictionary:model];
    
    
    
    WEAKSELF
    [self.httpManager POST:url
                parameters:postData
                  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [weakSelf requestSuccess:responseObject
                    successBlock:successBlock
                      errorBlock:errorBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [weakSelf requestError:error
                    errorBlock:errorBlock];
    }];
}
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
                   errorBlock:(HttpErrorResultBlock) errorBlock{
    YYCache *httpCache = [[YYCache alloc]initWithName:cacheName];
    __block NSDictionary *jsonData;
    NSString *disc_key = [NSString stringWithFormat:@"%@_%@",url,[DSZ getAppVersionNumber]];
    [httpCache.diskCache objectForKey:disc_key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        
        if (object == nil) {
            return;
        }
        jsonData = (NSDictionary *)object;
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(HttpSuccess,object);
        });
    }];
    [self sendRequestToPostData:requestParams url:url successBlock:^(HttpResponseType httpResponseType, id responseData) {
        // 缓存不存在、设置缓存
        if (jsonData == nil) {
            [httpCache.diskCache setObject:responseData forKey:disc_key];
        }
        // 缓存数据和接口请求数据相同不处理
        else if ([jsonData isEqualToDictionary:responseData]){
            return ;
        }
        // 更新数据
        else{
            [httpCache.diskCache setObject:responseData forKey:disc_key];
        }
        successBlock(httpResponseType,responseData);
    } errorBlock:^(HttpResponseType httpResponseType, NSError *error, NSString *errorMsg, HttpResponseCode code, id responseData) {
        errorBlock(httpResponseType,error,errorMsg,code,responseData);
    }];
}
@end
