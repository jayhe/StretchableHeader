//
//  UIScrollView+StretchableHeader.m
//  StretchableHeader
//
//  Created by hechao on 17/5/10.
//  Copyright © 2017年 hc. All rights reserved.
//

#import "UIScrollView+StretchableHeader.h"
#import <objc/runtime.h>

static char kStretchableHeaderKey;

@implementation UIScrollView (StretchableHeader)

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Custom Method

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)removeFromSuperview
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [super removeFromSuperview];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        //stretch header view
        if (offset.y < 0)
        {
            self.stretchableHeader.frame = CGRectMake(0, offset.y, self.stretchableHeader.frame.size.width, - offset.y);
        }
    }
}

#pragma mark - Getter && Setter

- (UIView *)stretchableHeader
{
    return objc_getAssociatedObject(self, &kStretchableHeaderKey);
}

- (void)setStretchableHeader:(UIView *)stretchableHeader
{
    if (self.stretchableHeader)
    {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    objc_setAssociatedObject(self, &kStretchableHeaderKey, stretchableHeader, OBJC_ASSOCIATION_RETAIN);
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    if (stretchableHeader)
    {
        [self insertSubview:self.stretchableHeader atIndex:0];
    }
    
    self.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
    self.contentOffset = CGPointMake(0, -self.headerHeight);
    self.stretchableHeader.contentMode = UIViewContentModeScaleAspectFill;
}

- (CGFloat)headerHeight
{
    if (self.stretchableHeader == nil)
    {
        return 0;
    }else
    {
        return CGRectGetHeight(self.stretchableHeader.frame);
    }
}

@end
