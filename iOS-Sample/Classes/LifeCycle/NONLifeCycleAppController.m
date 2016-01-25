//
//  NONLifeCycleViewController.m
//  iOS-Sample
//
//  Created by negwiki on 16/1/25.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import "NONLifeCycleAppController.h"

@interface NONLifeCycleAppController ()

@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) UIImage *smiley;
@property(strong, nonatomic) UIImageView *smileyView;
@property(strong, nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation NONLifeCycleAppController {
  BOOL animate;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initView];
  [self addObserverNotification];
}
- (void)initView {
  self.view.backgroundColor = [UIColor whiteColor];

  CGRect bounds = self.view.bounds;
  CGRect labelFrame = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50,
                                 bounds.size.width, 100);
  self.label = [[UILabel alloc] initWithFrame:labelFrame];
  self.label.font = [UIFont fontWithName:@"Helvetica" size:70];
  self.label.text = @"Bazinga!";
  self.label.textAlignment = NSTextAlignmentCenter;
  self.label.backgroundColor = [UIColor clearColor];

  // smiley.png is 84 x 84
  CGRect smileyFrame =
      CGRectMake(CGRectGetMidX(bounds) - 42, CGRectGetMidY(bounds) / 2, 84, 84);
  self.smileyView = [[UIImageView alloc] initWithFrame:smileyFrame];
  self.smileyView.contentMode = UIViewContentModeCenter;
  NSString *smileyPath =
      [[NSBundle mainBundle] pathForResource:@"smiley" ofType:@"png"];
  self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
  self.smileyView.image = self.smiley;

  //
  self.segmentedControl = [[UISegmentedControl alloc]
      initWithItems:[NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four",
                                              nil]];
  self.segmentedControl.frame =
      CGRectMake(bounds.origin.x + 20, 80, bounds.size.width - 40, 30);

  [self.view addSubview:self.segmentedControl];
  [self.view addSubview:self.smileyView];
  [self.view addSubview:self.label];

  NSNumber *indexNumber =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"];
  if (indexNumber) {
    NSInteger selectedIndex = [indexNumber intValue];
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
  }
}

#pragma mark animate method
- (void)rotateLabelDown {
  [UIView animateWithDuration:0.5
      animations:^{
        self.label.transform = CGAffineTransformMakeRotation(M_PI);
      }
      completion:^(BOOL finished) {
        [self rotateLabelUp];
      }];
}

- (void)rotateLabelUp {
  [UIView animateWithDuration:0.5
      animations:^{
        self.label.transform = CGAffineTransformMakeRotation(0);
      }
      completion:^(BOOL finished) {
        if (animate) {
          [self rotateLabelDown];
        }
      }];
}

#pragma mark application lifecycle notification method
- (void)addObserverNotification {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self
             selector:@selector(applicationWillResignActive)
                 name:UIApplicationWillResignActiveNotification
               object:nil];
  [center addObserver:self
             selector:@selector(applicationDidBecomeActive)
                 name:UIApplicationDidBecomeActiveNotification
               object:nil];
  [center addObserver:self
             selector:@selector(applicationDidEnterBackground)
                 name:UIApplicationDidEnterBackgroundNotification
               object:nil];
  [center addObserver:self
             selector:@selector(applicationWillEnterForeground)
                 name:UIApplicationWillEnterForegroundNotification
               object:nil];
}
- (void)applicationWillResignActive {
  NSLog(@"VC: %@", NSStringFromSelector(_cmd));
  animate = NO;
}

- (void)applicationDidBecomeActive {
  NSLog(@"VC: %@", NSStringFromSelector(_cmd));
  animate = YES;
  [self rotateLabelDown];
}

- (void)applicationDidEnterBackground {
  NSLog(@"VC: %@", NSStringFromSelector(_cmd));
  UIApplication *app = [UIApplication sharedApplication];

  __block UIBackgroundTaskIdentifier taskId;
  taskId = [app beginBackgroundTaskWithExpirationHandler:^{
    NSLog(@"Background task ran out of time and was terminated.");
    [app endBackgroundTask:taskId];
  }];

  if (taskId == UIBackgroundTaskInvalid) {
    NSLog(@"Failed to start background task!");
    return;
  }

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Starting background task with %f seconds remaining",
              app.backgroundTimeRemaining);

        self.smiley = nil;
        self.smileyView.image = nil;
        NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
                                                   forKey:@"selectedIndex"];

        // simulate a lengthy (25 seconds) procedure
        [NSThread sleepForTimeInterval:25];

        NSLog(@"Finishing background task with %f seconds remaining",
              app.backgroundTimeRemaining);
        [app endBackgroundTask:taskId];
      });
}

- (void)applicationWillEnterForeground {
  NSLog(@"VC: %@", NSStringFromSelector(_cmd));
  NSString *smileyPath =
      [[NSBundle mainBundle] pathForResource:@"smiley" ofType:@"png"];
  self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
  self.smileyView.image = self.smiley;
}

@end
