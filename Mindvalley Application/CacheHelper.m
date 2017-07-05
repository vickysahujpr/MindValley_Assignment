//
//  CacheHelper.m
//  Mindvalley Application
//
//  Created by Vikram on 29/06/17.
//  Copyright © 2017 vikram. All rights reserved.
//

#import "CacheHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CacheHelper

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    
    fileManager = [[NSFileManager alloc]init];
    
    return self;
}


-(NSString *)getCacheDirectoryPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"CachedImages"];
    
    return cacheDirectoryName;
    
}


-(UIImage *)setImageFromCache:(NSURL *)url{
    
    NSString *imageURL = url.absoluteString;
    NSData *imageData;
    UIImage *image;
    
    if ([self fileExistsAtPath:imageURL]) {
        // If file exist at path then fetch the file from document directory
        
        imageData = [fileManager contentsAtPath:[self getFullPathOfImage:imageURL]];
        image = [UIImage imageWithData:imageData];
        return image;
        
    }else{
        imageData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:imageData];
        [self saveImageToCacheDirectory:imageURL withImageData:imageData];
        return  image;
    }
    
}

-(BOOL)fileExistsAtPath:(NSString *)imgURL{
    
    return [fileManager fileExistsAtPath:[self getFullPathOfImage:imgURL]];
}

-(NSString *)getFullPathOfImage:(NSString *)imgURL{
    NSString *path = [self getCacheDirectoryPath];
    NSString *md5Key = [self MD5String:imgURL];
    NSString *imagePath =[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", md5Key]];
    return imagePath;
}

-(void)saveImageToCacheDirectory:(NSString *)key withImageData:(NSData *)imageData{
    
    NSString *path = [self getCacheDirectoryPath];
   
    NSString *imagePath = [self getFullPathOfImage:key];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
}


- (NSString *)MD5String:(NSString *)key {
    const char *cStr = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
