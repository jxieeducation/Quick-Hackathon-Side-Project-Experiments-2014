//
//  j2lViewController.m
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import "j2lViewController.h"

@interface j2lViewController ()

@end

@implementation j2lViewController

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
    application = (j2lAppDelegate *)[[UIApplication sharedApplication] delegate];
    application.delegate = self;
    postsView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [newPostView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [newPostView.layer setBorderWidth:1.0];
    newPostView.layer.cornerRadius = 5;
    newPostView.clipsToBounds = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [postsView addGestureRecognizer:gestureRecognizer];
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    if(name == nil || [name isEqualToString:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self.navigationController performSegueWithIdentifier:@"profile" sender:self];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return ((j2lAppDelegate *)[[UIApplication sharedApplication] delegate]).posts.count;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIImageView *profile = (UIImageView *)[[cell contentView] viewWithTag:1];
    UILabel *name = (UILabel *)[[cell contentView] viewWithTag:2];
    UITextView *content = (UITextView *)[[cell contentView] viewWithTag:3];
    [profile setImage:((j2lPost *) application.posts[indexPath.row]).displayPicture];
    profile.layer.cornerRadius = profile.bounds.size.width/2;
    profile.layer.masksToBounds = YES;
    name.text = ((j2lPost *) application.posts[indexPath.row]).displayName;
    content.text = ((j2lPost *) application.posts[indexPath.row]).postContent;
    content.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 11];
    content.textContainer.lineFragmentPadding = 2;
    content.textContainerInset = UIEdgeInsetsZero;
    return cell;
}

- (void)refresh
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 2, 220, 25)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:[NSString stringWithFormat:@"%lu Around Me", (unsigned long) application.mainSession.connectedPeers.count]];
    label.adjustsFontSizeToFitWidth = YES;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size: 17]];
    [self.navigationController.navigationBar.topItem setTitleView: label];
    [postsView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

- (IBAction)menu:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self.navigationController performSegueWithIdentifier:@"profile" sender:self];
        newPostView.text = @"What's on your mind?";
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        if(textView.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter something to post." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            textView.text = @"What's on your mind?";
            return NO;
        }
        if(textView.text.length > 140)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please make a post that's less than 140 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            textView.text = @"What's on your mind?";
            return NO;
        }
        [textView resignFirstResponder];
        j2lPost *newPost = [[j2lPost alloc] init];
        newPost.postContent = textView.text;
        [application post:newPost];
        [application.posts insertObject:newPost atIndex:0];
        [self refresh];
        textView.text = @"";
        textView.text = @"What's on your mind?";
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

- (void)hideKeyboard
{
    [newPostView resignFirstResponder];
    newPostView.text = @"What's on your mind?";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [newPostView resignFirstResponder];
    }
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
