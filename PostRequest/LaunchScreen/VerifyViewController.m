//
//  ViewController.m
//  PostRequest
//
//  Created by Pham Van Hau on 4/23/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import "VerifyViewController.h"
#import "FollowerTableViewController.h"
@interface VerifyViewController ()

@end

@implementation VerifyViewController{
    FollowerTableViewController* followersViewController;
}
@synthesize twitterRequest;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)postRequest{
    twitterRequest = [[BL_TwitterRequest alloc]init];
    twitterRequest.delegate = self;
    [twitterRequest makeRequest];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    NSLog(@"ok connect ok");
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //Speed:
    NSString* oauth_token = [jsonObject valueForKey:@"oauth_token"];
    NSLog(@"%@",oauth_token);
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error connect fail");
    NSLog(@"%@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) completeLoaded{
    followersViewController.followerArray = twitterRequest.followersList;
    [followersViewController.tableView reloadData];
}
- (IBAction)verifyAccount:(id)sender {
    [self postRequest];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Follower_list"]){
            NSLog(@"enter segue show follower list");
            followersViewController = [segue destinationViewController];
        [followersViewController waitTillLoadedData];
        }
    NSLog(@"following list: %@",followersViewController.followerArray);
}
- (IBAction)accessApp:(id)sender {
    if(twitterRequest.followersList.count==0){
        [twitterRequest setPinCode:self.pinText.text];
        NSLog(@"PINCODE IS %@",twitterRequest.pinCode);
        [twitterRequest getAccessToken];
        [self performSegueWithIdentifier:@"Follower_list" sender:self];
    }else{
        [self performSegueWithIdentifier:@"Follower_list" sender:self];
        [self completeLoaded];
    }
}

@end
