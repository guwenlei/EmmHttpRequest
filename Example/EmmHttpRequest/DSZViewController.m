//
//  DSZViewController.m
//  EmmHttpRequest
//
//  Created by guwenlei on 07/30/2018.
//  Copyright (c) 2018 guwenlei. All rights reserved.
//

#import "DSZViewController.h"
#import "HttpRequestServer.h"

@interface DSZViewController ()

@end

@implementation DSZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://osaeb6trv.bkt.clouddn.com/StoryVoiceFild.json";
    [[HttpRequestServer shareInstance] sendRequestToPostData:nil
                                                         url:url
                                                successBlock:^(HttpResponseType httpResponseType, id responseData) {
                                                    if (httpResponseType == HttpSuccess) {
                                                        NSLog(@"%@",responseData);
                                                    }
                                                    
                                                } errorBlock:^(HttpResponseType httpResponseType, NSError *error, NSString *errorMsg, HttpResponseCode code, id responseData) {
                                                    NSLog(@"%@",errorMsg);
                                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
