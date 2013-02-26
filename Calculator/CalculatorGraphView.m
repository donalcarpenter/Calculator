//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorGraphView.h"

@interface CalculatorGraphView()
-(void) setup;
@property CGPoint origin;
@property CGFloat zoomFactor;
@end

@implementation CalculatorGraphView

#define DEFAULT_SCALE 1.0

BOOL _originSet = NO;
BOOL _zoomSet = NO;

@synthesize origin = _origin;
@synthesize dataSource = _dataSource;
@synthesize zoomFactor = _zoomFactor;


-(CGPoint) origin{

    // if the origin has not been explicitly set
    // then use the centre of the bounds
    if(!_originSet){
        int x = self.bounds.origin.x + (self.bounds.size.width / 2);
        int y = self.bounds.origin.y + (self.bounds.size.height / 2);
        
        return CGPointMake(x, y);
    }
    
    return _origin;
}

-(void) setOrigin:(CGPoint) origin{
    
    _originSet = YES;
    _origin = origin;
    
    // if the origin changed then we need to
    // tell ios to redraw
    [self setNeedsDisplay];
    
}

-(CGFloat) zoomFactor{
    if(!_zoomSet){
        return 1.0;
    }
    
    return _zoomFactor;
}

-(void) setZoomFactor:(CGFloat)zoomFactor{
    _zoomFactor = zoomFactor;
    _zoomSet = YES;
    
    [self setNeedsDisplay];
}

-(void) setup{
    
    // not sure if we need to add some check to see if this
    // has alreay run
    
    // add gesture recognizers
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOrigin:)]];
    
    UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setOriginWith:)];
    tapper.numberOfTapsRequired = 3;
    
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomWith:)]];
    
    [self addGestureRecognizer:tapper];
    
    _zoomSet = NO;
    _originSet = NO;
    
}

-(void) awakeFromNib{
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

-(void) zoomWith: (UIPinchGestureRecognizer *) sender{
    if(sender.state != UIGestureRecognizerStateChanged && sender.state != UIGestureRecognizerStateEnded){
        return;
    }
    
    NSLog(@"zoom scale %g", sender.scale);
    self.zoomFactor *= sender.scale;
    [sender setScale:1.0];
}

- (void) setOriginWith:(UITapGestureRecognizer *) sender
{
    if(sender.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    self.origin = [sender locationInView:self];
    
}

- (void) moveOrigin:(UIPanGestureRecognizer *)sender{
    
    if(sender.state != UIGestureRecognizerStateChanged && sender.state != UIGestureRecognizerStateEnded){
        return;
    }
    
    CGPoint pan = [sender translationInView:self];
    CGPoint newOrigin;

    // move the origin of the graph
    newOrigin.x = self.origin.x + pan.x;
    newOrigin.y = self.origin.y + pan.y;
    
    self.origin = newOrigin;
    
    [sender setTranslation:CGPointZero inView:self];
}

- (void) setAppropriateScaleAndOrigin{
    
    // we only want to run through this once
    if(_zoomSet || _originSet || !self.dataSource.hasProgramBeenDefined){
        return;
    }
        
    // loop through x axis and get y double value
    // then plot to CGPoint
    int startingPoint = self.bounds.origin.x;
    int endPoint = self.bounds.origin.x + self.bounds.size.width;
    
    // get the offset needed for y coords
    int yAxisCoefficient = self.origin.y;
    int xAxisCoefficient = self.origin.x;
    
    
    CGFloat minY = CGFLOAT_MAX, maxY = CGFLOAT_MIN;
    
    // loop through and work out where to plot everything
    for (int i = startingPoint; i < endPoint; i++) {
        
        
        double x = (i- xAxisCoefficient);
        double y = [self.dataSource yForX:x];
              
        if(y < minY){
            minY = y;
        }
        if(y > maxY){
            maxY = y;
        }
    }

    
    // pad out the values a little
    minY -= (minY * 0.1);
    maxY += (maxY * 0.1);
    
    // reset the scale & origin
    CGFloat totalRangeOfY = (maxY - minY) ;
    self.zoomFactor = self.bounds.size.height / totalRangeOfY;
    
    CGFloat newYOrigin = yAxisCoefficient + (((maxY + minY) / 2) * self.zoomFactor);
    self.origin = CGPointMake(self.origin.x, newYOrigin);
    
}

- (void)drawRect:(CGRect)rect
{
    
    [self setAppropriateScaleAndOrigin];
    
    CGFloat zoom = DEFAULT_SCALE * self.zoomFactor;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:zoom];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the line width and colour of the graph lines
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    
    // loop through x axis and get y double value
    // then plot to CGPoint
    int startingPoint = self.bounds.origin.x;
    int endPoint = self.bounds.origin.x + self.bounds.size.width;
    
    CGContextMoveToPoint(context, startingPoint, 0);
    
    // get the offset needed for y coords
    int yAxisCoefficient = self.origin.y;
    int xAxisCoefficient = self.origin.x;


    // loop through and work out where to plot everything
    for (int i = startingPoint; i < endPoint; i++) {
        
        double x = (i- xAxisCoefficient) / zoom;
        double y = [self.dataSource yForX:x];
        
        // now we need to use the inverse idea to map y to a point
        CGFloat yAxisPoint = (yAxisCoefficient - y  * zoom);
        
        CGContextAddLineToPoint(context, i, yAxisPoint);
        
    }

    CGContextStrokePath(context);
}


@end
