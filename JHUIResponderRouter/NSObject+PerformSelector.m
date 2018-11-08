//
//  NSObject+PerformSelector.m
//  JHKit
//
//  Created by HaoCold on 2017/12/7.
//  Copyright © 2017年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    //
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    //
    if (!signature) {
        NSString *reason = [NSString stringWithFormat:@"oops~ unrecognized selector %@ sent to instance %@ : %lx",NSStringFromSelector(aSelector),[self class],(unsigned long)[self hash]];
        @throw [[NSException alloc] initWithName:@"com.haocold" reason:reason userInfo:nil];
        return nil;
    }
    
    //
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    
    // parameters
    // first: _cmd
    // second: target
    NSInteger arguments = signature.numberOfArguments - 2;
    
    //
    NSInteger count = MIN(arguments, objects.count);
    for (int i = 0; i < count; ++i) {
        id obj = objects[i];
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i+2];
    }
    
    //
    [invocation invoke];
    
    //
    id result = nil;
    if (signature.methodReturnLength != 0) {
        [invocation getReturnValue:&result];
    }
    
    return result;
}

@end
