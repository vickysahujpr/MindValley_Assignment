//
//  Utility.h
//  UrbanPiper_Challenge
//
//  Created by Vikram Sahu on 28/01/17.
//  Copyright © 2017 Vikram Sahu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utility : NSObject

+(void)showAlertViewwithTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle toController:(UIViewController *)controller;

+ (int)getCurrentTimeStamp;

+(NSString *)getDocumentDirectoryPathwithFileName:(NSString *)filename;


@end
