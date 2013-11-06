//
//  MatrixView.m
//  DavinciCode
//
//  Created by Mohammed Eldehairy on 12/28/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "MatrixView.h"

@implementation MatrixView
-(id)initWithFrame:(CGRect)frame
{
   /* self.size = [[MSize alloc] init] ;
    self.size.width = 7;
    self.size.height = 7;
    
    Graph *graph = [[Graph alloc] initWithSize:self.size];
    GameEntity *game = [[GameEntity alloc] init];
    game.graph = graph;
    game.score = 0;*/
    return [self initWithFrame:frame withGame:nil gameReumed:NO];
}
-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _UndoManager = [[UndoManager alloc] init];
        // Initialization View Local Variables And Load Cells
        self.backgroundColor = [UIColor colorWithRed:(57.0f/255.0f) green:(57.0f/255.0f) blue:(57.0f/255.0f) alpha:1.0];
        
        self.layer.cornerRadius = 10.0;
        
        IsGameResumed = resumed;
        if(Game)
        {
            currentGame = Game;
            
        }else
        {
            MSize *size = [[MSize alloc] init] ;
            size.width = 7;
            size.height = 7;
            Graph *graph = [[Graph alloc] initWithSize:size];
            ScoreEntity *Score = [[ScoreEntity alloc] init];
            
            currentGame = [[GameEntity alloc] init];
            
            currentGame.graph = graph;
            currentGame.score = Score;
            currentGame.nextCellsToAdd = [NSMutableArray array];
        }
        
        levelProvider = [[LevelProvider alloc] initWithNumberOfLevels:3];
        levelProvider.delegate = self;
        
        self.SelectedPath = [NSMutableArray array];
        
        
        self.clipsToBounds = NO;
        
        
        
        
        
        
    }
    return self;
}
-(void)levelProvider:(LevelProvider *)lvlProvider LevelChanged:(LevelEntity *)newLevel
{
    if(newLevel == [lvlProvider GetCurrentLevel])
    {
        return;
    }
    
    
    for(int i=0 ;i<newLevel.numberOfAddedCells;i++)
    {
        if(i>=currentGame.nextCellsToAdd.count)
        {
            GraphCell *Gcell = [[GraphCell alloc] init];
            Gcell.color = [self getRandomColor];
            [currentGame.nextCellsToAdd addObject:Gcell];
        }
    }
    
    [self AddNextCellsToSuperView];
    
    
}
-(void)saveGame
{
    [self PersistGameToPermenantStore];
    [self SaveGameToUndoManager];
    
    
}
-(void)SaveGameToUndoManager
{
    
    [_UndoManager EnqueueGameInUndoList:currentGame];
    if([_UndoManager CanUndo])
    {
        _UndoBtn.enabled = YES;
    }
}
-(void)PersistGameToPermenantStore
{
    
    [PersistentStore persistGame:currentGame];
}
-(void)undoLastMove
{
    GameEntity *UndoneGame = [_UndoManager UndoLastMove];
    if(UndoneGame)
    {
        [self ReloadGame:UndoneGame];
        [self PersistGameToPermenantStore];
        _UndoBtn.enabled = NO;
    }
}
-(void)ResetUndo
{
   if(_UndoManager)
   {
       [_UndoManager ResetManager];
       _UndoBtn.enabled = NO;
   }
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(newSuperview)
    {
        if(IsGameResumed)
        {
            [self ReloadGame:currentGame];
        }else
        {
            [self ReloadNewGame];
        }
        
    }
}

-(void)ReloadNewGame
{
    [levelProvider ResetLevel];
    [_UndoManager ResetManager];
    _UndoBtn.enabled = NO;
    [currentGame.score ResetScore];
    [currentGame.graph ResetGraph];
    [self UpdateScore];
    [self ReloadWithSize:currentGame.graph.size gameResumed:NO];
}
-(void)ReloadGame:(GameEntity*)game
{
    currentGame = game;
    
    [self UpdateScore];
    
    [self ReloadWithSize:currentGame.graph.size gameResumed:YES];
}
//**********************MATRIX RELOAD WITH CELLS ***************************************************

-(void)ReloadWithSize:(MSize*)size gameResumed:(BOOL)resumed
{
    
    NSArray *subviews = [self subviews];
    for(UIView *subview in subviews)
    {
        if(subview.tag>=1000)
            [subview removeFromSuperview];
    }
    
    
    self.frame = CGRectMake(0, 0, (CELL_SIZE*size.width)+20, (CELL_SIZE*size.height)+20);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.center = CGPointMake(160, 210);
    }else
    {
        self.center = CGPointMake(350, 250);
    }
    
    
    
    [self LoadWithCellsGameResumed:resumed];
    
}

