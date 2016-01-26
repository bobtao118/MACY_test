//
//  ViewController.m
//  MACY_test
//
//  Created by Wei TingTao on 1/25/16.
//  Copyright © 2016 weitingtao. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFNetworking.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - search data
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    
    self.result = [[NSMutableArray alloc]init];
    self.detail = [[NSMutableArray alloc]init];
    //use afnetworking to get data
    NSString *string = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=";
    NSString *URLString = [string stringByAppendingString:self.searchBar.text];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else{
            
            id jsonD = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSArray *jsonArray = [jsonD valueForKeyPath:@"lfs.lf"];
            if ([jsonArray count] == 0) {
                self.result = [[NSArray arrayWithArray:jsonArray]mutableCopy];
                self.detail = nil;
            }else{
            NSMutableArray *jsonData = jsonD[0];
            NSMutableArray *json = [jsonData valueForKeyPath:@"lfs.lf"];  //=8
            NSMutableArray *jsonfreq = [jsonData valueForKeyPath:@"lfs.freq"];
            NSMutableArray *jsonsince = [jsonData valueForKeyPath:@"lfs.since"];
            
            
            for (int i = 0; i<json.count; i++) {
                [self.result addObject:json[i]];
                [self.detail addObject:[NSString stringWithFormat:@"freq:%@ since:%@",jsonfreq[i],jsonsince[i]]];
                NSMutableArray *vars = [jsonData valueForKeyPath:@"lfs.vars.lf"][i];
                NSMutableArray *freq = [jsonData valueForKeyPath:@"lfs.vars.freq"][i];
                NSMutableArray *since = [jsonData valueForKeyPath:@"lfs.vars.since"][i];
                for (int j = 0; j<vars.count; j++) {
                [self.result addObject:[NSString stringWithFormat:@"  ・%@",vars[j]]];
                [self.detail addObject:[NSString stringWithFormat:@"   freq:%@ since:%@",freq[j],since[j]]];
                }
                
            }
            }
            //NSLog(@"%@",self.detail);
       
           // NSLog(@"%lu",(unsigned long)vars.count);
           

            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
                self.flag = true;
                [self.searchBar resignFirstResponder];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }] resume];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    self.flag = false;
    searchBar.text = @"";
    self.result = nil;
    self.detail = nil;
    [self.table reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.result.count == 0) {
        return 1;
    }
    else{
        return self.result.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (self.result.count == 0 && self.flag == true) {
        cell.textLabel.text = @"no data found!";
        cell.detailTextLabel.text =@"";
    }else{
        cell.textLabel.text = [self.result objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.detail objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}
@end
