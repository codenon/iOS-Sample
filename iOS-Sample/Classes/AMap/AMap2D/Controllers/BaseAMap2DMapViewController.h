//
//  BaseMapViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "APIKey.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <UIKit/UIKit.h>

@interface BaseAMap2DMapViewController
    : UIViewController <MAMapViewDelegate, AMapSearchDelegate>

@property(nonatomic, strong) MAMapView *mapView;

@property(nonatomic, strong) AMapSearchAPI *search;

- (void)returnAction;

/**
 *  hook,子类覆盖它,实现想要在viewDidAppear中执行一次的方法,搜索中有用到
 */
- (void)hookAction;

- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;

@end
