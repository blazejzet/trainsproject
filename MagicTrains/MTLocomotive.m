//
//  MTLocomotive.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTLocomotive.h"
#import "MTSubTrain.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTStorage.h"
@implementation MTLocomotive

static NSString* myType = @"MTStartLocomotive";

-(id) init
{
    if (self = [super init])
    {
        self.isInstantCart = true;
    }
    return self;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}

-(NSString *)getMyType
{
    return myType;
}

-(NSString*)getImageName
{
    return @"locomotiveStart.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTLocomotive alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
///-----------------------------------------------------
///    Serializacja
///-----------------------------------------------------
/*-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    return self;
}*/

@end
