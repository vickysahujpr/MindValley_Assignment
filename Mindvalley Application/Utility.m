//
//  Utility.m
//  UrbanPiper_Challenge
//
//  Created by Vikram Sahu on 28/01/17.
//  Copyright © 2017 Vikram Sahu. All rights reserved.
//

#import "Utility.h"
#import "WebService.h"

@implementation Utility


+(void)showAlertViewwithTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle toController:(UIViewController *)controller{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:retry];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (int)getCurrentTimeStamp{
    return [[NSDate date] timeIntervalSince1970];
}

+(NSString *)getDocumentDirectoryPathwithFileName:(NSString *)filename{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    return filePath;
    
}

@end
