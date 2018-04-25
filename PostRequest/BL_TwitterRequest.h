//
//  BL_TwitterRequest.h
//  PostRequest
//
//  Created by Pham Van Hau on 4/24/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BL_TwitterRequest : NSObject <NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableData *webData;
@property NSString* oauth_token;
@property NSString* oauth_token_secret;
@property NSString* pinCode;
-(void) makeRequest;
-(void) getAccessToken;
-(void) getFollower;
@end
