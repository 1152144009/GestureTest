//
//  TouchView.m
//  手势动画
//
//  Created by dianzhi1 on 17/5/19.
//  Copyright © 2017年 dianzhi1. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
    
    //Gesture 手势  Recognizer 识别器
    //给三个imageview加上所需要的手势
    [self addGestureRecognizersToPiece:self];
    }
    return self;
}
- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    //UIGestureRecognizer与手势有关的基类
    //手势只会响应在最后添加的那个视图上
    //旋转手势
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    
    //缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    
    //滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
    [piece addGestureRecognizer:longPressGesture];
    
    
    //    UITapGestureRecognizer
    
    //    UISwipeGestureRecognizer
}

#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //UIGestureRecognizerStateBegan意味着手势已经被识别
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //手势发生在哪个view上
        UIView *piece = gestureRecognizer.view;
        //获得当前手势在view上的位置。
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        
        
        
        //根据在view上的位置设置锚点。
        //防止设置完锚点过后，view的位置发生变化，相当于把view的位置重新定位到原来的位置上。
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        piece.center = locationInSuperview;
    }
}



//重置所有变换
// animate back to the default anchor point and transform


// UIMenuController requires that we can become first responder or it won't display
//有没有能力成为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
//滑动手势
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"panPiecepanPiecepanPiecepanPiece  %d",gestureRecognizer.state);
    
    //在当前的哪个view上发生了这个手势。
    
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        UIView *piece = [gestureRecognizer view];
        //获得手势在父视图中移动的位置
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        //重置这个手势的滑动距离。
        //
        //CGPointMake(0, 0) ==CGPointZero
        //CGRectZero
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
//旋转手势
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    
    NSLog(@"rotatePiecerotatePiecerotatePiecerotatePiecerotatePiece  %d",gestureRecognizer.state);
    
    //调整锚点
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    
    //当手势被识别出来的时候
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        
        
        // gestureRecognizer.view 在哪个view上做的手势
        //CGAffineTransformRotate 在原来的基础上旋转多少度
        gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation );
        //旋转到多少度
        // CGAffineTransformMakeRotation(90);
        //CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        //在当前的旋转矩阵上再旋转多少度（在view的当前状态下旋转多少度）
        //因为gestureRecognizer.rotation 会累加，所以我们每次都把他清0 ，这样我们下次旋转的时候得到的gestureRecognizer.rotation 都是当前这次旋转了多少度，就可以调用，CGAffineTransformRotate，来在原来的基础上旋转多少度
        gestureRecognizer.rotation = 0;
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
//缩放手势
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
//判断手势之间是否可以同时作用。

@end
