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
static char kHasAddKVO;

@implementation UIScrollView (StretchableHeader)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(removeFromSuperview));
        Method swizzleMethod = class_getInstanceMethod(self, @selector(sh_removeFromSuperview));
        BOOL isAdded = class_addMethod(self, @selector(removeFromSuperview), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (isAdded) {
            class_replaceMethod(self, @selector(sh_removeFromSuperview), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzleMethod);
        }
    });
}

- (void)sh_removeFromSuperview {
    if (self.hasAddKVO) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [self sh_removeFromSuperview];
}


#pragma mark - Custom Method

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
    if (self.hasAddKVO)
    {
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self setHasAddKVO:NO];
    }
    objc_setAssociatedObject(self, &kStretchableHeaderKey, stretchableHeader, OBJC_ASSOCIATION_RETAIN);
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self setHasAddKVO:YES];
    if (stretchableHeader)
    {
        [self insertSubview:self.stretchableHeader atIndex:0];
    }
    
    self.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
    self.contentOffset = CGPointMake(0, -self.headerHeight);
    self.stretchableHeader.contentMode = UIViewContentModeScaleAspectFill;
}

- (BOOL)hasAddKVO {
    NSNumber *has = objc_getAssociatedObject(self, &kHasAddKVO);
    return has ? has.boolValue : NO;
}

- (void)setHasAddKVO:(BOOL)has {
    objc_setAssociatedObject(self, &kHasAddKVO, @(has), OBJC_ASSOCIATION_ASSIGN);
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
