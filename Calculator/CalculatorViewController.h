//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 1/23/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *currentOperation;
@property (weak, nonatomic) IBOutlet UILabel *variablesUsed;

- (IBAction)digitPressed:(UIButton *)sender;

@end
