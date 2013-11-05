//
//  RandomUnOccupiedCellsGenerator.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/22/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomUnOccupiedCellsGenerator : NSObject
typedef void (^RandomGenerationBlock)(NSArray *result);
+(void)GenerateRandomUnOccupiedCellsIndexes:(int)count WithUnOccupiedCells:(NSArray*)UnOccupiedCells withCompletionBlock:(RandomGenerationBlock)block;
@end
