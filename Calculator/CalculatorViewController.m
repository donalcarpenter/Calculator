//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 1/23/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) bool userIsEnteringNumberRightNow;
@property (nonatomic, strong, readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize userIsEnteringNumberRightNow = _userIsEnteringNumberRightNow;
@synthesize display = _display;
@synthesize brain = _brain;

- (CalculatorBrain*) brain{
    if(!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *numberPressed = sender.currentTitle;
    
    NSLog(@"Number pressed %@", numberPressed);
    
    if([@"." isEqualToString:numberPressed]){
        NSRange range = [self.display.text rangeOfString:@"."];
        if(range.location != NSNotFound){
            return;
        }
    }
    
    if(self.userIsEnteringNumberRightNow){
        self.display.text = [self.display.text stringByAppendingString:numberPressed];
    }else{
        self.display.text = numberPressed;
        self.userIsEnteringNumberRightNow  = YES;
    }

}
- (IBAction)enterPressed {
    self.userIsEnteringNumberRightNow = NO;
    [self.brain pushNumberOntoStack:[self.display.text doubleValue]];
}


- (IBAction)operationPressed:(UIButton *)sender {
    [self enterPressed];
    double result = [self.brain performOperation: sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%f", result];
}

@end
