//
//  PersistentStore.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/9/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEntity.h"
#define LAST_GAME_KEY @"lastGame"
@interface PersistentStore : NSObject
+(void)persistGame:(GameEntity*)game;
+(GameEntity*)getLastGame;
@end
