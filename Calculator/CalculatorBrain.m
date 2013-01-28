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
    double result = 0;
    double lastOperand;
    double penultimateOperand;
    
    if([operation isEqualToString:@"+"]){
        lastOperand = [self popNumberOffOfStack];
        penultimateOperand = [self popNumberOffOfStack];
        result = lastOperand + penultimateOperand;
    }
    
    if([operation isEqualToString:@"-"]){
        lastOperand = [self popNumberOffOfStack];
        penultimateOperand = [self popNumberOffOfStack];
        result = penultimateOperand - lastOperand;
    }
    
    if([operation isEqualToString:@"*"]){
        lastOperand = [self popNumberOffOfStack];
        penultimateOperand = [self popNumberOffOfStack];
        result = lastOperand * penultimateOperand;
    }

    if([operation isEqualToString:@"/"]){
        lastOperand = [self popNumberOffOfStack];
        penultimateOperand = [self popNumberOffOfStack];
        result = penultimateOperand / lastOperand;
    }
    
    if([operation isEqualToString:@"sin"]){
        lastOperand = [self popNumberOffOfStack];
        result = sin(lastOperand);
    }
    
    if([operation isEqualToString:@"cos"]){
        lastOperand = [self popNumberOffOfStack];
        result = cos(lastOperand);
    }
    
    if([operation isEqualToString:@"sqrt"]){
        lastOperand = [self popNumberOffOfStack];
        result = sqrt(lastOperand);
    }
    
    if([operation isEqualToString:@"pi"]){
        result = M_PI;
    }
    
    // don't forget to push the last result
    [self pushNumberOntoStack:result];
    
    return result;
}

-(void) clear{
    [self.stack removeAllObjects];
}

@end
