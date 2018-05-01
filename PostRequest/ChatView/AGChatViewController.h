//
//  AGChatViewController.h
//  AGChatView
//
//  Created by Pham Van Hau on 4/23/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AGChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) NSString* messageName;
@end
