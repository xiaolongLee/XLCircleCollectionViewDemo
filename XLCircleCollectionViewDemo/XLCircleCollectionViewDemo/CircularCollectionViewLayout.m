//
//  CircularCollectionViewLayout.m
//  XLCircleCollectionViewDemo
//
//  Created by Mac-Qke on 2018/12/18.
//  Copyright © 2018 Mac-Qke. All rights reserved.
//

#import "CircularCollectionViewLayout.h"

@implementation CircularCollectionViewLayoutAttributes

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.angle = 0;
}

//确保copy的时候，自定义的属性也copy进去了
- (id)copyWithZone:(NSZone *)zone {
    CircularCollectionViewLayoutAttributes *copiedAttributes = [super copyWithZone:zone];
    copiedAttributes.anchorPoint = self.anchorPoint;
    copiedAttributes.angle = self.angle;
    return copiedAttributes;
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    
    //随着角度越大，意味着这个item在越上面,因为是用弧度表示的angle，所以乘一个比较大的数来保证不会出现相同的两个z值
    self.zIndex = (int)(self.angle * 1000000);
    //设置item的旋转
    self.transform = CGAffineTransformMakeRotation(self.angle);
    
}

@end


@interface CircularCollectionViewLayout ()

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat angleAtExtreme;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat anglePerItem;

@property (nonatomic, strong) NSMutableArray *attributesList;

@end

@implementation CircularCollectionViewLayout

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    self.itemSize = CGSizeMake(133, 173);
    self.radius = 500;
    
    self.attributesList = [NSMutableArray array];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.itemSize.width * [self.collectionView numberOfItemsInSection:0], self.collectionView.bounds.size.height);
}

+ (Class)layoutAttributesClass {
    return [CircularCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray * array = [NSMutableArray array];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    //圆心到item中心的距离,最大为1，所以要除一个item的高度
    
    CGFloat anchorPointY = (self.itemSize.height / 2.0 + self.radius) / self.itemSize.height;
    
     //判断是否在屏幕内,只创建在屏幕内的cell
    CGFloat theta = atan2(CGRectGetWidth(self.collectionView.bounds) / 2.0, self.radius + self.itemSize.height / 2.0 - CGRectGetHeight(self.collectionView.bounds) / 2.0);
    
    int startIndex = 0;
    int endIndex = (int)([self.collectionView numberOfItemsInSection:0] - 1);
    if (self.angle < -theta) {
        startIndex = (int)(floor((-theta - self.angle) / self.anglePerItem));
        
    }
    
    endIndex = MIN(endIndex, (int)(ceil((theta - self.angle) / self.anglePerItem)));
    
    if (endIndex < startIndex) {
        endIndex = 0;
        startIndex = 0;
    }
    
    for (int i =startIndex; i <= endIndex; i++) {
        CircularCollectionViewLayoutAttributes *attributes = [CircularCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        attributes.size = self.itemSize;
         //先放在屏幕中间
        attributes.center = CGPointMake(centerX, CGRectGetMidY(self.collectionView.bounds));
        //然后根据角度旋转item
        attributes.angle = self.angle + self.anglePerItem * i;
        
        attributes.anchorPoint = CGPointMake(0.5, anchorPointY);
        
        [array addObject:attributes];
    }
    
    self.attributesList = array;
    
}

-  (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesList;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributesList[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark getters
- (CGFloat)anglePerItem {
    return atan(self.itemSize.width / self.radius);
}

- (CGFloat)angleAtExtreme {
    return [self.collectionView numberOfItemsInSection:0] > 0 ? - ([self.collectionView numberOfItemsInSection:0] - 1) *self.anglePerItem : 0;
}

- (CGFloat)angle{
    return self.angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - CGRectGetWidth(self.collectionView.bounds));
    
}

#pragma mark setters
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    
    //radius改变的时候，重新计算所有元素
    [self invalidateLayout];
    
}

@end
