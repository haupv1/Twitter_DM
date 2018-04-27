//
//  FollowerTableViewController.m
//  Twitter
//
//  Created by Pham Van Hau on 4/25/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import "FollowerTableViewController.h"
#import "AGChatViewController.h"
@interface FollowerTableViewController ()

@end

@implementation FollowerTableViewController
@synthesize tableView, followerArray;
@synthesize activityIndicatorObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem hidesBackButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    NSLog(@"loaded");
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [followerArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
        cell.textLabel.text = [followerArray objectAtIndex:indexPath.row];
    if([cell.textLabel.text isEqualToString:@"No follower!"]){
//        cell.accessoryType = UITableViewCellAccessoryType.None
//        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = false;
    }
    return cell;
}
- (void)waitTillLoadedData{
    while (self.followerArray.count == 0) {
        
    }
}
-(void)stopIndicatorView{
//    [activityIndicatorObject stopAnimating];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showFollowerDetail"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"FAFAFA%@",indexPath);
        AGChatViewController* chatViewController = segue.destinationViewController;
        chatViewController.messageName = [followerArray objectAtIndex:indexPath.row];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
