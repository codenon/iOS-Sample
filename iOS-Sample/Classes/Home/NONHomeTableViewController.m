//
//  ViewController.m
//  iOS-Sample
//
//  Created by negwiki on 16/1/24.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import "NONBPushController.h"
#import "NONHomeItem.h"
#import "NONHomeTableViewController.h"
#import "NONLifeCycleAppController.h"
#import "NONLifeCycleVCController.h"
#import "NONLocationMainViewController.h"
#import "NONAMap2DMainViewController.h"

static NSString *const SampleGroup00Title = @"Life Cycle";
static NSString *const SampleGroup01Title = @"Third Party";

@interface NONHomeTableViewController ()

@property(strong, nonatomic) NSArray *samples;

@end

@implementation NONHomeTableViewController

#pragma mark lifecycle method
- (void)viewDidLoad {
  [self initSampleData];
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark init data
- (void)initSampleData {
  NONHomeItem *group0 = [[NONHomeItem alloc] init];
  group0.header = SampleGroup00Title;
  group0.titles = @[ @"Application Life Cycle", @"ViewController Life Cycle" ];
  group0.vcClass =
      @[ [NONLifeCycleAppController class], [NONLifeCycleVCController class] ];

  NONHomeItem *group1 = [[NONHomeItem alloc] init];
  group1.header = SampleGroup01Title;
  group1.titles = @[ @"Baidu Push", @"AMap Location", @"AMap 2D MapView" ];
  group1.vcClass = @[
    [NONBPushController class],
    [NONLocationMainViewController class],
    [NONAMap2DMainViewController class]
  ];

  self.samples = @[ group0, group1 ];
}

#pragma mark UITableViewDataSource Protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.samples.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NONHomeItem *item = self.samples[section];
  return item.titles.count;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  NONHomeItem *item = self.samples[section];
  return item.header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"sample";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
  }

  NONHomeItem *item = self.samples[indexPath.section];
  cell.textLabel.text = item.titles[indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", item.vcClass];

  return cell;
}

#pragma mark UITableViewDelegate Protocol
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NONHomeItem *item = self.samples[indexPath.section];
  //  NSLog(@"%@",item.titles[indexPath.row]);
  //  NSLog(@"%@",item.vcClass);
  //  NSLog(@"%@",item.vcClass[indexPath.row]);
  UIViewController *vc = [[item.vcClass[indexPath.row] alloc] init];
  vc.title = item.titles[indexPath.row];
  //[vc setValue:item.methods[indexPath.row] forKeyPath:@"method"];
  //设置翻页效果
  /*
   UIModalTransitionStyleCoverVertical
   UIModalTransitionStyleFlipHorizontal
   UIModalTransitionStyleCrossDissolve
   UIModalTransitionStylePartialCurl
   */
  vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  /*
   UIModalPresentationFullScreen
   UIModalPresentationPageSheet
   UIModalPresentationFormSheet
   UIModalPresentationCurrentContext
   UIModalPresentationCustom
   UIModalPresentationOverFullScreen
   UIModalPresentationOverCurrentContext
   UIModalPresentationPopover
   UIModalPresentationNone
   */
  vc.modalPresentationStyle = UIModalPresentationPageSheet;

  [self.navigationController pushViewController:vc animated:YES];
  //[self presentViewController:vc animated:YES completion:nil];
  //[self presentModalViewController:vc animated:YES]; //实现页面的切换
}

@end
