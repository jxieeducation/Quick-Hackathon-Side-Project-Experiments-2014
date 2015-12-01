//
//  j2lAppDelegate.m
//  decent
//
//  Created by Lucas Yan on 4/5/14.
//  Copyright (c) 2014 j2l. All rights reserved.
//

#import "j2lAppDelegate.h"
#import "j2lPost.h"
#import "j2lViewController.h"

@implementation j2lAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *viewController =[storyboard instantiateInitialViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    self.posts = [[NSMutableArray alloc] init];
    
    acceptPosts = true;
    
    self.myIdentifier = [[MCPeerID alloc] initWithDisplayName:[self.class createHash:20]];
    
    self.mainSession = [[MCSession alloc] initWithPeer:self.myIdentifier];
    self.mainSession.delegate = self;
    
    peerAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myIdentifier discoveryInfo:nil serviceType: service];
    peerAdvertiser.delegate = self;
    [peerAdvertiser startAdvertisingPeer];
    
    peerBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myIdentifier serviceType: service];
    peerBrowser.delegate = self;
    [peerBrowser startBrowsingForPeers];
    
    return YES;
}

- (void)reset
{
    acceptPosts = true;
    [self.delegate refresh];
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    self.isBrowsing = false;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    acceptReset = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reset) userInfo:nil repeats:YES];
    acceptPosts = true;
    self.isBrowsing = true;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [acceptReset invalidate];
    self.isBrowsing = false;
}

#pragma mark MultipeerConnectivity methods

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [peerBrowser invitePeer:peerID toSession:self.mainSession withContext:nil timeout:5000];
}

- (void)post:(j2lPost *)newPost
{
    if(newPost == nil)
    {
        return;
    }
    newPost.displayName = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    newPost.displayPicture = [self imageFromBase64String:[[NSUserDefaults standardUserDefaults] valueForKey:@"profile"]];
    NSDictionary *postDictionary = [newPost postToDictionary];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: data];
    [archiver encodeObject:postDictionary forKey:@"post"];
    [archiver finishEncoding];
    NSError *error;
    [self.mainSession sendData:data toPeers:self.mainSession.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
}

- (UIImage *)imageFromBase64String:(NSString *)base64
{
    if(base64 == nil)
    {
        return nil;
    }
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    [self.delegate refresh];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    if(acceptPosts)
    {
        @try
        {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            NSDictionary *postDictionary = [unarchiver decodeObjectForKey:@"post"];
            if(postDictionary == nil)
            {
                return;
            }
            [unarchiver finishDecoding];
            j2lPost *newPost = [[j2lPost alloc] initWithDictionary:postDictionary];
            for(j2lPost *existingPost in self.posts)
            {
                if([existingPost equalToPost:newPost])
                {
                    return;
                }
            }
            if(self.posts.count + 1 > limit)
            {
                [self.posts removeLastObject];
            }
            if(newPost == nil)
            {
                return;
            }
            [self.posts insertObject:newPost atIndex:0];
            [self.delegate refresh];
            acceptPosts = false;
        }
        @catch(NSException *e)
        {
        }
    }
}

+ (NSString *)createHash:(int)length
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++)
    {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    [self.delegate refresh];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
    didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, self.mainSession);
    [self.delegate refresh];
}
@end
