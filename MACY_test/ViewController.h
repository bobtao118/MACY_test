//
//  ViewController.h
//  MACY_test
//
//  Created by Wei TingTao on 1/25/16.
//  Copyright © 2016 weitingtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *result;
@property (nonatomic) NSMutableArray *detail;
@property (nonatomic) BOOL flag;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *table;
@end

