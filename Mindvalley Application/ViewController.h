//
//  ViewController.h
//  Mindvalley Application
//
//  Created by Vikram on 28/06/17.
//  Copyright © 2017 vikram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface ViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout>
{
    NSArray *dataArray;
    IBOutlet UICollectionView *collecView;
    UIRefreshControl *refreshController;
}

@end

