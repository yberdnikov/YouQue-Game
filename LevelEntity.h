//
//  LevelEntity.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 11/6/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelEntity : NSObject
@property(nonatomic,assign)int LevelIndex;
@property(nonatomic,assign)int MaxScore;
@property(nonatomic,assign)int MinScore;
@property(nonatomic,assign)int numberOfAddedCells;
@end
