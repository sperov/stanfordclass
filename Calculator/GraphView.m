//
//  GraphView.m
//  Calculator
//
//  Created by Sergey Perov on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (void) setup {
    self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#define DEFAULT_SCALE 1

- (CGFloat) scale { 
    if (!_scale) {
        return [[NSUserDefaults standardUserDefaults] doubleForKey:@"scale"] ? [[NSUserDefaults standardUserDefaults] doubleForKey:@"scale"] : DEFAULT_SCALE;
    }
    return _scale;
}

- (void) setScale:(CGFloat)scale {
    if (_scale != scale) {
        _scale = scale;
        [[NSUserDefaults standardUserDefaults] setDouble:scale forKey:@"scale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setNeedsDisplay];   
        
    }
}

- (CGPoint) origin {
    if (!_origin.x && !_origin.y) {
        _origin.x = [[NSUserDefaults standardUserDefaults] doubleForKey:@"xorigin"];
        _origin.y = [[NSUserDefaults standardUserDefaults] doubleForKey:@"yorigin"];
        
        if (!_origin.x) _origin.x = self.bounds.origin.x + self.bounds.size.width/2;
        if (!_origin.y) _origin.y = self.bounds.origin.y + self.bounds.size.width/2;
        
        return _origin;
    }
    return _origin;
}

- (void) setOrigin:(CGPoint) origin {
    if (!CGPointEqualToPoint(origin, _origin)) {
        _origin = origin;
        [[NSUserDefaults standardUserDefaults] setDouble:_origin.x forKey:@"xorigin"];
        [[NSUserDefaults standardUserDefaults] setDouble:_origin.y forKey:@"yorigin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setNeedsDisplay];
    }
}
- (void) pinch:(UIPinchGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded ) {
        self.scale *= gesture.scale; 
        NSLog(@"self.scale within pinch is %f", self.scale);
        gesture.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded ) {
        CGPoint translation = [gesture translationInView:self];
        // translation.x += self.origin.x;
        // translation.y += self.origin.y;
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + translation.x;
        newOrigin.y = self.origin.y + translation.y;
        
        NSLog(@"self.origin.x  is %f, translation x is %f", self.origin.x, translation.x);
        NSLog(@"self.origin.y  is %f, translation y is %f", self.origin.y, translation.y);
        
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self];
        
    }
}

- (void) tripleTap:(UITapGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateEnded ) {
       self.origin = [gesture locationInView:self];        
    }
}   

- (void)drawRect:(CGRect)rect
{
    double xGraphValue, yGraphValue; 
    int currentXPixel, currentYPixel;
    double horizontalScreenPixels = self.bounds.size.width * self.contentScaleFactor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0 / self.contentScaleFactor);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    // draw axis using the helper class provided
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    
    [[UIColor blackColor] setStroke];
    // move to the first point
    xGraphValue = - self.origin.x / self.scale;
    yGraphValue = [self.dataSource getProgramValue:xGraphValue];
    yGraphValue *= -1;  // convert to the Y going up instead of down
    currentYPixel = yGraphValue * self.scale + self.origin.y;
    CGContextMoveToPoint(context, 0, currentYPixel);
    
    // now go through all the other points on the screen
    for (currentXPixel = 1;  currentXPixel < horizontalScreenPixels; currentXPixel++) {
        xGraphValue = (currentXPixel - self.origin.x)/ self.scale;
        yGraphValue = [self.dataSource getProgramValue:xGraphValue];
        yGraphValue *= -1; 
        currentYPixel = yGraphValue * self.scale + self.origin.y;
        CGContextAddLineToPoint(context, currentXPixel, currentYPixel);
        CGContextMoveToPoint(context, currentXPixel, currentYPixel);
    }
    CGContextStrokePath(context);
}

@end
