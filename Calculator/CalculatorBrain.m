//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray* programStack;

@end

@implementation CalculatorBrain


@synthesize programStack = _programStack;

- (NSMutableArray* ) programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];  
    return _programStack;
}

- (void) pushOperand:(double)operand

{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id) program {
    return [self.programStack copy];
}

+ (NSString* ) descriptionOfProgram:(id)program {
    return @"Bad line";
}
    
+ (double) runProgram:(id)program {
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) popOperandOffStack:(NSMutableArray*) stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue]; 
    }
         
    if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString* operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"/" isEqualToString:operation]) {
            double devidor = [self popOperandOffStack:stack];   
            result = [self popOperandOffStack:stack] / devidor;
        } else if ([@"-" isEqualToString:operation]) {
            double subtractor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtractor;
        } else if ([operation isEqualToString:@"PI"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    return result;
}

- (void) clearAll {
    self.programStack = nil;
}
@end