-(void)LoadWithCellsGameResumed:(BOOL)Resumed
{
    
    int TotalCellsCount = currentGame.graph.size.width*currentGame.graph.size.height;

    
    
    
    CGFloat AnimationDelay =0.0;
    int CurrentX = CELL_SIZE;
    CurrentX *= -1;
    CurrentX += 10;
    int CurrentY = 10;
    for(int i =0 ;i<TotalCellsCount;i++)
    {
        if((i/currentGame.graph.size.height)*currentGame.graph.size.height != i)
        {
            //if did not reach full height
            //increase Y
            
            
            CurrentY+=CELL_SIZE;
            
            
        }else
        {
            //if reached full height
            //Reset Y and increase X
            
            
            CurrentY = 10;
            CurrentX+=CELL_SIZE;
        }
        
        
        
        
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(CurrentX, CurrentY, 0.0, 0.0)];
        cell.tag = i+1000;
        cell.delegate = self;
        
        GraphCell *graphCell = [currentGame.graph getGraphCellWithIndex:i];
        [cell SetStatusWithGraphCell:graphCell Animatation:CellAnimationTypeNone];
        
        
        cell.SetTouchable = NO;
        [self addSubview:cell];
        
        
        
        AnimationDelay += 0.1;

        
        
        
    }
    
    
    
    
    
    
    if(!Resumed)
    {
        [self GenerateRandomCellsAndAddToSuperView:NO];
        [self performSelector:@selector(AddNewCells) withObject:nil afterDelay:0.5];
    }else
    {
        [self AddNextCellsToSuperView];
    }
    
    
    
    
    
    
    
    
    
}
- (void) showBannerWithMessage:(NSString*)msg withTitle:(NSString*)title
{
 
    [TSMessage showNotificationWithTitle:title
                                subtitle:msg
                                    type:TSMessageNotificationTypeError];
}
-(GraphCellStatus)getRandomColor
{
    int randomIndex = arc4random_uniform(5);
    
    if(randomIndex==0)
    {
        return blue;
        
    }else if (randomIndex==1)
    {
        return green;
        
    }else if (randomIndex==2)
    {
        return red;
        
    }else if (randomIndex==3)
    {
        return yellow;
        
    }else //if (randomIndex==4)
    {
        return orange;
    }
}
-(void)GenerateRandomCellsAndAddToSuperView:(BOOL)addToSuperView
{
    
    NSMutableArray *addedCells = [NSMutableArray array];
    for(int i=0 ;i<[levelProvider GetCurrentLevel].numberOfAddedCells;i++)
    {
        GraphCell *CopyGCell = [[GraphCell alloc] init];
        [addedCells addObject:CopyGCell];
        
       /* int randomIndex = arc4random_uniform(5);
        
        if(randomIndex==0)
        {
            CopyGCell.color = blue;
            
        }else if (randomIndex==1)
        {
            CopyGCell.color = green;
            
        }else if (randomIndex==2)
        {
            CopyGCell.color = red;
            
        }else if (randomIndex==3)
        {
            CopyGCell.color = yellow;
            
        }else if (randomIndex==4)
        {
            CopyGCell.color = orange;
        }*/
        CopyGCell.color = [self getRandomColor];
        
        
    }
    
    currentGame.nextCellsToAdd = addedCells;
    if(addToSuperView)
        [self AddNextCellsToSuperView];
}
-(void)AddNextCellsToSuperView
{
    if([_delegate respondsToSelector:@selector(AddNextCellsWithGraphCells:)])
    {
        [_delegate AddNextCellsWithGraphCells:currentGame.nextCellsToAdd];
    }
    
}


