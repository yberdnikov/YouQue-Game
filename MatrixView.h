//
//  MatrixView.h
//  DavinciCode
//
//  Created by Mohammed Eldehairy on 12/28/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSize.h"
#import "CellView.h"
#import <QuartzCore/QuartzCore.h>
#import "FastestPathFinder.h"
#import "Graph.h"
#import "ConnectedCellsDetector.h"
#import "RandomUnOccupiedCellsGenerator.h"
#import <GameKit/GameKit.h>
#import "GameEntity.h"
#import "PersistentStore.h"
#import "ConnectedCellRowsDetector.h"
#import "SIAlertView.h"
#import "TSMessage.h"
#import "UndoManager.h"
#define NUMBER_OF_ADDED_CELLS 3
@protocol MatrixViewDelegate;
typedef void (^CompletionBlock)(NSArray* detectedCells);
typedef void (^AnimationCompletionBlock)();
typedef void(^UndoBlock)(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex);
@interface MatrixView : UIView<CellViewDelegate,UIAlertViewDelegate>
{
    
    UIImageView *BackView;
    
    UndoBlock undoBlock;
    
    BOOL IsGameResumed;
    
    
    UndoManager *_UndoManager;
    GameEntity *currentGame;
}
//UI Controls
@property(nonatomic,retain)UIButton *UndoBtn;
//@property(nonatomic,retain)CellView *FirstNextCell;
//@property(nonatomic,retain)CellView *SecondNextCell;
//@property(nonatomic,retain)CellView *thirdNextCell;
//@property(nonatomic,retain)UIButton *CancelBtn;
//@property(nonatomic,retain)UIButton *OKBtn;
@property(nonatomic,retain)UILabel *ScoreBoard;


//Status Variables
@property(nonatomic,assign)id<MatrixViewDelegate> delegate;
@property(nonatomic,retain)NSMutableArray *SelectedPath;
@property(nonatomic,retain) NSNumber *startCellIndex;
@property(nonatomic,retain) NSNumber *endCellIndex;

-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed;

-(void)ReloadNewGame;
-(void)ReloadGame:(GameEntity*)game;

-(void)saveGame;


-(void)undoLastMove;
-(void)ResetUndo;
@end
@protocol MatrixViewDelegate <NSObject>

-(void)MatrixViewQuit:(MatrixView*)matrixView;
-(void)AddNextCellsWithGraphCells:(NSArray*)GCells;
-(void)setProgress:(CGFloat)progress withLevelNumber:(int)levelNo;
@end