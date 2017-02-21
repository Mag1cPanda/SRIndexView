//
//  SRIndexView.m
//  SRIndexView
//
//  Created by Mag1cPanda on 2016/12/7.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SRIndexView.h"

@implementation SRIndexView

-(instancetype)initWithFrame:(CGRect)frame indexArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.indexArray = [NSArray arrayWithArray:array];
        
        CGFloat hh = self.frame.size.height/self.indexArray.count;
        
        for (int i = 0; i < array.count; i ++)
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, i * hh, self.frame.size.width, hh)];
            label.text = self.indexArray[i];
            label.tag = TAG + i;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = STR_COLOR;
            label.font = FONT_SIZE;
            [self addSubview:label];
            
            _number = label.font.pointSize;
        }
        
        [self addSubview:self.animationLabel];
    }
    
    return self;
}

#pragma mark - Lazy
-(UILabel *)animationLabel
{
    if (!_animationLabel)
    {
        _animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/2 + self.frame.size.width/2, 100, 60, 60)];
        _animationLabel.layer.masksToBounds = YES;
        _animationLabel.layer.cornerRadius = 5.0f;
        _animationLabel.backgroundColor = [UIColor orangeColor];
        _animationLabel.textColor = [UIColor whiteColor];
        _animationLabel.alpha = 0;
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.font = [UIFont systemFontOfSize:18];
    }
    
    return _animationLabel;
}

#pragma mark - 选择索引响应事件
-(void)selectIndexBlock:(TouchMoved)block
{
    self.selectedBlock = block;
}

#pragma mark - animationWithSection
-(void)animationWithSection:(NSInteger)section
{ 
    self.selectedBlock(section);
    
    _animationLabel.text = self.indexArray[section];
    _animationLabel.alpha = 1.0;
}

#pragma mark - PanAnimationBegin
-(void)panAnimationBeginWithTouches:(NSSet<UITouch *> *)touches
{
    CGFloat labHeight = self.frame.size.height/self.indexArray.count;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i=0; i<self.indexArray.count; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:TAG + i];
        if (fabs(label.center.y - point.y) <= ANIMATION_Radius)
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                label.center = CGPointMake(label.bounds.size.width/2 - sqrt(fabs(ANIMATION_Radius * ANIMATION_Radius - fabs(label.center.y - point.y) * fabs(label.center.y - point.y))), label.center.y);
                
                label.font = [UIFont systemFontOfSize:_number + (ANIMATION_Radius - fabs(label.center.y - point.y)) * FONT_RATE];
                
                if (fabs(label.center.y - point.y) * ALPHA_RATE <= 0.08)
                {
                    label.textColor = MARK_COLOR;
                    label.alpha = 1.0;
                    
                    [self animationWithSection:i];
                    
                    for (int j = 0; j < self.indexArray.count; j ++)
                    {
                        UILabel * label = (UILabel *)[self viewWithTag:TAG + j];
                        if (i != j)
                        {
                            label.textColor = STR_COLOR;
                            label.alpha = fabs(label.center.y - point.y) * ALPHA_RATE;
                        }
                    }
                }
            }];
        }
        
        else
        {
            [UIView animateWithDuration:0.2 animations:^
             {
                 label.center = CGPointMake(self.frame.size.width/2, i * labHeight + labHeight/2);
                 label.font = FONT_SIZE;
                 label.alpha = 1.0;
             }];
        }
    }
}

#pragma mark - PanAnimationFinish
-(void)panAnimationFinish
{
    CGFloat labHeight = self.frame.size.height/self.indexArray.count;
    
    for (int i = 0; i < self.indexArray.count; i ++)
    {
        UILabel * label = (UILabel *)[self viewWithTag:TAG + i];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            label.center = CGPointMake(self.frame.size.width/2, i * labHeight + labHeight/2);
            label.font = FONT_SIZE;
            label.alpha = 1.0;
            label.textColor = STR_COLOR;
        }];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        self.animationLabel.alpha = 0;
        
    }];
}

#pragma mark - UIResponder
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationBeginWithTouches:touches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationBeginWithTouches:touches];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationFinish];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationFinish];
}

@end
