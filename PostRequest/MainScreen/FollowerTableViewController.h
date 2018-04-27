//
//  FollowerTableViewController.h
//  Twitter
//
//  Created by Pham Van Hau on 4/25/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property NSMutableArray* followerArray;
@property BOOL shouldWait;
- (void)waitTillLoadedData;
@end
