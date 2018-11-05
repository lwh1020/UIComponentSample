//
//  HttpRequest.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 26..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking.h>

@interface HttpRequest()

@property (strong) NSOperationQueue *httpQueue;
@end

@implementation HttpRequest

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static HttpRequest *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        self.httpQueue = [[NSOperationQueue alloc] init];
        [self.httpQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)requestURL:(NSString *)baseURL
        parameters:(NSDictionary *)params {
    
    [self requestURL:baseURL parameters:params userAgent:@"" success:nil failure:nil];
}

- (void)requestURL:(NSString *)baseURL
       parameters:(NSDictionary *)params
        userAgent:(NSString *)userAgent
          success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
          failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    NSString *scheme = url.scheme;
    NSString *host = url.host;
    NSNumber *port = url.port;
    NSString *path = url.path;
    NSString *queryString = url.query;
    
    NSMutableString *baseURLString = [[NSMutableString alloc] init];
    [baseURLString appendString:scheme];
    [baseURLString appendString:@"://"];
    [baseURLString appendString:host];
    
    if (port) {
        [baseURLString appendFormat:@":%@", [port stringValue]];
    }
    
    NSMutableDictionary *parameters;
    
    if(params) {
        parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    } else {
        parameters = [[NSMutableDictionary alloc] init];
    }
    
    if(queryString) {
        NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    
        for (NSString *keyValuePair in urlComponents) {
            
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            
            [parameters setValue:value forKey:key];
        }
    }
    
    [self requestBaseURL:baseURLString method:@"POST" path:path userAgent:userAgent parameters:parameters success:success failure:failure];
}

- (void)requestBaseURL:(NSString *)baseURL
                method:(NSString *)methodType
                  path:(NSString *)path
             userAgent:(NSString *)userAgent
            parameters:(NSDictionary *)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    
    [self.httpQueue addOperationWithBlock:^{
        @autoreleasepool {
            
            NSURL *url = [NSURL URLWithString:baseURL];
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
            
            // HTTP MANAGER REACHABILITY
            NSOperationQueue *operationQueue = manager.operationQueue;
            [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                        [operationQueue setSuspended:NO];
                        break;
                        
                    case AFNetworkReachabilityStatusNotReachable:
                    default:
                        [operationQueue setSuspended:YES];
                        break;
                }
            }];
            [manager.reachabilityManager startMonitoring];
            
            // GET WITH AFHTTPREQUESTOPERATION
            [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
            [[manager securityPolicy] setAllowInvalidCertificates:YES];
            [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/javascript", @"text/html", nil]];
            
            [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
            
            NSMutableDictionary *dictionaryParams = [NSMutableDictionary dictionaryWithDictionary:params];
            dictionaryParams = [NSMutableDictionary dictionaryWithDictionary:params];
            
            // POST GET URL-FORM-ENCODED REQUEST
            if ([methodType isEqualToString:@"POST"]) {
                [manager POST:path
                   parameters:dictionaryParams
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(success)
                              success(operation.request, operation.response, responseObject);
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if(failure)
                              failure(operation.request, operation.response, error);
                      }];
                
            } else {
                
                [manager GET:path
                  parameters:dictionaryParams
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if(success)
                             success(operation.request, operation.response, responseObject);
                     }
                     failure:^(AFHTTPRequestOperation * operation, NSError *error) {
                         if(failure)
                             failure(operation.request, operation.response, error);
                     }];
            }
        }
    }];
}

- (void)cancelAllRequest {
    [self.httpQueue cancelAllOperations];
}

@end
