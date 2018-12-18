//
//  CircularCollectionViewLayout.h
//  XLCircleCollectionViewDemo
//
//  Created by Mac-Qke on 2018/12/18.
//  Copyright © 2018 Mac-Qke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircularCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic ,assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGFloat angle;

@end

@interface CircularCollectionViewLayout : UICollectionViewLayout

@end

NS_ASSUME_NONNULL_END
