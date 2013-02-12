//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorGraphView.h"

@implementation CalculatorGraphView

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
    CGPoint point = CGPointMake(0, 0);
    [AxesDrawer drawAxesInRect:rect originAtPoint:point scale:DEFAULT_SCALE];
}


@end
