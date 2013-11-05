//
//  ConnectedCellRowsDetector.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/10/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#define CONNECTED_CELLS_COUNT 4
typedef void (^DetectedResultArrayBlock)(NSArray *);
@interface ConnectedCellRowsDetector : NSObject
+(void)getConnectedCellsWithGraph:(Graph*)graph withVertices:(NSArray*)vertices withCompletionBlock:(DetectedResultArrayBlock)block;
@end
