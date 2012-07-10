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

+ (BOOL) isOperation: (NSString* ) operation;
+ (BOOL) isDoubleOperation : (NSString*) operation;
+ (BOOL) isSingleOperation : (NSString*) operation;
+ (BOOL) isZeroOperation : (NSString*) operation;
+ (double) popOperandOffStack:(NSMutableArray*) stack;
+ (NSString* ) descriptionOfProgram:(id)program;
+ (NSString* ) descriptionOfTopOfStack:(NSMutableArray*) stack;


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

    
+ (double) runProgram:(id)program {
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    id currentObject; 
    for (int arrayIndex = 0; arrayIndex < [stack count]; arrayIndex++) {
        currentObject = [stack objectAtIndex:arrayIndex];
        // replace all variables with 0;
        if ([currentObject isKindOfClass:[NSString class]] && ![self isOperation:currentObject]) {
            [stack replaceObjectAtIndex:arrayIndex withObject:[NSNumber numberWithDouble:0]];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (double) runProgram: (id) program
   usingVariableValue:(NSDictionary *)variableValues {
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    id currentObject; 
    for (int arrayIndex = 0; arrayIndex < [stack count]; arrayIndex++) {
        currentObject = [stack objectAtIndex:arrayIndex];
        // replace all variables that are not defined with 0;
        if ([currentObject isKindOfClass:[NSString class]] && ![self isOperation:currentObject]) {
            if (![variableValues objectForKey:currentObject])
                [stack replaceObjectAtIndex:arrayIndex withObject:[NSNumber numberWithDouble:0]];
        }
    }
    return [self popOperandOffStack:stack];    
}

+ (NSString* ) descriptionOfProgram:(id)program {
    NSMutableArray* stack;
    NSString* result;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    result = [self descriptionOfTopOfStack:stack];
    while ([stack lastObject]) {
        result = [NSString stringWithFormat:@"%@, %@", result, [self descriptionOfTopOfStack:stack]];
    }
    return result;
}


+ (NSSet *) variablesUsedInProgram: (id) program {
    NSMutableSet* variableNames;
    if ([program isKindOfClass:[NSArray class]]) {
        id currentObject; 
        for (int arrayIndex = 0; arrayIndex < [program count]; arrayIndex++) {
            currentObject = [program objectAtIndex:arrayIndex];
            if ([currentObject isKindOfClass:[NSString class]] && ![self isOperation:currentObject])
                [variableNames addObject:currentObject]; // add object to the NSMutableSet
        }
    }
    return [variableNames copy];
}

+ (BOOL) isOperation:(NSString*) operation {
    NSSet* operations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sqrt", @"PI", nil];
    return [operations containsObject:operation];
}

+ (BOOL) isDoubleOperation:(NSString*) operation {
    NSSet* operations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [operations containsObject:operation];
}

+ (BOOL) isSingleOperation:(NSString*) operation {
    NSSet* operations = [NSSet setWithObjects:@"sqrt", @"sin", @"cos", nil];
    return [operations containsObject:operation];
}

+ (BOOL) isZeroOperation:(NSString *)operation {
    NSSet* operations = [NSSet setWithObjects:@"PI", nil];
    return [operations containsObject:operation];
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
            if (devidor == 0) {result = 0;} else {result = [self popOperandOffStack:stack] / devidor;}
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
            double squareRootOperand = [self popOperandOffStack:stack];
            if (squareRootOperand < 0) {
                result = 0;
            } else {
                result = sqrt(squareRootOperand);   
            }
        }
    }
    return result;
}

+ (NSString* ) descriptionOfTopOfStack:(NSMutableArray*) stack
            {
    NSString* result = @"0";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // convert NSNumber to NSString
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        
        result = [NSString stringWithFormat:@"%@", topOfStack];
    }
 
    if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString* operation = topOfStack;
        if ([self isDoubleOperation:operation]) {
            NSString* secondOperand = [self descriptionOfTopOfStack:stack]; 
            NSString* firstOperand = [self descriptionOfTopOfStack:stack];
            if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) {
                result = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, operation, secondOperand];
            } else {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", firstOperand, operation, secondOperand];  
            }
        } else if ([self isSingleOperation:operation]) {
            result = [NSString stringWithFormat:@"%@(%@)", operation, [self descriptionOfTopOfStack:stack]];
        } else if ([self isZeroOperation:operation]) {
            result = operation;
        }
    }
    
    return result;
}

- (void) clearAll {
    self.programStack = nil;
}
@end
