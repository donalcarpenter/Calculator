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

+(NSSet *)supportedOperations;

@end
@implementation CalculatorBrain

@synthesize stack = _stack;

- (id) program{
    return [self.stack copy];
}

+(NSSet *) supportedOperations{
    static NSSet* _supportedOps;
    if(!_supportedOps){
        _supportedOps = [[NSSet alloc] initWithObjects:@"*", @"+", @"-", @"/", @"sqrt", @"pi", nil];
    }
    return _supportedOps;
}

-(NSMutableArray *) stack{
    if(!_stack){
        _stack = [[NSMutableArray alloc] init];
    }
    return _stack;
}

+ (NSString *) descriptionOfProgram:(id)program{
    return @"dunno how to implement this yet";
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:Nil];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *) variableValues
{
    NSMutableArray *tmpstack;
    if ([program isKindOfClass:[NSArray class]]) {
        tmpstack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:tmpstack usingVariableValues:variableValues];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack{
    return [self popOperandOffProgramStack:stack usingVariableValues:Nil];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
 usingVariableValues:(NSDictionary *) variableValues
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

        if(![[self supportedOperations] containsObject:topOfStack]){
            NSNumber *variableNumber = [variableValues valueForKey:operation];
            
            // will return 0 if variableNumber is nil (ie, no
            // variabless passed; or this variable doesn't exist)
            return [variableNumber doubleValue];
        }
        
        double result = 0;
        double lastOperand;
        double penultimateOperand;
        
        if([operation isEqualToString:@"+"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            penultimateOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = lastOperand + penultimateOperand;
        }
        
        else if([operation isEqualToString:@"-"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            penultimateOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = penultimateOperand - lastOperand;
        }
        
        else if([operation isEqualToString:@"*"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            penultimateOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = lastOperand * penultimateOperand;
        }
        
        else if([operation isEqualToString:@"/"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            penultimateOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = penultimateOperand / lastOperand;
        }
        
        else if([operation isEqualToString:@"sin"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = sin(lastOperand);
        }
        
        else if([operation isEqualToString:@"cos"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = cos(lastOperand);
        }
        
        else if([operation isEqualToString:@"sqrt"]){
            lastOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
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

- (void)pushNumberOntoStack: (double)number{
    NSNumber *numberObject = [NSNumber numberWithDouble:number];
    [self.stack addObject:numberObject];
}

- (void)pushVariableOntoStack: (NSString*) variableName{
    [self.stack addObject:variableName];
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

- (double) performOperation:(NSString *)operation
        usingVariableValues:(NSDictionary *)variableValues {
    
    [self.stack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];
    
}

-(void) clear{
    [self.stack removeAllObjects];
}

+ (NSSet *) variablesUsedInProgram:(id)program{

    BOOL variablesFound = NO;
    
    if(![program isKindOfClass:[NSArray class]]){
        return nil;
    }
    
    NSMutableSet *listOfVariableNames = [[NSMutableSet alloc] init];
    
    NSArray *stack = (NSArray*)program;
    
    for (id operand in stack) {
        // if the operand is not a string then move
        // to next operand on the stack
        if(![operand isKindOfClass:[NSString class]]){
            continue;
        }
        
        NSString* variableOrOperation = (NSString*)operand;
        
        // check the supported operations
        if([[self supportedOperations] containsObject:variableOrOperation]){
            continue;
        }
        
        variablesFound = YES;
        
        if(![listOfVariableNames containsObject:variableOrOperation]){
            // add to the list of known variable names
            [listOfVariableNames addObject:variableOrOperation];
        }
    }
    
    
    if(variablesFound){
        return [listOfVariableNames copy];
    }

    
    return nil;
}

@end
