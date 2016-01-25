//
//  NONLifeCycleVCController.m
//  iOS-Sample
//
//  Created by negwiki on 16/1/25.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import "NONLifeCycleVCController.h"

static NSString *const TAG = @"NONLifeCycleVCController: %@";

@implementation NONLifeCycleVCController {
  BOOL animate;
}

- (void)initView {
  self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark ViewController lifecycle method
- (instancetype)init {
  self = [super init];
  NSLog(TAG, NSStringFromSelector(_cmd));
  return self;
}

/**
 *   https://medium.com/@SergiGracia/ios-uiviewcontroller-lifecycle-261e3e2f6133#.ar34xg59a
 *
 *   Creates the view that the controller manages.
 *
 *   It’s only called when the view controller is created and only when done
 *   programatically. You can override this method in order to create your views
 *   manually.
 */
- (void)loadView {
  [super loadView];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

- (void)loadViewIfNeeded {
  [super loadViewIfNeeded];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

/**
 *  Called after the controller’s view is loaded into memory.
 *
 *  It’s only called when the view is created. Keep in mind that in this
 *  lifecycle step the view bounds are not final. Good place to init and setup
 *  objects used in the viewController.
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(TAG, NSStringFromSelector(_cmd));
  [self initView];
}

/**
 *  Notifies the view controller that its view is about to be added to a view
 *  hierarchy.
 *
 *  It’s called whenever the view is presented on the screen. In this step the
 *  view has bounds defined but the orientation is not applied. This event is
 *  called every time the view appears so don’t add code here which should be
 *  executed just one time (or manage it correctly).
 *
 *  @param animated If YES, the view is being added to the window using an
 *  animation.
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

/**
 *  Called to notify the view controller that its view is about to layout its
 *  subviews.
 *
 *  This method is called every time the frame changes like for example when
 *  rotate or it’s marked as needing layout. It’s the first step where the view
 *  bounds are final. If you are not using autoresizing masks or constraints and
 *  the view size changes you probably want to update the subviews here.
 */
- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

/**
 *  Called to notify the view controller that its view has just laid out its
 *  subviews.
 *
 *  Make additional changes here after the view lays out its subviews.
 */
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 *
 *  Good place to perform additional tasks associated with presenting the view
 *  like animations. This method is executed after the animation displaying the
 *  view finishes so in this step the view is already visible for the user. In
 *  some cases can be a good place to load data from core data and present it in
 *  the view or to start requesting data from a server.
 *
 *  @param animated If YES, the view was added to the window using an animation.
 */
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

#pragma mark Deprecated Methods
- (void)viewWillUnload {
  [super viewWillUnload];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

- (void)viewDidUnload {
  [super viewDidUnload];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

#pragma mark Handling Memory Warnings
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(TAG, NSStringFromSelector(_cmd));
}

@end
