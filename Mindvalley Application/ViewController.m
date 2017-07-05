//
//  ViewController.m
//  Mindvalley Application
//
//  Created by Vikram on 28/06/17.
//  Copyright © 2017 vikram. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewWaterfallCell.h"
#import "WebService.h"
#import "Constant.h"
#import "UIImageView+ImageCache.h"
#import "Utility.h"


@interface ViewController ()
@property (nonatomic, strong) NSArray *cellSizes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerHeight = 10;
    layout.footerHeight = 10;
    layout.minimumColumnSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    [collecView setCollectionViewLayout:layout];
    
    [self addRefreshController];
    [self getData];

}

-(void)addRefreshController{
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [collecView addSubview:refreshController];
}

-(void)handleRefresh : (id)sender
{
    NSLog (@"Pull To Refresh Method Called");
    [self getData];
    [refreshController endRefreshing];
}

-(void)getData{
    // Login for Json Cashing ... we can save for 1 day after completing 1 day we again refresh our JSON
    //Note - only static JSON will be cached
    
    //Check the data is available or not at document directory
    
    NSString *filePath = [Utility getDocumentDirectoryPathwithFileName:@"issues.plist"];
    dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    // get the timestamp of last time when we fetch data from server and saved in Document Directory
    
    
    int lastSavedTimestamp = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"timestamp"];
    int timestampAfter24Hours = lastSavedTimestamp + 60*60*24;
    int currentTimestamp = [Utility getCurrentTimeStamp];
    
    if (dataArray == nil || [dataArray count] == 0 || currentTimestamp >= timestampAfter24Hours) {
        
        [self getDataFromServer];
        
    }

}

-(void)getDataFromServer{
    [[WebService sharedInstance]getDataFromURL:kURL completionHandler:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            NSLog(@"%@", result);
            dataArray = [[NSArray alloc]initWithArray:[result objectForKey:kServiceResponseKey]];
            
            [collecView reloadData];
            [self saveDataToPlistForCaching];
        }else{
            
            NSLog(@"%@", result);
            [self showAlertWithMessage:[result objectForKey:kServiceMessageKey]];
        }
    }];
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(400, 550)],
                       [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                       [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                       [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                       ];
    }
    return _cellSizes;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveDataToPlistForCaching{
    
    NSString *filePath = [Utility getDocumentDirectoryPathwithFileName:@"issues.plist"];
    
    BOOL didWriteToFile =  [NSKeyedArchiver archiveRootObject:dataArray toFile:filePath];
    
    if (didWriteToFile) {
        
        int timestamp = [Utility getCurrentTimeStamp];
        [[NSUserDefaults standardUserDefaults]setInteger:timestamp forKey:@"timestamp"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"Write to file a SUCCESS! %d",timestamp);
        
    } else {
        NSLog(@"Write to file a FAILURE!");
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewWaterfallCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    NSURL *imageURL = [NSURL URLWithString:[[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"user"]objectForKey:@"profile_image"] objectForKey:@"large"]];
    
    [cell.imageView setImageWithURL:imageURL];
    
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}


-(void)showAlertWithMessage:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mindvalley" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getDataFromServer];
    }];
    
    [alertController addAction:retry];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
