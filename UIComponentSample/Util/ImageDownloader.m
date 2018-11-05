//
//  ImageDownloader.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 29..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()

@property (strong) NSOperationQueue *imageDownloadQueue;
@end

@implementation ImageDownloader

- (id)init {
    
    self = [super init];
    if(self) {
        _imageDownloadQueue = [[NSOperationQueue alloc] init];
        [_imageDownloadQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)downloadImageFromUrl:(NSURL *)imageURL completionBlock:(ImageDownloadQueueCompletionBlock)completionBlock {
    
    __block UIImage *downloadImage = nil;
    __block NSString *urlString = nil;
    __block NSError *error = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @autoreleasepool {
            if(imageURL) {
                
                [self addDownloadImageURL:imageURL
                          completionBlock:^(UIImage *image, NSString *url, NSError *err) {
                              
                              downloadImage = image;
                              error = err;
                              urlString = url;
                              if(completionBlock != nil) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                      completionBlock(downloadImage, urlString, error);
                                  });
                              }
                          }];
                
            } else {
                
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                [info setObject:@"URL is null" forKey:@"desc"];
                error = [NSError errorWithDomain:@"kr.co.digitalworks.dworks" code:5003 userInfo:info];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, nil, error);
                });
            }
        }
    });
}

- (void)addDownloadImageURL:(NSURL *)imageURL completionBlock:(ImageDownloadQueueCompletionBlock)completionBlock {
    
    __block NSError *error = nil;
    __block UIImage *downloadImage = nil;
    
    if(imageURL) {
        [self.imageDownloadQueue addOperationWithBlock:^{
            @autoreleasepool {
                
                NSURLResponse *response = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f]
                                                     returningResponse:&response
                                                                 error:&error];
                if(data) {
                    downloadImage = [UIImage imageWithData:data];
                }
                
                if (completionBlock != nil) {
                    completionBlock(downloadImage, [imageURL absoluteString], error);
                }
            }
        }];
    }
    
}

- (void) cancelAllDownloads {
    [self.imageDownloadQueue cancelAllOperations];
}

@end
