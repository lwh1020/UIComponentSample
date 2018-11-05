//
//  ConnectionManager.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 26..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate <NSObject>

@optional
- (void)didFinishedServerResponse:(NSURLResponse *)response json:(id)JSON requestCode:(NSInteger)reqCode;

@end

@interface ConnectionManager : NSObject

@property (nonatomic, weak) id<ConnectionManagerDelegate> delegate;

- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param;
- (void)requestToServer:(NSString *)urlString requestCode:(NSInteger)reqCode;
- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param requestCode:(NSInteger)reqCode;
- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param
                success:(void (^ _Nullable )(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success;
- (void)requestToServer:(NSString *)urlString withParam:(NSDictionary *)param requestCode:(NSInteger)reqCode
                success:(void (^ _Nullable )(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success;
@end

