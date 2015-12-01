//
//  j2lAppDelegate.h
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define service @"j2ldecent"
#define limit 20

@class j2lViewController;
@class j2lPost;

@interface j2lAppDelegate : UIResponder <UIApplicationDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>
{
    BOOL acceptPosts;
    NSTimer *acceptReset;
    MCNearbyServiceBrowser *peerBrowser;
    MCNearbyServiceAdvertiser *peerAdvertiser;
}

- (void)post:(j2lPost *)newPost;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MCPeerID *myIdentifier;
@property (strong, nonatomic) MCSession *mainSession;
@property (weak, nonatomic) j2lViewController *delegate;
@property (nonatomic) BOOL isBrowsing;
@property (strong, nonatomic) NSMutableArray *posts;
@end
