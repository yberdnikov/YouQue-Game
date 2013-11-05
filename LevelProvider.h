//
//  LevelProvider.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 11/6/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelEntity.h"
#define LEVEL_RANGE 10
@protocol LevelProviderDelegate;
@interface LevelProvider : NSObject


@property(nonatomic,weak)id<LevelProviderDelegate> delegate;


-(id)initWithNumberOfLevels:(int)noOfLevels;

-(void)ReportScore:(int)score;

-(LevelEntity*)GetCurrentLevel;
-(void)ResetLevel;
@end


@protocol LevelProviderDelegate <NSObject>
-(void)levelProvider:(LevelProvider*)levelProvider LevelChanged:(LevelEntity*)newLevel;
@end