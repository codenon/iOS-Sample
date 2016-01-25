//
//  NONHomeItem.h
//  iOS-Sample
//
//  Created by negwiki on 16/1/24.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NONHomeItem : NSObject

@property(copy, nonatomic) NSString *header;
@property(strong, nonatomic) NSArray<NSString *> *titles;
@property(strong, nonatomic) NSArray<Class> *vcClass;

@end
