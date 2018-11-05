//
//  ConnectionManager.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 26..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "ConnectionManager.h"
#import "HttpRequest.h"

static NSTimer *timer;

@interface ConnectionManager()

@end

@implementation ConnectionManager

-(instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param {
    [self requestToServer:urlString withParam:param requestCode:-1 success:nil];
}

- (void)requestToServer:(NSString *)urlString requestCode:(NSInteger)reqCode {
    [self requestToServer:urlString withParam:@{} requestCode:reqCode];
}

- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param requestCode:(NSInteger)reqCode {
    [self requestToServer:urlString withParam:param requestCode:reqCode success:nil];
}

- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success {
    [self requestToServer:urlString withParam:param requestCode:-1 success:success];
}

- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param requestCode:(NSInteger)reqCode
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success {
    
    HttpRequest *conn = [HttpRequest sharedInstance];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(connectionTimeOut) userInfo:nil repeats:NO];
    
    NSMutableDictionary *defaultParam = [[NSMutableDictionary alloc] initWithDictionary:param];
    [defaultParam setObject:@"SG" forKey:@"nationCd"];
    [defaultParam setObject:@"L005" forKey:@"langCd"];
    [defaultParam setObject:@"I" forKey:@"deviceType"];
    
    UIDevice *device = [[UIDevice alloc] init];
    NSString *idForVend = [NSString stringWithFormat:@"%@", [device identifierForVendor]];
    [defaultParam setObject:idForVend forKey:@"deviceId"];
    
    NSString *userAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAgent"];
    
    [conn requestURL:urlString parameters:defaultParam userAgent:userAgent
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                 
                 if(success) {
                     success(request, response, JSON);
                 } else {
                     [self connectionSuccess:response json:JSON requestCode:reqCode];
                 }
                 
                 [timer invalidate];
                 
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 
                 NSLog(@"\nAPI 로드 실패! \n -> %@\n[REASON] %@\n", urlString, error);
                 [self connectionFailure:error ServerResponse:response requestCode:reqCode];
             }];
}

// 성공시 공통 처리
- (void)connectionSuccess:(NSHTTPURLResponse *)response json:(id)JSON requestCode:(NSInteger)reqCode {
    NSLog(@">> [connectionSuccess] json: %@ \n reqCode: %ld", JSON, (long)reqCode);
    
    if([self.delegate respondsToSelector:@selector(didFinishedServerResponse:json:requestCode:)]) {
        [self.delegate didFinishedServerResponse:response json:JSON requestCode:reqCode];
    }
}

// 실패시 공통 처리
- (void)connectionFailure:(NSError *)error ServerResponse:(NSURLResponse *)response requestCode:(NSInteger)reqCode {
    NSLog(@">> [connectionFailure] error: %@ \n reqCode: %ld", error, (long)reqCode);
    
    // Http Queue 작업 취소
    [[HttpRequest sharedInstance] cancelAllRequest];
}

- (void)connectionTimeOut {
    
    NSLog(@"Connection Time Out! __ ");
    [timer invalidate];
}

@end
