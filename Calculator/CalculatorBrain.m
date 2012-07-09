//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray* operandStack;

@end

@implementation CalculatorBrain


@synthesize operandStack = _operandStack;

- (NSMutableArray* ) operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];  
    return _operandStack;
}

- (void) pushOperand:(double)operand

{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) popOperand 
{
    NSNumber* operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double) performOperation:(NSString *) operation
{
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"PI"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    }
    
    [self pushOperand:result];
    return result;
}

@end
