//
//  UndoManager.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/24/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEntity.h"
@interface UndoManager : NSObject
{
    GameEntity *previousGame;
    NSMutableArray *UndoGamesList;
    //NSMutableArray *RedoGamesList;
}
-(void)EnqueueGameInUndoList:(GameEntity*)game;
-(GameEntity*)UndoLastMove;
/*-(GameEntity*)RedoLastMove;
-(BOOL)CanRedo;*/
-(BOOL)CanUndo;
-(void)ResetManager;
@end
