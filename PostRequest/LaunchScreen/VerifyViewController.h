//
//  ViewController.h
//  PostRequest
//
//  Created by Pham Van Hau on 4/23/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BL_TwitterRequest.h"

@interface VerifyViewController : UIViewController<NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pinText;
@property BL_TwitterRequest *twitterRequest;
@end
