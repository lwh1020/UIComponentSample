//
//  ImageDownloader.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 29..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageDownloadQueueCompletionBlock)(UIImage* downloadedImage,NSString *urlString, NSError *error);

@interface ImageDownloader : NSObject

- (void)downloadImageFromUrl:(NSURL *)imageURL completionBlock:(ImageDownloadQueueCompletionBlock)completionBlock;
@end
