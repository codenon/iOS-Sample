//
//  SingleLocationViewController.m
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "SingleLocationViewController.h"

@interface SingleLocationViewController ()

@property(nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation SingleLocationViewController

#pragma mark - Action Handle

- (void)configLocationManager {
  // 1.设置定位精度。
  //提示：采用默认的定位精度（kCLLocationAccuracyBest），获取到的定位点偏差较小，但是请求耗时较多（10s左右），建议按照业务需求设置定位精度，推荐：kCLLocationAccuracyHundredMeters，偏差在100米以内，耗时在2-3s。
  //带逆地理信息的一次定位（返回坐标和地址信息）
  [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];

  [self.locationManager setPausesLocationUpdatesAutomatically:NO];

  [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

- (void)cleanUpAction {
  [self.locationManager stopUpdatingLocation];

  [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction {
  [self.mapView removeAnnotations:self.mapView.annotations];

  // 带逆地理（返回坐标和地址信息）
  [self.locationManager requestLocationWithReGeocode:YES
                                     completionBlock:self.completionBlock];
}

- (void)locAction {
  [self.mapView removeAnnotations:self.mapView.annotations];

  [self.locationManager requestLocationWithReGeocode:NO
                                     completionBlock:self.completionBlock];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView
            viewForAnnotation:(id<MAAnnotation>)annotation {
  if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";

    MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView
        dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    if (annotationView == nil) {
      annotationView =
          [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                          reuseIdentifier:pointReuseIndetifier];
    }

    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    annotationView.draggable = NO;
    annotationView.pinColor = MAPinAnnotationColorPurple;

    return annotationView;
  }

  return nil;
}

#pragma mark - Initialization

- (void)initCompleteBlock {
  __weak SingleLocationViewController *wSelf = self;
  self.completionBlock = ^(CLLocation *location,
                           AMapLocationReGeocode *regeocode, NSError *error) {
    if (error) {
      NSLog(@"locError:{%ld - %@};", (long)error.code,
            error.localizedDescription);

      if (error.code == AMapLocationErrorLocateFailed) {
        return;
      }
    }

    if (location) {
      MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
      [annotation setCoordinate:location.coordinate];

      if (regeocode) {
        [annotation
            setTitle:[NSString
                         stringWithFormat:@"%@", regeocode.formattedAddress]];
        [annotation
            setSubtitle:[NSString
                            stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode,
                                             regeocode.adcode,
                                             location.horizontalAccuracy]];
      } else {
        [annotation
            setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;",
                                                location.coordinate.latitude,
                                                location.coordinate.longitude]];
        [annotation
            setSubtitle:[NSString
                            stringWithFormat:@"accuracy:%.2fm",
                                             location.horizontalAccuracy]];
      }

      SingleLocationViewController *sSelf = wSelf;
      [sSelf addAnnotationToMapView:annotation];
    }
  };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation {
  [self.mapView addAnnotation:annotation];

  [self.mapView selectAnnotation:annotation animated:YES];
  [self.mapView setZoomLevel:15.1 animated:NO];
  [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

#pragma mark AMap
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)initToolBar {
  UIBarButtonItem *flexble = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                           target:nil
                           action:nil];

  UIBarButtonItem *reGeocodeItem =
      [[UIBarButtonItem alloc] initWithTitle:@"带逆地理定位"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(reGeocodeAction)];

  UIBarButtonItem *locItem =
      [[UIBarButtonItem alloc] initWithTitle:@"不带逆地理定位"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(locAction)];

  self.toolbarItems = [NSArray
      arrayWithObjects:flexble, reGeocodeItem, flexble, locItem, flexble, nil];
}

- (void)initNavigationBar {
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Clean"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(cleanUpAction)];
}

- (void)returnAction {
  [self cleanUpAction];

  self.completionBlock = nil;

  [super returnAction];
}
#pragma clang diagnostic pop

#pragma mark - Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initToolBar];

  [self initNavigationBar];

  [self initCompleteBlock];

  [self configLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationController.toolbar.barStyle = UIBarStyleBlack;
  self.navigationController.toolbar.translucent = YES;
  [self.navigationController setToolbarHidden:NO animated:animated];
}

@end
