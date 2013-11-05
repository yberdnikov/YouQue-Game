//
//  ConnectedCellRowsDetector.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/10/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "ConnectedCellRowsDetector.h"

@implementation ConnectedCellRowsDetector
+(void)getConnectedCellsWithGraph:(Graph*)graph withVertices:(NSArray*)vertices withCompletionBlock:(DetectedResultArrayBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        
        NSMutableArray *result = [NSMutableArray array];
        
        for(GraphCell *GCell in vertices)
        {
            [result addObjectsFromArray:[self detectConnectedRowsVerticallyWithGraph:graph withVertixe:GCell]];
            [result addObjectsFromArray:[self detectConnectedRowsHorizontallyWithGraph:graph withVertixe:GCell]];
            [result addObjectsFromArray:[self detectConnectedRowsDiagonallyToTheRightWithGraph:graph withVertixe:GCell]];
            [result addObjectsFromArray:[self detectConnectedRowsDiagonallyToTheLeftWithGraph:graph withVertixe:GCell]];
        }
        NSSet *set = [NSSet setWithArray:result];
        NSArray *uniqueArray = [set allObjects];
        dispatch_async(dispatch_get_main_queue(), ^(void){
        
        
            block(uniqueArray);
        });
        
    });
    //return result;
}
+(NSArray*)detectConnectedRowsVerticallyWithGraph:(Graph*)graph withVertixe:(GraphCell*)VertixGCell
{
    NSMutableArray *result = [NSMutableArray array];
    
    
    CGPoint VertixCellPoint = [VertixGCell getPointWithSize:graph.size];
    int StartX = VertixCellPoint.x;
    int StartY = 0;
    for(int i = 0;i<graph.size.height;i++)
    {
        
        BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:result withCurrentGCell:[graph getGraphCellWithX:StartX withY:StartY+i]];
        if(breakLoop)
        {
            break;
        }
    }
    if(result.count>=CONNECTED_CELLS_COUNT)
    {
        return result;
    }
    return [NSArray array];
}
+(NSArray*)detectConnectedRowsHorizontallyWithGraph:(Graph*)graph withVertixe:(GraphCell*)VertixGCell
{
    NSMutableArray *result = [NSMutableArray array];
    CGPoint VertixCellPoint = [VertixGCell getPointWithSize:graph.size];
    int StartX = 0;
    int StartY = VertixCellPoint.y;
    
    for(int i = 0;i<graph.size.width;i++)
    {
        
        BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:result withCurrentGCell:[graph getGraphCellWithX:StartX+i withY:StartY]];
        if(breakLoop)
        {
            break;
        }
    }
    
    if(result.count>=CONNECTED_CELLS_COUNT)
    {
        return result;
    }
    return [NSArray array];
}
+(NSArray*)detectConnectedRowsDiagonallyToTheRightWithGraph:(Graph*)graph withVertixe:(GraphCell*)VertixGCell
{
    NSMutableArray *result = [NSMutableArray array];
    CGPoint VertixCellPoint = [VertixGCell getPointWithSize:graph.size];
    int StartX = VertixCellPoint.x;
    int StartY = VertixCellPoint.y;
    //int limit = 1;
    int EndX = VertixCellPoint.x;
    int EndY = VertixCellPoint.y;
    
    for(int z=0;z<(graph.size.width>graph.size.height?graph.size.width:graph.size.height);z++)
    {
        
        if(EndY==0 || EndX==graph.size.width-1)
        {
            break;
        }
        EndX++;
        EndY--;
    }
    
    for(int z=0;z<(graph.size.width>graph.size.height?graph.size.width:graph.size.height);z++)
    {
        
        if(StartY==graph.size.height-1 || StartX==0)
        {
            break;
        }
        StartX--;
        StartY++;
    }
    
    
    for(int i = 0 ;StartX+i<=EndX||StartY-i>=EndY;i++)
    {
        BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:result withCurrentGCell:[graph getGraphCellWithX:StartX+i withY:StartY-i]];
        if(breakLoop)
        {
            break;
        }
    }
    
    if(result.count>=CONNECTED_CELLS_COUNT)
    {
        return result;
    }
    return [NSArray array];
}
+(NSArray*)detectConnectedRowsDiagonallyToTheLeftWithGraph:(Graph*)graph withVertixe:(GraphCell*)VertixGCell
{
    NSMutableArray *result = [NSMutableArray array];
    CGPoint VertixCellPoint = [VertixGCell getPointWithSize:graph.size];
    int StartX = 0;
    int StartY = 0;
    int iteratorLimit = 0;
    if(VertixCellPoint.x>VertixCellPoint.y)
    {
        StartY = 0;
        StartX = VertixCellPoint.x-VertixCellPoint.y;
        iteratorLimit = graph.size.width-1-StartX;
    }else if (VertixCellPoint.y>VertixCellPoint.x)
    {
        StartX = 0;
        StartY = VertixCellPoint.y-VertixCellPoint.x;
        iteratorLimit = graph.size.height-1-StartY;
    }else
    {
        StartX = 0;
        StartY = 0;
        iteratorLimit = graph.size.height>graph.size.width?graph.size.width:graph.size.height;
        iteratorLimit--;
    }
    for(int i = 0 ;i<=iteratorLimit;i++)
    {
        BOOL breakLoop = [self DetectConnectedCellsInaRowWithConnectedCellsArray:result withCurrentGCell:[graph getGraphCellWithX:StartX+i withY:StartY+i]];
        if(breakLoop)
        {
            break;
        }
    }
    if(result.count>=CONNECTED_CELLS_COUNT)
    {
        return result;
    }
    return [NSArray array];
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

@end
