//
//  Sprite.m
//  AnimationTest
//
//  Created by 周祺华 on 2016/11/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

-(id) initWithPic: (NSString *) picName
         frameCnt: (int) fcnt
        frameStep: (int) fstp
            speed: (CGPoint) sxy
              pos: (CGPoint) pxy {
    
    if (self = [super init]) {
        pic = [UIImage imageNamed: picName];
        speed = sxy;
        pos = pxy;
        cnt = 0;
        frameNr = 0;
        frameCnt = fcnt;
        frameStep = fstp;
        frameW = pic.size.width/frameCnt;
        frameH = pic.size.height;
        type = -1;
    }
    
    return self;
}

- (void) setType: (int) spriteType {
    type = spriteType;
}

- (int) getType {
    return type;
}

- (CGRect) getRect {
    return CGRectMake(pos.x, pos.y, frameW, frameH);
}

- (void) draw {
    pos.x+=speed.x;
    pos.y+=speed.y;
    [self drawFrame];
}

- (void) drawFrame {
    frameNr = [self updateFrame];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    pos.x = rintf(pos.x);
    CGContextClipToRect(ctx, CGRectMake(pos.x, pos.y, frameW, frameH));
    [pic drawAtPoint: CGPointMake(pos.x-frameNr*frameW, pos.y)];
    
    CGContextRestoreGState(ctx);
}

- (int) updateFrame {
    if (frameStep != 0) {
        if (frameStep == cnt) {
            cnt = 0;
            frameNr++;
            if (frameNr > frameCnt-1) {
                frameNr = 0;
            }
        }
        cnt++;
    }
    return frameNr;
}

- (BOOL) checkColWithSprite: (Sprite *) sprite {
    CGRect rect1 = [self getRect];
    CGRect rect2 = [sprite getRect];
    
    //Rect 1
    int x1=rect1.origin.x;
    int y1=rect1.origin.y;
    int w1=rect1.size.width;
    int h1=rect1.size.height;
    
    //Rect 2
    int x3=rect2.origin.x;
    int y3=rect2.origin.y;
    int w2=rect2.size.width;
    int h2=rect2.size.height;
    
    int x2=x1+w1, y2=y1+h1;
    int x4=x3+w2, y4=y3+h2;
    
    if (   x2 >= x3
        && x4 >= x1
        && y2 >= y3
        && y4 >= y1) {
        return true;
    }
    return false;
}

- (BOOL)checkDistanceBetween:(CGPoint)p1 and:(CGPoint)p2 lessThan:(CGFloat)d
{
    CGFloat res = (p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y);
    if (res < d*d) {
        return YES;
    }
    
    return NO;
}

@end
