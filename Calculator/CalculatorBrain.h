//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 1/23/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;

+ (double) runProgram: (id)program;

+ (double) runProgram: (id)program
  usingVariableValues:(NSDictionary *) variableValues;

+ (NSString *) descriptionOfProgram: (id) program;

- (void)pushNumberOntoStack: (double)number;

- (void)pushVariableOntoStack: (NSString *)variableName;

- (double)performOperation: (NSString *)operation;

- (double)performOperation: (NSString *)operation
       usingVariableValues: (NSDictionary *) variableValues;

- (void)clear;
@end
