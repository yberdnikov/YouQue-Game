//
//  Graph.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/21/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "Graph.h"
@interface Graph()
@property(nonatomic,retain)NSMutableArray *graphArray;
@end
@implementation Graph
-(id)initWithSize:(MSize *)size
{
    self = [super init];
    if(self)
    {
        _size = size;
        self.graphArray = [NSMutableArray array];
        int TotalNoOfCells = self.size.width*self.size.height;
        for(int i = 0;i< TotalNoOfCells;i++)
        {
            GraphCellStatus stat = unOccupied;
           
            GraphCell *cell = [[GraphCell alloc] initWithColor:stat] ;
            
            
            [self AddGraphCell:cell];
        }
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.graphArray = [aDecoder decodeObjectForKey:@"graphArray"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.graphArray forKey:@"graphArray"];
    [aCoder encodeObject:self.size forKey:@"size"];
}
-(void)AddGraphCell:(GraphCell *)cell
{
    
    
    int Currentindex = self.graphArray.count;
    
    
    cell.x = Currentindex%self.size.width;
    cell.y = Currentindex/self.size.width;
    cell.index = Currentindex;
    [self.graphArray addObject:cell];
    
}
-(GraphCell*)getGraphCellWithIndex:(int)index
{
    GraphCell *cell = nil;
    if(index<self.graphArray.count)
        cell = [self.graphArray objectAtIndex:index];
    return cell;
}
-(void)UpdateGraphCellAtIndex:(int)index WithCell:(GraphCell*)cell
{
    
    [self.graphArray replaceObjectAtIndex:index withObject:cell];
    
}
-(void)UpdateGraphCellAtX:(int)x AndY:(int)Y WithCell:(GraphCell*)cell
{
    
    GraphCell *OldCell = [self getGraphCellWithX:x withY:Y];
    [self.graphArray replaceObjectAtIndex:[self.graphArray indexOfObject:OldCell] withObject:cell];
    
}
-(int)indexWithX:(int)x AndY:(int)y
{
    return y*self.size.width+x;
}
-(GraphCell*)getGraphCellWithX:(int)x withY:(int)y
{
    int index = x*self.size.width+y;
    
    GraphCell *cell = nil;
    if(index<self.graphArray.count)
        cell = [self.graphArray objectAtIndex:index];
    
    return cell;
}
-(void)ExchangeCellAtIndex:(int)FromIndex WithCellAtIndex:(int)ToIndex
{
    if(FromIndex<self.graphArray.count && ToIndex<self.graphArray.count)
    {
        GraphCell *fromGCell = [self getGraphCellWithIndex:FromIndex];
        GraphCell *toGCell = [self getGraphCellWithIndex:ToIndex];
        
        int fromI = fromGCell.index;
        
        fromGCell.index = toGCell.index;
        
        toGCell.index = fromI;
        
        [self.graphArray exchangeObjectAtIndex:FromIndex withObjectAtIndex:ToIndex];
    }
    
}
-(NSArray*)getOcuupiedCells
{
    NSMutableArray *OccupiedCells = [NSMutableArray array];
    for(GraphCell *cell in self.graphArray)
    {
        if(cell.color!=unOccupied && !cell.temporarilyUnoccupied)
        {
            NSNumber *number = [NSNumber numberWithInt:[self.graphArray indexOfObject:cell]];
            [OccupiedCells addObject:number];
        }
    }
    return OccupiedCells;
}
-(NSArray*)getUnOccupiedCells
{
    NSMutableArray *UnOccupiedCells = [NSMutableArray array];
    for(GraphCell *cell in self.graphArray)
    {
        if(cell.color==unOccupied)
        {
            NSNumber *number = [NSNumber numberWithInt:[self.graphArray indexOfObject:cell]];
            [UnOccupiedCells addObject:number];
        }
    }
    return UnOccupiedCells;
}
-(int)getIndexOfGraphCell:(GraphCell*)GCell
{
    return [self.graphArray indexOfObject:GCell];
}
-(void)ResetGraph
{
    for(GraphCell *cell in _graphArray)
    {
        cell.color = unOccupied;
        cell.temporarilyUnoccupied = NO;
    }
}
-(void)dealloc
{
    
}
-(id)copyWithZone:(NSZone *)zone
{
    Graph *copy = [[Graph alloc] init];
    if(copy)
    {
        NSMutableArray *CopyArray = [NSMutableArray array];
        for(GraphCell *cell in _graphArray)
        {
            GraphCell *copyGCell = [cell copyWithZone:zone];
            [CopyArray addObject:copyGCell];
        }
        [copy setGraphArray:CopyArray];
        [copy setSize:[self.size copyWithZone:zone]];
    }
    return copy;
}
@end
