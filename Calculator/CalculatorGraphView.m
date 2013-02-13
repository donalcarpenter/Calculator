//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorGraphView.h"

@implementation CalculatorGraphView

@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#define DEFAULT_SCALE 1.0

- (void)drawRect:(CGRect)rect
{
    
    int x = self.bounds.origin.x + (self.bounds.size.width / 2);
    int y = self.bounds.origin.y + (self.bounds.size.height / 2);
    
    CGPoint point = CGPointMake(x, y);
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:point scale:DEFAULT_SCALE];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the line width and colour of the graph lines
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor brownColor] CGColor]);
    
    // loop through x axis and get y double value
    // then plot to CGPoint
    int startingPoint = self.bounds.origin.x;
    int endPoint = self.bounds.origin.y + self.bounds.size.width;
    
    CGContextMoveToPoint(context, startingPoint, 0);
    
    // get the offset needed for y coords
    int yAxisCoefficient = (self.bounds.size.height - self.bounds.origin.y) / 2;
    int xAxisCoefficient = (endPoint - startingPoint) / 2;
    
    
    // loop through and work out where to plot everything
    for (int i = startingPoint; i < endPoint; i+=1) {
        
        double x = i - xAxisCoefficient;
        double y = [self.dataSource yForX:x];
        
        // now we need to use the same idea to map y to a point
        float yAxisPoint = yAxisCoefficient - y;
        
        CGContextAddLineToPoint(context, i, yAxisPoint);
    }
    
    CGContextStrokePath(context);
}


@end
