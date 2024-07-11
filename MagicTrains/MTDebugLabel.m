//
//  MTDebugLabel.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 29.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTDebugLabel.h"
#import "MTGhostRepresentationNode.h"
#import "MTGlobalVar.h"
#import "MTGUI.h"

@implementation MTDebugLabel

-(id) init
{
    if (self = [super init])
    {
        self.fontSize = 14;
        self.fontColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.fontName = @"Chalkduster";
        self.verticalAlignmentMode = 1;
        self.string = nil;
        
        //self.reference = nil;
        self.zPosition = 1000;
    }
    
    return self;
}

-(id) initWithPosition: (CGPoint)position numberGlobalVar: (uint)numberGlobalVar andString: (NSString*)string
{
    if(self = [self init])
    {

        self.position = position;
        //self.reference = reference;
        self.numberGlobalVar = numberGlobalVar;
        self.string = string;
        MTGlobalVar *globalVar = [MTGlobalVar getInstance];
        double x = [globalVar getGlobalValueWithNumber:self.numberGlobalVar]-(int)[globalVar getGlobalValueWithNumber:self.numberGlobalVar];
        if(x>0){
        self.text = [NSString stringWithFormat:@"%4.2f", [globalVar getGlobalValueWithNumber:self.numberGlobalVar]];
        }else{
            self.text = [NSString stringWithFormat:@"%d", (int)[globalVar getGlobalValueWithNumber:self.numberGlobalVar]];
            
        }
        self.fontSize = 20;
        self.fontColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.fontName = @"Chalkduster";
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:FRAME_TIME*2
                                                 target:self
                                               selector:@selector(refreshTextWithReference)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    return self;
}


-(id) initXWithPosition: (CGPoint)position
{
    if(self = [self init])
    {
        self.position = position;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:FRAME_TIME*2
                                                 target:self
                                               selector:@selector(refreshTextXPosition)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    return self;
}

-(id) initYWithPosition: (CGPoint)position
{
    if(self = [self init])
    {
        self.position = position;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:FRAME_TIME*2
                                                 target:self
                                               selector:@selector(refreshTextYPosition)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    return self;
}

-(id) initHPWithPosition: (CGPoint)position
{
    if(self = [self init])
    {
        self.position = position;
        self.name = @"MTDebugLabel";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:FRAME_TIME*2
                                                 target:self
                                               selector:@selector(refreshTextHPPosition)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    return self;
}

-(id) initMASSWithPosition: (CGPoint)position
{
    if(self = [self init])
    {
        self.position = position;
        self.name = @"MTDebugLabel";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:FRAME_TIME*2
                                                      target:self
                                                    selector:@selector(refreshTextMASSPosition)
                                                    userInfo:nil
                                                     repeats:YES];
    }

    return self;
}

-(void) refreshTextWithReference
{
    MTGlobalVar *globalVar = [MTGlobalVar getInstance];
    //self.text = [NSString stringWithFormat:@"%@ %4.2f",self.string, [globalVar getGlobalValueWithNumber:self.numberGlobalVar]];
    double x = [globalVar getGlobalValueWithNumber:self.numberGlobalVar]-(int)[globalVar getGlobalValueWithNumber:self.numberGlobalVar];
    if(x>0){
        self.text = [NSString stringWithFormat:@"%4.2f", [globalVar getGlobalValueWithNumber:self.numberGlobalVar]];
    }else{
        self.text = [NSString stringWithFormat:@"%d", (int)[globalVar getGlobalValueWithNumber:self.numberGlobalVar]];
        
    }
}

-(void) refreshTextXPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"X: %4.0f", selected.position.x];
    } else self.hidden = true;
    
}

-(void) refreshTextYPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"Y: %4.0f", selected.position.y];
    } else self.hidden = true;
}

-(void) refreshTextHPPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"HP: %4.0f", selected.hp];
    } else self.hidden = true;
}

-(void) refreshTextMASSPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"MASS: %4.0f", selected.physicsBody.mass];
    } else self.hidden = true;
}

-(void) refreshTextVXPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"MASS: %4.0f", selected.physicsBody.mass];
    } else self.hidden = true;
}

-(void) refreshTextVYPosition
{
    MTGhostRepresentationNode *selected = [MTGhostRepresentationNode getSelectedRepresentationNode];
    if (selected != nil)
    {
        self.hidden = false;
        self.text = [NSString stringWithFormat:@"MASS: %4.0f", selected.physicsBody.mass];
    } else self.hidden = true;
}

-(void) stopRefreshText
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
