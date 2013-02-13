//
//  CalculatorGraphViewController.h
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorGraphView.h"

@interface CalculatorGraphViewController: UIViewController <CalculatorGraphViewDataSource>

@property (strong) NSArray* program;

@property (strong, nonatomic) IBOutlet CalculatorGraphView *graphView;

@end
