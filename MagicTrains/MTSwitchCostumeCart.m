//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTSwitchCostumeCart.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTDebugLabel.h"
#import "MTStorage.h"
#import "MTSwitchCostumeCartOptions.h"
#import "MTGlobalVarForSetNode.h"

@implementation MTSwitchCostumeCart

static NSString* myType = @"MTSwitchCostumeCart";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.options = [[MTSwitchCostumeCartOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"switchCostume.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTSwitchCostumeCart alloc] initWithSubTrain:train];
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
     
    NSMutableArray *myVariablesForSet = self.options.getSelectVariable;
    
    int wylos = 1;
    
    for(int i = 0; i < myVariablesForSet.count; i++)
    {
        if (((MTGlobalVarForSetNode *)myVariablesForSet[i]).checked == YES)
        {
            wylos=i+1;
            if (arc4random()%10>5){
                break;
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    NSString *selectedGhostVariant  = [NSString stringWithFormat:@"D%d_C%d.png",wylos,1];
    NSString *selectedGhostCat  = [NSString stringWithFormat:@"D%d",wylos];
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
    [self.options showOptions];
}

-(void) hideOptions
{
    [self.options hideOptions];
}


@end
