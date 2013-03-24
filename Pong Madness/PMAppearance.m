//
//  KMAppearance.m
//  Pong Madness
//
//  Created by Ludovic Landry on 02/02/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMAppearance.h"
#import "UIFont+PongMadness.m"
#import "UIImage+Stretch.h"

@implementation PMAppearance

+ (void)loadAppearance {
    
    // Navigation bar
    
    UIImage *navBarBackground = [UIImage stretchableHorizontalImageNamed:@"navbar-background"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBackground forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navbar-shadow"]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        UITextAttributeTextColor: [UIColor colorWithRed:0.965f green:0.635f blue:0.647f alpha:1.f],
        UITextAttributeFont : [UIFont brothersBoldFontOfSize:20.f],
        UITextAttributeTextShadowColor: [UIColor blackColor],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)]
    }];
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setTitleTextAttributes:@{
        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeFont : [UIFont brothersBoldFontOfSize:20.f],
        UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.f alpha:0.5f],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)]
    }];
    
    
    // Navbar button items
    
    UIImage *navBarButtonImage = [UIImage stretchableImageNamed:@"navbar-button"];
    
    UIImage *backBarButtonBackImage = [UIImage imageNamed:@"navbar-back"];
    backBarButtonBackImage = [backBarButtonBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16.0, 0, 4.0) resizingMode:UIImageResizingModeStretch];
    
    UIBarButtonItem *navBarButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [navBarButtonItemAppearance setBackgroundImage:navBarButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [navBarButtonItemAppearance setBackButtonBackgroundImage:backBarButtonBackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [navBarButtonItemAppearance setTitleTextAttributes:@{
        UITextAttributeTextColor: [UIColor colorWithRed:0.478f green:0.008f blue:0.023f alpha:1.f],
        UITextAttributeFont : [UIFont brothersBoldFontOfSize:17.f],
        UITextAttributeTextShadowColor: [UIColor colorWithWhite:1.f alpha:0.3f],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
    } forState:UIControlStateNormal];
    
    UIBarButtonItem *popoverBarButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil];
    [popoverBarButtonItemAppearance setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [popoverBarButtonItemAppearance setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [popoverBarButtonItemAppearance setTitleTextAttributes:@{
        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeFont : [UIFont brothersBoldFontOfSize:12.f],
        UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.f alpha:0.5f],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
    } forState:UIControlStateNormal];
}

@end
