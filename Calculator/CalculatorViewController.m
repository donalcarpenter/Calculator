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
@property (nonatomic, weak, readonly) NSDictionary *variableValueCollection;

- (void) appendCurrentOperationWithString:(NSString *) string;

@end

@implementation CalculatorViewController

@synthesize userIsEnteringNumberRightNow = _userIsEnteringNumberRightNow;
@synthesize display = _display;
@synthesize variablesUsed = _variablesUsed;
@synthesize brain = _brain;
@synthesize currentOperation = _currentOperation;
@synthesize lastResult = _lastResult;
@synthesize variableValueCollection = _variableValueCollection;


- (NSDictionary *) variableValueCollection{
    if(!_variableValueCollection){
        _variableValueCollection =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithDouble:20], @"foo",
         [NSNumber numberWithDouble:40], @"bar",
         [NSNumber numberWithDouble:5],  @"x",
         [NSNumber numberWithDouble:10], @"y",
         nil];
    }
    
    return _variableValueCollection;
}

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

    } else {

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
    if(!self.userIsEnteringNumberRightNow){
        return;
    }
    
    self.userIsEnteringNumberRightNow = NO;
    [self.brain pushNumberOntoStack:[self.display.text doubleValue]];
    [self appendCurrentOperationWithString: self.display.text];
}


- (IBAction)operationPressed:(UIButton *)sender {
    [self enterPressed];
    [self appendCurrentOperationWithString: sender.currentTitle];
    
    self.lastResult = [self.brain performOperation: sender.currentTitle
                               usingVariableValues: self.variableValueCollection];    
    self.display.text = [NSString stringWithFormat:@"%g", self.lastResult];
    [self appendCurrentOperationWithString: self.display.text];
}

- (IBAction)clear {
    [self.brain clear];
    self.display.text = @"0";
    self.currentOperation.text = @"";
    self.userIsEnteringNumberRightNow = NO;
    self.variablesUsed.text = @"";
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *operandPressed = sender.currentTitle;
    
    NSLog(@"opreand pressed %@", operandPressed);
    
    self.userIsEnteringNumberRightNow = NO;
    
    [self.brain pushVariableOntoStack:operandPressed];
    
    self.display.text = operandPressed;
    
    [self appendCurrentOperationWithString: operandPressed];
    
    
    NSSet* usedVariables = [[self.brain class] variablesUsedInProgram:self.brain.program];
    self.variablesUsed.text = @"";
    
    for(NSString* var in usedVariables){
        if(self.variablesUsed.text.length!=0){
            self.variablesUsed.text = [self.variablesUsed.text stringByAppendingString:@", "];
        }
        
        self.variablesUsed.text = [self.variablesUsed.text stringByAppendingString:var];
        
    }
    
}

@end
