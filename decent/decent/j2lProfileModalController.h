//
//  j2lProfileModalController.h
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface j2lProfileModalController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField *nameView;
    IBOutlet UIButton *profileView;
}
- (IBAction)start:(id)sender;
@end
