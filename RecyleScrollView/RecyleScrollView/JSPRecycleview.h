//
//  JSPRecycleview.h
//  recyleScrollView
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 yuebao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageSourceType) {
    ImageSourceTypeLocal = 0,
    ImageSourceTypeNetwork
};


@interface JSPRecycleview : UIView

@property (nonatomic, copy) NSArray * imgArr;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) NSTimer * timer;
///轮播图的图片来源:本地或网络
@property (nonatomic, assign) ImageSourceType sourceType;
///点击轮播图时触发
@property (nonatomic, copy) void (^clickedHandler)(NSUInteger index);
///是否自动轮播
@property (nonatomic, assign) BOOL autoScroll;



@property (nonatomic, copy) void (^changeTitleHandler)(NSUInteger index);


@end
