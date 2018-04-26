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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem hidesBackButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    NSLog(@"loaded");
    // Do any additional setup after loading the view.
//    followerArray = [NSMutableArray arrayWithObjects:@"Game 1", @"Game 2", @"Game 3", @"Game 4", @"Gam 5", @"Gam 6", @"Gam 7", nil];

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
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showFollowerDetail"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"FAFAFA%@",indexPath);
        AGChatViewController* chatViewController = segue.destinationViewController;
        chatViewController.messageName = [followerArray objectAtIndex:indexPath.row];
//        RecipeDetailViewController *destViewController = segue.destinationViewController;
//        destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
