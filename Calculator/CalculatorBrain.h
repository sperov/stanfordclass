//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

// instance methods
- (void) pushOperand:(id)operand;
- (double) performOperation:(NSString *) operation;
- (double) performOperation:(NSString* ) operation usingVariableValue:(NSDictionary* ) variableValues; 
- (void) clearAll;

// class methods
+ (double) runProgram:(id) program;
+ (double) runProgram:(id) program usingVariableValue:(NSDictionary*) variableValues;
+ (NSString* ) descriptionOfProgram:(id) program;
+ (NSSet *) variablesUsedInProgram: (id) program;
+ (NSString *) getLastDisplayValue: (id) program usingVariableValue:(NSDictionary*) variableValues;

@end