-(void)AddNewCells
{
    
    NSArray *unoccupiedCells = [currentGame.graph getUnOccupiedCells];
    
   
    
    if(unoccupiedCells.count<[levelProvider GetCurrentLevel].numberOfAddedCells)
    {
        [self GameOver];
        return;
    }
    
    
    [RandomUnOccupiedCellsGenerator GenerateRandomUnOccupiedCellsIndexes:[levelProvider GetCurrentLevel].numberOfAddedCells WithUnOccupiedCells:unoccupiedCells withCompletionBlock:^(NSArray* result){
    
    
        NSMutableArray *AddedCells = [NSMutableArray array];
        for(int i=0 ;i<[levelProvider GetCurrentLevel].numberOfAddedCells;i++)
        {
            GraphCell *AddedGCell = [currentGame.nextCellsToAdd objectAtIndex:i];
            GraphCell *LocalGCell = [currentGame.graph getGraphCellWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            LocalGCell.color = AddedGCell.color;
            
            CellView *LocalCell = [self getCellViewWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            [AddedCells addObject:LocalGCell];
            [LocalCell SetStatusWithGraphCell:LocalGCell Animatation:CellAnimationTypeAdded withDelay:i withCompletionBlock:^(BOOL finished){
            
                int numberOfAddedCells = [levelProvider GetCurrentLevel].numberOfAddedCells ;
                if(i==numberOfAddedCells-1)
                {
                    
                    
                    
                    [self DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:^(NSArray* detectedCells){
                        
                        
                        [self setUserInteractionEnabled:YES];
                        
                        NSArray *unoccupiedCells = [currentGame.graph getUnOccupiedCells];
                        
                        if(unoccupiedCells.count==0)
                        {
                            [self GameOver];
                            
                        }else
                        {
                            [self GenerateRandomCellsAndAddToSuperView:YES];
                            [self saveGame];
                        }
                        
                    } withVerticesArray:AddedCells];
                    
                    
                    
                    
                }
            
            }];
        }
        
       
        
    
    
    }];
    
    
    
    
    
    
    
}
-(void)SetScoreInScoreBoard:(int)score
{
    _ScoreBoard.text = [NSString stringWithFormat:@"%d",score];
}
-(void)ReportScoreToGameCenter
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"YouQueMainLeaderboard"];
    scoreReporter.value = currentGame.score.score;
    scoreReporter.context = 0;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
    }];

}

