//
//  CalculatorGraphView.h
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@protocol CalculatorGraphViewDataSource <NSObject>

- (double) yForX:(double) x;
@property (readonly) BOOL hasProgramBeenDefined;

@end

@interface CalculatorGraphView : UIView

@property int scale;

-(void) moveOrigin: (UIPanGestureRecognizer*) sender;

@property (weak) id<CalculatorGraphViewDataSource> dataSource;

@end
