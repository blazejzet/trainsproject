//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTSwitchCostumeColorCart.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTDebugLabel.h"
#import "MTStorage.h"
#import "MTGlobalVarForSetNode.h"

@implementation MTSwitchCostumeColorCart

static NSString* myType = @"MTSwitchCostumeColorCart";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        //self.options = [[MTSwitchCostumeCartOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"switchCostumeColor.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTSwitchCostumeColorCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    NSString* current = [ghostRepNode.ghostName componentsSeparatedByString:@"_"][0];
    
    int wylos = arc4random()%9+1; //C1-C9
    
    
    NSString *selectedGhostVariant  = [NSString stringWithFormat:@"%@_C%d.png",current,wylos];
    NSString *selectedGhostCat  = [NSString stringWithFormat:@"%@",current];
    MTStorage *storage = [MTStorage getInstance];
    ////NSLog(@"ZMIANA KOSTIUMU NA %@",selectedGhostVariant);

    SKSpriteNode * CLOUD = [[SKSpriteNode alloc]initWithImageNamed:@"CLO_1.png"];
    CLOUD.size=ghostRepNode.size;
    CLOUD.xScale=1/ghostRepNode.xScale;
    CLOUD.yScale=1/ghostRepNode.yScale;
    [ghostRepNode addChild:CLOUD];
    [CLOUD runAction:[SKAction sequence:@[[SKAction animateWithTextures:@[
                                                                          [SKTexture textureWithImageNamed:@"CLO_2.png"],
                                                                          [SKTexture textureWithImageNamed:@"CLO_3.png"],
                                                                          [SKTexture textureWithImageNamed:@"CLO_1.png"],
                                                                          [SKTexture textureWithImageNamed:@"CLO_2.png"],
                                                                          [SKTexture textureWithImageNamed:@"CLO_3.png"]
                                                                          ] timePerFrame:0.03],[SKAction removeFromParent]]]];
    

    
    
    ghostRepNode.ghostName = selectedGhostVariant;
        ghostRepNode.texture= [SKTexture textureWithImageNamed:selectedGhostVariant];
    
    
    
    [ghostRepNode setupMoodVisuals:selectedGhostCat];
    ghostRepNode.moodState=1;
    [ghostRepNode setMoodState];
    

    
    
    
    
    
    
    return true;
}

-(void)showOptions
{
    //[self.options showOptions];
}

-(void) hideOptions
{
   // [self.options hideOptions];
}


@end
