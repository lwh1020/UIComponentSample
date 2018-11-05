//
//  HttpRequest.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 26..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface HttpRequest : NSObject

+ (instancetype)sharedInstance;

- (void)requestURL:(NSString *)baseURL
        parameters:(NSDictionary *)params;

- (void)requestURL:(NSString *)baseURL
        parameters:(NSDictionary *)params
         userAgent:(NSString *)userAgent
           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)requestBaseURL:(NSString *)baseURL
                method:(NSString *)methodType
                  path:(NSString *)path
             userAgent:(NSString *)userAgent
            parameters:(NSDictionary *)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)cancelAllRequest;
@end
