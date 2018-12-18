//
//  CircularCollectionViewCell.m
//  XLCircleCollectionViewDemo
//
//  Created by Mac-Qke on 2018/12/18.
//  Copyright © 2018 Mac-Qke. All rights reserved.
//

#import "CircularCollectionViewCell.h"
#import "CircularCollectionViewLayout.h"
@implementation CircularCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame =self.bounds;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    CircularCollectionViewLayoutAttributes *circularLayoutAttributes = (CircularCollectionViewLayoutAttributes *)layoutAttributes;
    self.layer.anchorPoint = circularLayoutAttributes.anchorPoint;
    [self setCenter:CGPointMake(self.center.x, self.center.y + (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds))];
    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

@end
