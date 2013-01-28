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
@property (nonatomic) double lastResult;

- (void) appendCurrentOperationWithString:(NSString *) string;
@end

@implementation CalculatorViewController

@synthesize userIsEnteringNumberRightNow = _userIsEnteringNumberRightNow;
@synthesize display = _display;
@synthesize brain = _brain;
@synthesize currentOperation = _currentOperation;
@synthesize lastResult = _lastResult;

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
        if(self.lastResult != 0){
            self.currentOperation.text = [NSString stringWithFormat:@"%g", self.lastResult];
        }
    }

}

- (void) appendCurrentOperationWithString:(NSString *) string{
    self.currentOperation.text = [self.currentOperation.text stringByAppendingFormat:@" %@", string];
}

- (IBAction)enterPressed {
    self.userIsEnteringNumberRightNow = NO;
    [self.brain pushNumberOntoStack:[self.display.text doubleValue]];
    [self appendCurrentOperationWithString: self.display.text];
}


- (IBAction)operationPressed:(UIButton *)sender {
    [self enterPressed];
    [self appendCurrentOperationWithString: sender.currentTitle];
    self.lastResult = [self.brain performOperation: sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", self.lastResult];
    [self appendCurrentOperationWithString: self.display.text];
}

- (IBAction)clear {
    [self.brain clear];
    self.display.text = @"0";
    self.currentOperation.text = @"";
    self.userIsEnteringNumberRightNow = NO;
}

@end
