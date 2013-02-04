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

+ (NSString *) descriptionOfProgram: (id) program;

- (void)pushNumberOntoStack: (double)number;

- (double)performOperation: (NSString *)operation;

- (void)clear;
@end
