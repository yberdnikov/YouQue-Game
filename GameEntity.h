//
//  GameEntity.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/9/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#import "ScoreEntity.h"
@interface GameEntity : NSObject<NSCoding,NSCopying>
@property(nonatomic,retain)Graph *graph;
@property(nonatomic,retain)ScoreEntity *score;
@property(nonatomic,retain)NSArray *nextCellsToAdd;
@end
