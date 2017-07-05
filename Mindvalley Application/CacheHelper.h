//
//  CacheHelper.h
//  Mindvalley Application
//
//  Created by Vikram on 29/06/17.
//  Copyright © 2017 vikram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheHelper : NSObject{
    NSFileManager *fileManager;
}

+ (id)sharedManager;
-(NSString *)getCacheDirectoryPath;
-(UIImage *)setImageFromCache:(NSURL *)url;

@end
