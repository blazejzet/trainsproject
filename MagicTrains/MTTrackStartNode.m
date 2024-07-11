//
//  MTTrainStartNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTTrackStartNode.h"
#import "MTBlockNode.h"
#import "MTGhost.h"
#import "MTGUI.h"
@implementation MTTrackStartNode

-(id)init
{
    if (self.mySubTrain == nil)
    {
        
#if DEBUG_NSLog
        ////NSLog(@"Błędna inicjalizacja Sprite'a rozpoczynającego partię kodu.");
#endif
        
        return self;
    }
    if ([self IfImMainStart])
    {
        return [self initStart];
    }
    else
    {
        return [self initCurve];
    }
}
-(bool)IfImMainStart
{
    return (self.mySubTrain == self.myTrain.mainSubTrain);
}

-(id)initStart
{
    if (self = [super initWithImageNamed:@"trackStart.png"])
    {
        self.size = CGSizeMake(TRACK_WIDTH, TRACK_HEIGHT + 52 );
        self.anchorPoint = CGPointMake(0.5, 0);
        self.name = @"MTTrackStartNode";
    }
    return self;
}
-(id)initCurve
{
    if (self = [super initWithImageNamed:@"trackCurve.png"])
    {
        self.size = CGSizeMake(TRACK_WIDTH, TRACK_HEIGHT + 52 );
        self.anchorPoint = CGPointMake(0.5, 0);
        self.name = @"MTTrackCurveNode";
    }
    return self;
}
-(void)removeMyTrain
{
    if ([self.parent.name isEqualToString:@"MTTrainNode"])
    {
        for (MTBlockNode * blockNode in [self.parent children]) {
            if ([blockNode.name isEqualToString:@"MTCodeBlockNode"])
            {
                [[[[blockNode getMySubTrain] myTrain] myGhost] removeTrain:[[blockNode getMySubTrain] myTrain]];
            }
        }
    }
}
-(void)blockDrop:(MTBlockNode*)block
{
    if (![self IfImMainStart])
    {
        [super blockDrop:block];
    }
}
@end
