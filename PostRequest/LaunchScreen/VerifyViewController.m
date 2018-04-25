//
//  ViewController.m
//  PostRequest
//
//  Created by Pham Van Hau on 4/23/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import "VerifyViewController.h"
@interface VerifyViewController ()

@end

@implementation VerifyViewController
@synthesize twitterRequest;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)postRequest{
    twitterRequest = [[BL_TwitterRequest alloc]init];
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
- (IBAction)verifyAccount:(id)sender {
    [self postRequest];
}

- (IBAction)accessApp:(id)sender {
    [twitterRequest setPinCode:self.pinText.text];
    NSLog(@"PINCODE IS %@",twitterRequest.pinCode);
    [twitterRequest getAccessToken];
}

@end
