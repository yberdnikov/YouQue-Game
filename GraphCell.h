//
//  GraphCell.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/21/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSize.h"
typedef enum {
    red,
    blue,
    green,
    yellow,
    orange,
    unOccupied
} GraphCellStatus;
@interface GraphCell : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign)GraphCellStatus color;
@property(nonatomic,assign)int x;
@property(nonatomic,assign)int y;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL temporarilyUnoccupied;
-(id)initWithColor:(GraphCellStatus)color;
-(UIColor*)GetUIColor;
-(CGPoint)getPointWithSize:(MSize*)size;
-(void)copySelftoGCell:(GraphCell*)CopyGCell;
@end
