//
//  MainViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "APIKey.h"
#import "BaseLocationMapViewController.h"
#import "NONLocationMainViewController.h"

#define MainViewControllerTitle @"高德地图API-Location"

@interface NONLocationMainViewController () <UITableViewDataSource,
                                             UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *classNames;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) MAMapView *mapView;
@property(nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation NONLocationMainViewController
@synthesize titles = _titles;
@synthesize classNames = _classNames;
@synthesize tableView = _tableView;

@synthesize mapView = _mapView;

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.titles[section] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return @"AMapLocationKit";
  default:
    return @"";
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *mainCellIdentifier = @"mainCellIdentifier";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:mainCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
  cell.detailTextLabel.text = self.classNames[indexPath.section][indexPath.row];

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSString *className = self.classNames[indexPath.section][indexPath.row];

  BaseLocationMapViewController *subViewController =
      [[NSClassFromString(className) alloc] init];

  subViewController.title = self.titles[indexPath.section][indexPath.row];
  subViewController.mapView = self.mapView;
  subViewController.locationManager = self.locationManager;

  [self.navigationController
      pushViewController:(UIViewController *)subViewController
                animated:YES];
}

#pragma mark - Initialization

- (void)initTitles {
  NSArray *locTitles = @[ @"单次定位", @"连续定位", @"地理围栏" ];

  self.titles = [NSArray arrayWithObjects:locTitles, nil];
}

- (void)initClassNames {
  NSArray *locClassNames = @[
    @"SingleLocationViewController",
    @"SerialLocationViewController",
    @"MonitoringRegionViewController"
  ];

  self.classNames = [NSArray arrayWithObjects:locClassNames, nil];
}

- (void)initTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStyleGrouped];
  self.tableView.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  [self.view addSubview:self.tableView];
}

- (void)initMapView {
  self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
}

- (void)initLocationManager {
  self.locationManager = [[AMapLocationManager alloc] init];
}

#pragma mark - Life Cycle

- (id)init {
  if (self = [super init]) {
    self.title = MainViewControllerTitle;

    [self initTitles];

    [self initClassNames];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initTableView];

  [self initMapView];

  [self initLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  self.navigationController.navigationBar.translucent = NO;

  [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
