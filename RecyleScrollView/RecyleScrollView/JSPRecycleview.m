//
//  JSPRecycleview.m
//  recyleScrollView
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 yuebao. All rights reserved.
//

#import "JSPRecycleview.h"
#import "UIView+JSPFrame.h"

//#import <UIImageView+WebCache.h>
//#import "JFMacro.h"

@interface JSPRecycleview ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * centerImageView;
@property (nonatomic, strong) UIImageView * rightImageView;
@property (nonatomic, strong) UIPageControl * pageControl;
//@property (nonatomic, strong) UILabel * titleLab;


@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) BOOL flag;

@end

@implementation JSPRecycleview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        self.autoScroll = NO;
        self.sourceType = ImageSourceTypeLocal;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.leftImageView.userInteractionEnabled = YES;
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    self.centerImageView.userInteractionEnabled = YES;
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*width, 0, width, height)];
    self.rightImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * leftTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewsDetal:)];
    [self.leftImageView addGestureRecognizer:leftTapGes];
    UITapGestureRecognizer * centerTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewsDetal:)];
    [self.centerImageView addGestureRecognizer:centerTapGes];
    UITapGestureRecognizer * rightTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewsDetal:)];
    [self.rightImageView addGestureRecognizer:rightTapGes];
    
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    self.scrollView.contentSize = CGSizeMake(3*width, height);
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0)];
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.titleLab.frame.size.width + 14, 0, 30, 26)];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    self.pageControl.center = CGPointMake(self.scrollView.center.x, self.height - 20);
    self.pageControl.tintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:self.pageControl];
    
}
- (void)showNewsDetal:(UITapGestureRecognizer *)tapGes {
    UIImageView * tapView = (UIImageView *)tapGes.view;
    if (self.clickedHandler) {
        self.clickedHandler(tapView.tag - 222);
    }
}
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self setupTimer];
    }
    
}

- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(slideScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)setupImage {
    NSUInteger leftIdx = (self.index + self.imageCount - 1) % self.imageCount;
    NSUInteger rightIdx = (self.index + 1) % self.imageCount;
    if (self.sourceType == ImageSourceTypeLocal) {
        self.leftImageView.image = [UIImage imageNamed:self.imgArr[leftIdx]];
        self.rightImageView.image = [UIImage imageNamed:self.imgArr[rightIdx]];
        self.centerImageView.image = [UIImage imageNamed:self.imgArr[self.index]];
    } else {
//        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[leftIdx]] placeholderImage:nil];
//        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[rightIdx]] placeholderImage:nil];
//        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[self.index]] placeholderImage:nil];
    }
    self.leftImageView.tag = 222 + leftIdx;
    self.centerImageView.tag = 222 + self.index;
    self.rightImageView.tag = 222 + rightIdx;
    if (self.changeTitleHandler) {
        self.changeTitleHandler(self.index);
    }
}

- (void)setImgArr:(NSArray *)imgArr {
    _imgArr = imgArr;
    self.imageCount = _imgArr.count;
    self.pageControl.numberOfPages = self.imageCount;
    [self setupImage];
}

- (void)slideScroll {
    if (!self.flag) {       //刚进来时禁止执行
        self.flag = YES;
        return;
    } else {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds) * 2, 0) animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:nil afterDelay:0.4f];
    }
}


#pragma mark --scrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self performSelector:@selector(setupTimer) withObject:nil afterDelay:2];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= 2 * scrollView.bounds.size.width) {   //向右滑动
        self.index = (self.index + 1) % self.imageCount;
    } else if (offsetX <= 0) {   //向左滑动
        self.index = (self.index + self.imageCount - 1) % self.imageCount;
    }
    self.pageControl.currentPage = self.index;
    [self setupImage];
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0)];

}

@end
