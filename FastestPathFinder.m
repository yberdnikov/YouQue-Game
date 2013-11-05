//
//  FastestPathFinder.m
//  Connect4
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "FastestPathFinder.h"

@implementation FastestPathFinder
+(void)findFastestPathWithOccupiedCells:(NSArray *)OccupiedCells withSize:(MSize *)Size withStart:(NSNumber *)start WithEnd:(NSNumber *)end WithCompletionBlock:(FastestPathFinderBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
    
        NSMutableDictionary *Graph = [NSMutableDictionary dictionary];
        
        for(int x=0 ;x<(Size.width*Size.height);x++)
        {
            if([OccupiedCells containsObject:[NSNumber numberWithInt:x]])
            {
                continue;
            }
            
            NSMutableDictionary *Neigboors = [NSMutableDictionary dictionary];
            
            BOOL isOnTheRightEdge = [FastestPathFinder isX:x OntheRightEdgeWithSize:Size];
            
            BOOL isOnTheLeftEdge = [FastestPathFinder isX:x OntheLeftEdgeWithSize:Size];
            
            BOOL isOnTheBottomEdge = [FastestPathFinder isX:x OntheBottomEdgeWithSize:Size];
            
            BOOL isOnTheTopEdge = [FastestPathFinder isX:x OntheTopEdgeWithSize:Size];
            
            if(!isOnTheLeftEdge && (![OccupiedCells containsObject:[NSNumber numberWithInt:x-Size.height]]))
                [Neigboors setObject:@1 forKey:[NSNumber numberWithInt:x-Size.height]];
            
            
            if(!isOnTheTopEdge && (![OccupiedCells containsObject:[NSNumber numberWithInt:x-1]]) )
                [Neigboors setObject:@1 forKey:[NSNumber numberWithInt:x-1]];
            
            
            
            if(!isOnTheBottomEdge && (![OccupiedCells containsObject:[NSNumber numberWithInt:x+1]]) )
                [Neigboors setObject:@1 forKey:[NSNumber numberWithInt:x+1]];
            
            if(!isOnTheRightEdge && (![OccupiedCells containsObject:[NSNumber numberWithInt:x+Size.height]]) )
                [Neigboors setObject:@1 forKey:[NSNumber numberWithInt:x+Size.height]];
            
            
            [Graph setObject:Neigboors forKey:[NSNumber numberWithInt:x]];
            
        }
        @try {
            // Try something
            NSArray *path =  [NSArray arrayWithArray: shortestPath(Graph, start, end)];
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
                block(path);
            });
            
            
        }
        @catch (NSException * e) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                
                block([NSArray array]);
            });
            
            
        }
        @finally {
            // Added to show finally works as well
            
            
        }
    });
   
    
}
+(BOOL)isX:(int)x OntheLeftEdgeWithSize:(MSize*)size
{
    return x-size.height<0;
}
+(BOOL)isX:(int)x OntheTopEdgeWithSize:(MSize*)size
{
 
    return ((x+size.height)/size.height)*(size.height) == (x+size.height);
}
+(BOOL)isX:(int)x OntheBottomEdgeWithSize:(MSize*)size
{
    return ((x+1)/size.height)*(size.height)==x+1;
}
+(BOOL)isX:(int)x OntheRightEdgeWithSize:(MSize*)size
{
    return x+size.height>((size.height*size.width)-1);
}
@end
