//
//  FastestPathFinder.h
//  Connect4
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSize.h"
#import "MJDijkstra.h"
@interface FastestPathFinder : NSObject
typedef void (^FastestPathFinderBlock) (NSArray *path );
+(void)findFastestPathWithOccupiedCells:(NSArray*)OccupiedCells withSize:(MSize*)Size withStart:(NSNumber*)start WithEnd:(NSNumber*)end WithCompletionBlock:(FastestPathFinderBlock)block;
@end
