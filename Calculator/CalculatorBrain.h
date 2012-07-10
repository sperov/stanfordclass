//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double) performOperation:(NSString *) operation;
- (void) clearAll;

@property (readonly) id program;
+ (double) runProgram:(id) program;
+ (NSString* ) descriptionOfProgram:(id)program;

@end

