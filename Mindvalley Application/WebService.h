//
//  WebService.h
//  UrbanPiper_Challenge
//
//  Created by Vikram Sahu on 28/01/17.
//  Copyright © 2017 Vikram Sahu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

typedef void (^WebServiceCallCompletionHandler)(BOOL success, NSDictionary *result);

@interface WebService : NSObject

+ (instancetype)sharedInstance;
- (void)getDataFromURL:(NSString *)URL completionHandler:(WebServiceCallCompletionHandler)handler;

@end
