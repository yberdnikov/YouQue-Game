//
//  ConnectedCellsDetector.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/21/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#define CONNECTED_CELLS_COUNT 4
@interface ConnectedCellsDetector : NSObject
typedef void (^ResultArrayBlock)(NSArray *);
+(NSArray*)getConnectedCellsWithGraph:(Graph*)graph withCompletionBlock:(ResultArrayBlock)block;

@end
