//
//  j2lViewController.h
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "j2lAppDelegate.h"
#import "j2lPost.h"

@class j2lAppDelegate;

@interface j2lViewController : UIViewController
{
    IBOutlet UITableView *postsView;
    IBOutlet UITextView *newPostView;
    j2lAppDelegate *application;
}

- (void)refresh;
- (IBAction)menu:(id)sender;

@end
