//
//  j2lPost.h
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface j2lPost : UITabBarController

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) UIImage *displayPicture;
@property (strong, nonatomic) NSString *postContent;
@property (strong, nonatomic) UIImage *postPicture;
@property (nonatomic) BOOL hidden;

- (NSDictionary *)postToDictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (BOOL)equalToPost:(j2lPost *)otherPost;

@end
