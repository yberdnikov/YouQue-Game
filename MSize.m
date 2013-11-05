//
//  MSize.m
//  DavinciCode
//
//  Created by Mohammed Eldehairy on 12/28/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "MSize.h"

@implementation MSize
-(void)dealloc
{
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.width = ((NSNumber*)[aDecoder decodeObjectForKey:@"width"]).intValue;
        self.height = ((NSNumber*)[aDecoder decodeObjectForKey:@"height"]).intValue;
        self.RightPatternNo = ((NSNumber*)[aDecoder decodeObjectForKey:@"RightPatternNo"]).intValue;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.width] forKey:@"width"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.height] forKey:@"height"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.RightPatternNo] forKey:@"RightPatternNo"];
}
-(id)copyWithZone:(NSZone *)zone
{
    MSize *copy = [[MSize alloc] init];
    if(copy)
    {
        copy.width = self.width;
        [copy setHeight:self.height];
    }
    return copy;
}
@end
