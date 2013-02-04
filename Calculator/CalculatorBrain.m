//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 1/23/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong, readonly) NSMutableArray *stack;
@end
@implementation CalculatorBrain

@synthesize stack = _stack;

- (id) program{
    return [self.stack copy];
}

+ (NSString *) descriptionOfProgram:(id)program{
    return @"dunno how to implement this yet";
}

+ (double)runProgram:(id)program
{
    NSMutableArray *tmpstack;
    if ([program isKindOfClass:[NSArray class]]) {
        tmpstack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:tmpstack];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = (NSString *)topOfStack;
        
        double result = 0;
        double lastOperand;
        double penultimateOperand;
        
        if([operation isEqualToString:@"+"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            penultimateOperand = [self popOperandOffProgramStack:stack];
            result = lastOperand + penultimateOperand;
        }
        
        else if([operation isEqualToString:@"-"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            penultimateOperand = [self popOperandOffProgramStack:stack];
            result = penultimateOperand - lastOperand;
        }
        
        else if([operation isEqualToString:@"*"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            penultimateOperand = [self popOperandOffProgramStack:stack];
            result = lastOperand * penultimateOperand;
        }
        
        else if([operation isEqualToString:@"/"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            penultimateOperand = [self popOperandOffProgramStack:stack];
            result = penultimateOperand / lastOperand;
        }
        
        else if([operation isEqualToString:@"sin"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            result = sin(lastOperand);
        }
        
        else if([operation isEqualToString:@"cos"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            result = cos(lastOperand);
        }
        
        else if([operation isEqualToString:@"sqrt"]){
            lastOperand = [self popOperandOffProgramStack:stack];
            result = sqrt(lastOperand);
        }
        
        else if([operation isEqualToString:@"pi"]){
            result = M_PI;
        }
        
        // don't forget to push the last result
        // [self pushNumberOntoStack:result];
        
        return result;
    }
    
    return result;
}

-(NSMutableArray *) stack{
    if(!_stack){
        _stack = [[NSMutableArray alloc] init];
    }
    return _stack;
}

- (void)pushNumberOntoStack: (double)number{
    NSNumber *numberObject = [NSNumber numberWithDouble:number];
    [self.stack addObject:numberObject];
}

- (double)popNumberOffOfStack{
    NSNumber *popme = [self.stack lastObject];
    if(popme){
        [self.stack removeLastObject];
    }
    return [popme doubleValue];
}

- (double) performOperation:(NSString *)operation  {
    [self.stack addObject:operation];
    return [[self class] runProgram:self.program];
}

-(void) clear{
    [self.stack removeAllObjects];
}

@end
