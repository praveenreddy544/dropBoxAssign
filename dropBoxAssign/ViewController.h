//
//  ViewController.h
//  dropBoxAssign
//
//  Created by Praveen Poreddy on 11/7/14.
//  Copyright (c) 2014 CM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ViewController : UIViewController<DBRestClientDelegate,UITableViewDataSource,UITableViewDelegate>
{
   NSMutableArray *dropBoxDataURLS;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)alertbutton:(id)sender;

@end

