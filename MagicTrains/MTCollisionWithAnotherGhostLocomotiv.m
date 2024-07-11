//
//  MTCollisionWithAnotherGhostLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 15.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTStorage.h"

#import "MTCollisionWithAnotherGhostLocomotiv.h"
#import "MTCollisionWithAnotherGhostLocomotivOptions.h"

@implementation MTCollisionWithAnotherGhostLocomotiv
static NSString* myType = @"MTCollisionWithAnotherGhostLocomotiv";

-(id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.options = [[MTCollisionWithAnotherGhostLocomotivOptions alloc] initWithLocomotiv:self];
        self.optionsOpen = false;
    }
    return self;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    
#if DEBUG_NSLog
    ////NSLog(@"lokomotywa zderzenia duszka z innym duszkiem\n");
#endif
    
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveCollisionGhost.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTCollisionWithAnotherGhostLocomotiv alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
-(void)showOptions
{
    [self.options showOptions];
}
-(void) hideOptions
{
    [self.options hideOptions];
}

-(void) assingSelectedGhost:(MTGhost *)selectedGhost
{
    self.selectedGhost = selectedGhost;
}

///-----------------------------------------------------
///    Serializacja
///-----------------------------------------------------
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeInteger:[self selectedGhost].myNumber forKey:@"nrOfSelectedGhost"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    int nr = [decoder decodeIntegerForKey:@"nrOfSelectedGhost"];
    [self setSelectedGhost: [[MTStorage getInstance]getGhostAt:nr]];
    [[self options] setMyLocomotiv:self];
    return self;
}
@end
