//
//  BL_TwitterRequest.h
//  PostRequest
//
//  Created by Pham Van Hau on 4/24/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BL_TwitterRequestDelegate <NSObject>
-(void)completeLoaded;
@end
@interface BL_TwitterRequest : NSObject <NSURLConnectionDelegate>
@property (nonatomic,strong) id<BL_TwitterRequestDelegate> delegate;
@property (nonatomic, strong) NSMutableData *webData;
@property NSString* oauth_token;
@property NSString* oauth_token_secret;
@property NSString* pinCode;
@property NSMutableArray* followersList;
-(void) makeRequest;
-(void) getAccessToken;
-(void) getFollower;
@end
