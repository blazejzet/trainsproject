//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTShowGlobalVar.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTDebugLabel.h"
#import "MTStorage.h"
#import "MTShowGlobalVarOptions.h"
#import "MTGlobalVarForSetNode.h"

@implementation MTShowGlobalVar

static NSString* myType = @"MTShowGlobalVar";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.options = [[MTShowGlobalVarOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"showVariables.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTShowGlobalVar alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(int)getCategory
{
    return MTCategoryControl;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
     
    NSMutableArray *myVariablesForSet = self.options.getSelectVariable;
        
    for(int i = 0; i < myVariablesForSet.count; i++)
    {
        if (((MTGlobalVarForSetNode *)myVariablesForSet[i]).checked == YES)
        {
            switch (((MTGlobalVarForSetNode *)myVariablesForSet[i]).numberGlobalVariable)
            {
                case 1:
                    [(MTSceneAreaNode*) scene addGlobalVar1];
                    break;
                case 2:
                    [(MTSceneAreaNode*) scene addGlobalVar2];
                    break;
                case 3:
                    [(MTSceneAreaNode*) scene addGlobalVar3];
                    break;
                case 4:
                    [(MTSceneAreaNode*) scene addGlobalVar4];
                    break;
            }
        }
    }
    
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
