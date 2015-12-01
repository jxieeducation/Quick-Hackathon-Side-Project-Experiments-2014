//
//  j2lProfileModalController.m
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import "j2lProfileModalController.h"

@interface j2lProfileModalController ()

@end

@implementation j2lProfileModalController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    nameView.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    [profileView setBackgroundImage:[self imageFromBase64String:[[NSUserDefaults standardUserDefaults] valueForKey:@"profile"]] forState:UIControlStateNormal];
    profileView.layer.cornerRadius = profileView.bounds.size.width/2;
    profileView.layer.masksToBounds = YES;
    if([profileView backgroundImageForState:UIControlStateNormal] == nil)
    {
        [profileView setBackgroundImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)start:(id)sender
{
    if(nameView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter in a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:nameView.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:[self base64StringFromImage:[profileView backgroundImageForState:UIControlStateNormal]] forKey:@"profile"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectProfile:(id)sender
{
    UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                        @"Take Photo",
                        @"Select Photo",
                        nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        profilePicker.delegate = self;
        profilePicker.allowsEditing = true;
        profilePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:profilePicker animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
    if(popup.tag == 1)
    {
        profilePicker.delegate = self;
        profilePicker.allowsEditing = true;
        if(buttonIndex == 0)
        {
            profilePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self presentViewController:profilePicker animated:YES completion:nil];
        }
        else if(buttonIndex == 1)
        {
            profilePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self presentViewController:profilePicker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker 
    didFinishPickingImage:(UIImage *)image
    editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    CGRect rect = CGRectMake(0, 0, 240, 240);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [profileView setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSString *)base64StringFromImage:(UIImage *)image
{
    NSData * data = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if(data == nil)
    {
        return @"";
    }
    return [NSString stringWithUTF8String:[data bytes]];
}

- (UIImage *)imageFromBase64String:(NSString *)base64
{
    if(base64 == nil)
    {
        return nil;
    }
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
