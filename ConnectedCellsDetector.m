//
//  ConnectedCellsDetector.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/21/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "ConnectedCellsDetector.h"
@interface ConnectedCellsDetector()
+(NSArray*)SearchForConnectedCellsHorizontallyWithGraph:(Graph*)graph;
+(NSArray*)SearchForConnectedCellsVerticallyWithGraph:(Graph*)graph;
+(NSArray*)SearchForConnectedCellsDiagonallyToTheRightDownWithGraph:(Graph*)graph;
+(NSArray*)SearchForConnectedCellsDiagonallyToTheRightUpWithGraph:(Graph*)graph;
+(NSArray*)SearchForConnectedCellsDiagonallyToTheLeftDownWithGraph:(Graph*)graph;
+(NSArray*)SearchForConnectedCellsDiagonallyToTheLeftUpWithGraph:(Graph*)graph;
@end
@implementation ConnectedCellsDetector
+(NSArray*)getConnectedCellsWithGraph:(Graph *)graph withCompletionBlock:(ResultArrayBlock)block
{
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
    
    
        NSArray *HorizontalArray = [ConnectedCellsDetector SearchForConnectedCellsHorizontallyWithGraph:graph];
        NSArray *VerticalArray = [ConnectedCellsDetector SearchForConnectedCellsVerticallyWithGraph:graph];
        NSArray *DiagonalRightDownArray = [ConnectedCellsDetector SearchForConnectedCellsDiagonallyToTheRightDownWithGraph:graph];
        NSArray *DiagonallyRightUp = [ConnectedCellsDetector SearchForConnectedCellsDiagonallyToTheRightUpWithGraph:graph];
        NSArray *DiagonalLeftDownArray = [ConnectedCellsDetector SearchForConnectedCellsDiagonallyToTheLeftDownWithGraph:graph];
        NSArray *DiagonallyLeftUpArray = [ConnectedCellsDetector SearchForConnectedCellsDiagonallyToTheLeftUpWithGraph:graph];
        
        NSMutableArray *result = [NSMutableArray array];
    

        [result addObjectsFromArray:HorizontalArray];
        [result addObjectsFromArray:VerticalArray];
        [result addObjectsFromArray:DiagonalLeftDownArray];
        [result addObjectsFromArray:DiagonalRightDownArray];
        [result addObjectsFromArray:DiagonallyRightUp];
        [result addObjectsFromArray:DiagonallyLeftUpArray];
    
    return result;
        //dispatch_async(dispatch_get_main_queue(), ^(void){
        
    
    
    
            //block(UniqueResult);
    
        
        //});
    
    
    //});
}
+(NSArray*)SearchForConnectedCellsHorizontallyWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    
    for(int i = 0;i<graph.size.height;i++)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        for(int j = 0 ;j<graph.size.width;j++)
        {
            GraphCell *CurrentCell = [graph getGraphCellWithX:j withY:i];
            
            
            
           BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
            
            
            /*if(ConnectedCells.count==CONNECTED_CELLS_COUNT)
            {
                [Result addObjectsFromArray:ConnectedCells];
                [ConnectedCells removeAllObjects];
            }*/
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    return Result;
}
+(BOOL)DetectConnectedCellsInaRowWithConnectedCellsArray:(NSMutableArray*)ConnectedCells withCurrentGCell:(GraphCell*)CurrentCell
{
    if(CurrentCell.color==unOccupied && [ConnectedCells count]<CONNECTED_CELLS_COUNT)
    {
        [ConnectedCells removeAllObjects];
        return NO;
    }
 
    GraphCell *LastCellInConnectedArray = nil;
    if(ConnectedCells.count>0 )
    {
        LastCellInConnectedArray  = [ConnectedCells lastObject];
        
        if(LastCellInConnectedArray.color!=CurrentCell.color && [ConnectedCells count]<CONNECTED_CELLS_COUNT)
        {
            [ConnectedCells removeAllObjects];
            [ConnectedCells addObject:CurrentCell];
            
        }else if (LastCellInConnectedArray.color!=CurrentCell.color && [ConnectedCells count]>=CONNECTED_CELLS_COUNT)
        {
            return YES;
         
            
        }else if (LastCellInConnectedArray.color==CurrentCell.color)
        {
            [ConnectedCells addObject:CurrentCell];
        }
        
        
        
        
    }else
    {
        [ConnectedCells addObject:CurrentCell];
    }

    return NO;
}
+(NSArray*)SearchForConnectedCellsVerticallyWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    for(int i = 0;i<graph.size.width;i++)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        for(int j = 0 ;j<graph.size.height;j++)
        {
            GraphCell *CurrentCell = [graph getGraphCellWithX:i withY:j];
            
            
            BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    return Result;
}
+(NSArray*)SearchForConnectedCellsDiagonallyToTheRightDownWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    for(int i = 0;i<graph.size.width;i++)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        for(int offset = 0;i+offset<graph.size.width && offset<graph.size.height;offset++)
        {
            GraphCell *CurrentCell = [graph getGraphCellWithX:i+offset withY:offset];
            
            
            BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
            
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    return Result;
}
+(NSArray*)SearchForConnectedCellsDiagonallyToTheRightUpWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    for(int i = 0;i<graph.size.height;i++)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        for(int offset = 0;i+offset<graph.size.height && offset<graph.size.width;offset++)
        {
            GraphCell *CurrentCell = [graph getGraphCellWithX:offset withY:i+offset];
            
            
            BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
            
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    return Result;
}

+(NSArray*)SearchForConnectedCellsDiagonallyToTheLeftDownWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    for(int i = graph.size.width-1;i>-1;i--)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        for(int offset = 0;i-offset>-1 && offset<graph.size.height;offset++)
        {
            GraphCell *CurrentCell = [graph getGraphCellWithX:i-offset withY:offset];
            
            
            BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
            
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    return Result;
}
+(NSArray*)SearchForConnectedCellsDiagonallyToTheLeftUpWithGraph:(Graph *)graph
{
    NSMutableArray *Result = [NSMutableArray array];
    
    
    for(int offset=0;offset<graph.size.height;offset++)
    {
        NSMutableArray *ConnectedCells = [NSMutableArray array];
        int y = offset;
        for(int x = graph.size.width-1;x>offset-1 ;x--)
        {
             GraphCell *CurrentCell = [graph getGraphCellWithX:x withY:y++];
            
            BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:ConnectedCells withCurrentGCell:CurrentCell];
            if(breakLoop)
            {
                break;
            }
        }
        if(ConnectedCells.count>=CONNECTED_CELLS_COUNT)
        {
            [Result addObject:ConnectedCells];
            
        }
    }
    
    return Result;
}
@end
