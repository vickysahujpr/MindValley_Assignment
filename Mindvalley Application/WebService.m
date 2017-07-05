//
//  WebService.m
//  UrbanPiper_Challenge
//
//  Created by Vikram Sahu on 28/01/17.
//  Copyright © 2017 Vikram Sahu. All rights reserved.
//

#import "WebService.h"
#import "SVProgressHUD.h"


@implementation WebService

+ (instancetype)sharedInstance {
    static WebService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)getDataFromURL:(NSString *)URL completionHandler:(WebServiceCallCompletionHandler)handler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"Please wait..."];
    });
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(FALSE, [NSDictionary dictionaryWithObject:error.localizedDescription forKey:kServiceMessageKey]);
                [SVProgressHUD dismiss];
            });
            
        } else {
            NSError *jsonError;
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (jsonError) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler (FALSE, [NSDictionary dictionaryWithObject:jsonError.localizedDescription forKey:kServiceMessageKey]);
                    [SVProgressHUD dismiss];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(TRUE, [NSDictionary dictionaryWithObject:result forKey:kServiceResponseKey]);
                    [SVProgressHUD dismiss];
                });
                
            }
            
        }
        
    }] resume];
    
}

@end
