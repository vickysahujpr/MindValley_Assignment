//
//  UIImageView+ImageCache.m
//  Mindvalley Application
//
//  Created by Vikram on 30/06/17.
//  Copyright © 2017 vikram. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "CacheHelper.h"

@implementation UIImageView (ImageCache)

- (void)setImageWithURL:(NSURL *)url{
    
    self.image = [[CacheHelper sharedManager]setImageFromCache:url];
}

@end