//******************HANDLE TOUCH EVENT************************************************************
-(void)CellViewTouched:(CellView *)touchedCell
{
    if(touchedCell.IsOccupied==YES)
    {
        if(_startCellIndex)
        {
            //deselect prevoiusly selected Start Cell View
            
            GraphCell *LastSelectedStartGcell = [currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
            LastSelectedStartGcell.temporarilyUnoccupied = NO;
            
            CellView *LastSelectedStartCellView = [self getCellViewWithIndex:_startCellIndex.intValue];
            [LastSelectedStartCellView cellUnTouched];
            
        }
        
        if(_endCellIndex)
        {
            //deselect prevoiusly selected End Cell View
            
            CellView *LastSelectedEndCellView = [self getCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndCellView cellUnTouched];
            [self UnDrawPathWithPath:self.SelectedPath];
            
        }
        [_SelectedPath removeAllObjects];
        
        GraphCell *LastSelectedGcell = [currentGame.graph getGraphCellWithIndex:touchedCell.tag-1000];
        [touchedCell cellTouchedWithStatus:LastSelectedGcell.color];
        self.startCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        
        LastSelectedGcell.temporarilyUnoccupied = YES;
        
        
    }else
    {
        
        if(!_startCellIndex)
        {
            return;
            
        }
        if(_endCellIndex)
        {
            //deselect prevoiusly selected End Cell View
            
            CellView *LastSelectedEndCellView = [self getCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndCellView cellUnTouched];
            [self UnDrawPathWithPath:self.SelectedPath];
            
        }
        
        
        
        self.endCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        [self.SelectedPath removeAllObjects];
        [self FindFastesPathWithCompletionBlock:^(NSArray *path){
        
        
            [self.SelectedPath addObjectsFromArray:path];
            
            if(self.SelectedPath.count==0)
            {
                [self showBannerWithMessage:@"Can't go there !" withTitle:@"Sorry"];
            }
           // _OKBtn.enabled = self.SelectedPath.count>0;
            [self OKAction:nil];
        
        }];
        
        
    }
}
-(void)UnDrawPathWithPath:(NSArray*)path
{
    for(int i =1;i<path.count;i++)
    {
        NSNumber *CellIndex = [path objectAtIndex:i];
        CellView *cell = [self getCellViewWithIndex:CellIndex.intValue];
        
        [cell RemovePathTraceImage];
    }
    
}
-(void)DrawPathWithPath:(NSArray*)path
{
    GraphCell *fromGCell = [currentGame.graph getGraphCellWithIndex:((NSNumber*)[path objectAtIndex:0]).intValue];
    for(int i =1;i<path.count;i++)
    {
        NSNumber *CellIndex = [path objectAtIndex:i];
        CellView *cell = [self getCellViewWithIndex:CellIndex.intValue];
        
        [cell setPathtTraceImageWithStatus:fromGCell.color];
    }
    
}
-(void)FindFastesPathWithCompletionBlock:(FastestPathFinderBlock)block
{
    [FastestPathFinder findFastestPathWithOccupiedCells:[currentGame.graph getOcuupiedCells] withSize:currentGame.graph.size withStart:self.startCellIndex WithEnd:self.endCellIndex WithCompletionBlock:block];
}
-(void)OKAction:(UIButton *)sender
{
    if(self.SelectedPath.count==0 || !self.SelectedPath)
    {
        [self setUserInteractionEnabled:YES];
        return;
    }
    [self setUserInteractionEnabled:NO];
        
        
    CellView *fromCell = [self getCellViewWithIndex:_startCellIndex.intValue];
    GraphCell *fromGCell = [currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
    fromGCell.temporarilyUnoccupied = NO;
    CellView *Tocell = [self getCellViewWithIndex:_endCellIndex.intValue];
    
    [self MoveOccupiedCellFromIndex:self.startCellIndex.intValue toIndex:self.endCellIndex.intValue WithPath:self.SelectedPath];
    
    CompletionBlock block = ^(NSArray *detectedCells){
        
        
        if(detectedCells.count==0)
        {
            
            [self AddNewCells];
        }else
        {
            
            [self setUserInteractionEnabled:YES];
            
            [self saveGame];
        }
        
        
    };
    
    
        
    

        
    [self DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:block withVerticesArray:[NSArray arrayWithObject:[currentGame.graph getGraphCellWithIndex:_endCellIndex.intValue]]];
    

    
    _endCellIndex = nil;
    [Tocell cellUnTouched];
    _startCellIndex = nil;
    
    [fromCell cellUnTouched];
    //_OKBtn.enabled = NO;
    //_CancelBtn.enabled = NO;
    
}
-(void)CancelAction:(UIButton *)sender
{
    
}
-(void)MoveOccupiedCellFromIndex:(int)Fromindex toIndex:(int)toIndex WithPath:(NSArray*)path
{
    
    CellView *fromCell = [self getCellViewWithIndex:Fromindex];
    CellView *toCell = [self getCellViewWithIndex:toIndex];
    
    
    GraphCell *FromGCell = [currentGame.graph getGraphCellWithIndex:Fromindex];
    FromGCell.temporarilyUnoccupied = NO;
    GraphCell *toGCell = [currentGame.graph getGraphCellWithIndex:toIndex];
    
    if(FromGCell.color!=unOccupied && toGCell.color==unOccupied)
    {
        [currentGame.graph ExchangeCellAtIndex:Fromindex WithCellAtIndex:toIndex];
    }
    
    UIColor *traceColor =nil;
    switch (FromGCell.color) {
        case red:
            traceColor = [UIColor redColor];
            break;
        case green:
            traceColor = [UIColor greenColor];
            break;
        case blue:
            traceColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }

    [fromCell SetStatusWithGraphCell:toGCell Animatation:CellAnimationTypeNone];
    
    [toCell SetStatusWithGraphCell:FromGCell Animatation:CellAnimationTypeNone];
    
    
    
    
    
}
-(void)GameOver
{
    [PersistentStore persistGame:nil];
    [self ReportScoreToGameCenter];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Game Over" andMessage:@"nice job !"];
    
    [alertView addButtonWithTitle:@"Quit"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              if([_delegate respondsToSelector:@selector(MatrixViewQuit:)])
                              {
                                  [_delegate MatrixViewQuit:self];
                              }
                          }];
    
    [alertView addButtonWithTitle:@"New Game"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                              [self ReloadNewGame];
                              
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    [alertView performSelector:@selector(show) withObject:nil afterDelay:0.5];
    
}
-(void)DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:(CompletionBlock) block withVerticesArray:(NSArray*)vertices
{
    
    // get detected rows from the ConnectedCellsDetector helper class
     [ConnectedCellRowsDetector getConnectedCellsWithGraph:currentGame.graph withVertices:vertices withCompletionBlock:^(NSArray *result){
    
         // iterate on detected cells and remove them
         int numberOfCellsDetected = result.count;
         [self RemoveCells:result];
         
         
         //Update Score
         [currentGame.score ReportScoreWithNumberOfDetectedCells:numberOfCellsDetected];
         
         [self UpdateScore];
         
         //call completion block
         block(result);
    
    }];
    
    
    
    
}
-(void)RemoveCells:(NSArray*)cells
{
    for(GraphCell *GCell in cells)
    {
        GCell.color = unOccupied;
        int index = [currentGame.graph getIndexOfGraphCell:GCell];
        CellView *cellView = [self getCellViewWithIndex:index];
        [cellView SetStatusWithGraphCell:GCell Animatation:CellAnimationTypeRemoval];
    }
}
-(void)SaveUndoAction
{
   /* undoBlock = ^(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex){
        
        //Remove Added Cells
        for(NSNumber *addedCell in lastAddedCells)
        {
            GraphCell *GCell = [self.graph getGraphCellWithIndex:addedCell.intValue];
            
            CellView *LocalCell = [self getCellViewWithIndex:addedCell.intValue];
            
            GCell.color = unOccupied;
            GCell.temporarilyUnoccupied = NO;
            
            [LocalCell SetStatusWithGraphCell:GCell];
        }
        
        // Add Removed Cells
        for(GraphCell *removedCell in lastRemovedCells)
        {
            [self.graph UpdateGraphCellAtIndex:removedCell.index WithCell:removedCell];
            [[self getCellViewWithIndex:removedCell.index] SetStatusWithGraphCell:removedCell];
        }
        [FastestPathFinder findFastestPathWithOccupiedCells:[self.graph getOcuupiedCells] withSize:self.size withStart:lastEndCellIndex WithEnd:lastStartCellIndex WithCompletionBlock:^(NSArray *path){
            
            [self MoveOccupiedCellFromIndex:lastEndCellIndex.intValue toIndex:lastStartCellIndex.intValue WithPath:path];
            
        }];
        
    };*/
}
-(void)UpdateScore
{
    

    [levelProvider ReportScore:currentGame.score.score];
    [self SetScoreInScoreBoard:currentGame.score.score];
    if([_delegate respondsToSelector:@selector(setProgress:withLevelNumber:)])
    {
        CGFloat Mod = currentGame.score.score % (int)(LEVEL_RANGE);
        CGFloat progress = (CGFloat)(Mod/LEVEL_RANGE);
        if([levelProvider isFinalLevel])
        {
            progress = 1.0f;
        }
        [_delegate setProgress:progress withLevelNumber:floorf(currentGame.score.score/LEVEL_RANGE)+1];
    }
}
-(CellView*)getCellViewWithIndex:(int)index
{
    return ((CellView*)[self viewWithTag:index+1000]);
}
//*********************CELL PATH ANIMATION ********************************************************
-(void)AnimatePath:(NSArray*)path withColor:(UIColor*)color withCompletionBlock:(AnimationCompletionBlock)block
{
    for (int i =0;i<path.count;i++) {
        CellView *PreCell = nil;
        if (i>0) {
            PreCell = (CellView*)[self viewWithTag:((NSNumber*)[path objectAtIndex:i-1]).intValue+1000];
        }
        
        CellView *cell = (CellView*)[self viewWithTag:((NSNumber*)[path objectAtIndex:i]).intValue+1000];
        NSArray *cells = [NSArray arrayWithObjects:cell,[NSNumber numberWithBool:i==path.count-1],PreCell, nil];
        
        NSArray *objectArr = [NSArray arrayWithObjects:cells,color, nil];
        [self performSelector:@selector(CellBackGroundToYellow:) withObject:objectArr afterDelay:i*0.06];
       
        
    }
}
-(void)CellBackGroundToYellow:(NSArray*)objectArray
{
    NSArray *cells = [objectArray objectAtIndex:0];
    
    UIColor *color = [objectArray objectAtIndex:1];
    
    CellView *currentCell = [cells objectAtIndex:0];
    if(cells.count==3)
    {
        CellView *PreCell = [cells objectAtIndex:2];
        [self performSelector:@selector(SetBackToWhite:) withObject:PreCell afterDelay:0.06];
    }
    if(!((NSNumber*)[cells objectAtIndex:1]).boolValue)
        currentCell.backgroundColor = color;
    
}
-(void)SetBackToWhite:(CellView*)preCell
{
    preCell.backgroundColor = [UIColor whiteColor];
}





-(void)dealloc
{
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 5.0f;
    
    
    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGRect innerRect = CGRectInset(bounds, radius, radius);
    CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, bounds.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y + bounds.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x, innerRect.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius);
    CGPathCloseSubpath(visiblePath);
    
    // Fill this path
    UIColor *aColor = [UIColor colorWithRed:(0.00f) green:(144.0f/255.0f) blue:(250.0f/255.0f) alpha:1.0];
    [aColor setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(bounds, -42, -42));
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    
    // Now setup the shadow properties on the context
    aColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.5f, 1.5f), 10.0f, [aColor CGColor]);
    //cgcontextsets
    
    // Now fill the rectangle, so the shadow gets drawn
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    // Release the paths
    CGPathRelease(path);
    CGPathRelease(visiblePath);
    
}*/

@end
