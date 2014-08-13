//
//  SceneItem.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneItem : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *LEDs;
@property (strong, nonatomic) NSMutableArray *lights;
@property (strong, nonatomic) NSMutableArray *temps;

@end
