//
//  GraphCell.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/21/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "GraphCell.h"

@implementation GraphCell
-(id)initWithColor:(GraphCellStatus)color
{
    self = [super init];
    if(self)
    {
        self.color = color;
        self.temporarilyUnoccupied = NO;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.color = ((NSNumber*)[aDecoder decodeObjectForKey:@"color"]).intValue;
        self.x = ((NSNumber*)[aDecoder decodeObjectForKey:@"x"]).intValue;
        self.y = ((NSNumber*)[aDecoder decodeObjectForKey:@"y"]).intValue;
        self.index = ((NSNumber*)[aDecoder decodeObjectForKey:@"index"]).intValue;
        self.temporarilyUnoccupied = ((NSNumber*)[aDecoder decodeObjectForKey:@"temporarilyUnoccupied"]).intValue;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.color] forKey:@"color"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.y] forKey:@"y"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.index] forKey:@"index"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.temporarilyUnoccupied] forKey:@"temporarilyUnoccupied"];
}
-(UIColor*)GetUIColor
{
    if(self.color==unOccupied)
    {
        return [UIColor whiteColor];
    }else if (_color==red)
    {
        return [UIColor redColor];
    }else if (_color==blue)
    {
        return [UIColor blueColor];
    }else
    {
        return [UIColor greenColor];
    }
}
-(void)dealloc
{
    
    
}
-(CGPoint)getPointWithSize:(MSize*)size
{
    CGPoint point = CGPointMake(_index/(size.height), _index%(size.height));
    return point;
}
-(void)copySelftoGCell:(GraphCell*)CopyGCell
{
    CopyGCell.color = self.color;
    CopyGCell.temporarilyUnoccupied = self.temporarilyUnoccupied;
    CopyGCell.index = self.index;
    CopyGCell.x = self.x;
    CopyGCell.y = self.y;
    
}
-(id)copyWithZone:(NSZone *)zone
{
    GraphCell *copy = [[GraphCell alloc] init];
    if(copy)
    {
        [copy setColor:self.color];
        [copy setX:self.x];
        [copy setY:self.y];
        [copy setIndex:self.index];
        [copy setTemporarilyUnoccupied:self.temporarilyUnoccupied];
    }
    return copy;
}
@end
