//
//  ScoreEntity.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "ScoreEntity.h"

@implementation ScoreEntity
-(id)init
{
    self = [super init];
    if(self)
    {
        self.score = 0;
        self.numberOfConsecutiveRowCollection = 0;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.score = ((NSNumber*)[aDecoder decodeObjectForKey:@"scoreInt"]).intValue;
        self.numberOfConsecutiveRowCollection = ((NSNumber*)[aDecoder decodeObjectForKey:@"numberOfConsecutiveRowCollection"]).intValue;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.score] forKey:@"scoreInt"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.numberOfConsecutiveRowCollection] forKey:@"numberOfConsecutiveRowCollection"];
}
-(void)ReportScoreWithNumberOfDetectedCells:(int)numberOfDetectedCells
{
    _score += 2 * numberOfDetectedCells;
    
    if(numberOfDetectedCells == 0)
    {
        _numberOfConsecutiveRowCollection = 0;
        
    }else
    {
        _score += 3 * _numberOfConsecutiveRowCollection ;
        _numberOfConsecutiveRowCollection++;
    }
    
    
}
-(void)ResetScore
{
    _numberOfConsecutiveRowCollection = 0;
    _score = 0;
}
-(id)copyWithZone:(NSZone *)zone
{
    ScoreEntity *copy = [[ScoreEntity alloc] init];
    if(copy)
    {
        [copy setScore:self.score];
        [copy setNumberOfConsecutiveRowCollection:self.numberOfConsecutiveRowCollection];

    }
    return copy;
}
@end
