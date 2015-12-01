//
//  j2lPost.m
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import "j2lPost.h"

@interface j2lPost ()

@end

@implementation j2lPost

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
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

- (NSDictionary *)postToDictionary
{
    NSMutableDictionary *returnedDictionary = [[NSMutableDictionary alloc] init];
    [returnedDictionary setObject:self.displayName forKey:@"displayName"];
    if(self.displayPicture != nil)
    {
        [returnedDictionary setObject:[self base64StringFromImage:self.displayPicture] forKey:@"displayPicture"];
    }
    [returnedDictionary setObject:self.postContent forKey:@"postContent"];
    if(self.postPicture != nil)
    {
        [returnedDictionary setObject:[self base64StringFromImage:self.postPicture] forKey:@"postPicture"];
    }
    return returnedDictionary;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.displayName = [dictionary valueForKey:@"displayName"];
    self.displayPicture = [self imageFromBase64String:[dictionary valueForKey: @"displayPicture"]];
    self.postContent = [dictionary valueForKey:@"postContent"];
    self.postPicture = [self imageFromBase64String:[dictionary valueForKey: @"postPicture"]];
    return self;
}

- (BOOL)equalToPost:(j2lPost *)otherPost
{
    NSString *myDisplayPicture = [self base64StringFromImage:self.displayPicture];
    NSString *otherDisplayPicture = [self base64StringFromImage:otherPost.displayPicture];
    NSString *myPostPicture = [self base64StringFromImage:self.postPicture];
    NSString *otherPostPicture = [self base64StringFromImage:otherPost.postPicture];
    if([otherPost.displayName isEqualToString:self.displayName] && [myDisplayPicture isEqualToString:otherDisplayPicture] && [otherPost.postContent isEqualToString:self.postContent] && [otherPostPicture isEqualToString:myPostPicture])
    {
        return true;
    }
    return false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
