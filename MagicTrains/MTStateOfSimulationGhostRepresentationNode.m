//
//  MTStateOfSimulationGhostRepresentationNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStateOfSimulationGhostRepresentationNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostsBarNode.h"
#import "MTTrashNode.h"
#import "MTGhost.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTStorage.h"

@implementation MTStateOfSimulationGhostRepresentationNode

-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt
{

    /*
     if(position.x<-1024/2+self.size.width/2)position.x=-1024/2+self.size.width/2;
     if(position.x>1024/2-self.size.width/2)position.x=1024/2-self.size.width/2;
     if(position.y<-768/2+self.size.width/2)position.y=-768/2+self.size.width/2;
     if(position.y>768/2-self.size.width/2)position.y=768/2-self.size.width/2;
     */
    ////NSLog(@">>>>>>Pos  x: %f y %f",position.x,position.y);
//    rep.position = pt;
    [rep runAction:[SKAction moveTo:pt duration:0.0]];
}

-(void)setHPOfRep:(MTGhostRepresentationNode *)rep WithUint:(uint)hp
{
    rep.hp = hp;
}

-(void)setRotationOfRep:(MTGhostRepresentationNode *)rep WithAngle:(CGFloat)a
{
    //NSLog(@"Moja rotacja: %f",a);
    rep.zRotation = a;
}

-(void)setScaleOfRep:(MTGhostRepresentationNode *)rep WithScale:(CGFloat)a
{
    rep.xScale = a;
    rep.yScale = a;
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *) v
     WithGhostRep:(MTGhostRepresentationNode *)rep
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    if(g.state == UIGestureRecognizerStateBegan)
    {
        if ([rep getSelectedRepresentationNode] != rep)
        {
            if(rep.moveXInSimulation || rep.moveYInSimulation)
                [rep makeMeSelected];
        }
    }
    
    [self moveRep:g :v WithGhostRep:rep];
        
    if(g.state == UIGestureRecognizerStateEnded)
    {
        if((rep.moveXInSimulation || rep.moveYInSimulation) && ![MTStorage getInstance].DebugEnabled )
            [rep makeMeUnselected];
    }
}

- (void)moveRep:(UIGestureRecognizer *)g :(UIView *)v
   WithGhostRep:(MTGhostRepresentationNode *)rep
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    //float width  = (WIDTH - rep.size.width ) / 2;
    //float height = (HEIGHT - rep.size.height) / 2;
    
    //if (rep.moveXInSimulation == true)
    //{
    
    CGPoint r;
    /*r = [rep newPositionWithGesture:g inView:v inReferenceTo:scene];
    if(
       r.x < width   &&
       r.y < height  &&
       r.x > -width  &&
       r.y > -height
       )
        [rep setPos: CGPointMake(r.x, rep.position.y)];
    }
    
    if (rep.moveYInSimulation == true)
    {
        CGPoint r;
        r = [rep newPositionWithGesture:g inView:v inReferenceTo:scene];
        if(
           r.x < width   &&
           r.y < height  &&
           r.x > -width  &&
           r.y > -height
           )
            [rep setPos: CGPointMake(rep.position.x, r.y)];
    }*/
        r = [rep newPositionWithGesture:g inView:v inReferenceTo:scene];
        
        if(rep.moveYInSimulation != true){
            r.y = rep.position.y;
        }
        
        if(rep.moveXInSimulation != true){
            r.x = rep.position.x;
        }
        [rep setPos: r];
}

-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    if ([MTStorage getInstance].DebugEnabled )
    {
        if ([MTGhostRepresentationNode getSelectedRepresentationNode] != rep)
        {
            [rep makeMeSelected];
            
        } else {
            [rep makeMeUnselected];
        }
    } 
}

-(void)setGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked
{
    
}

-(void)setPhysics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{
    rep.physicsBody.pinned = !val;
    rep.physicsBody.allowsRotation = val;
}

-(void)setJoystick:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{
    rep.affectByJoystick = val;
}
-(void)setGravitationMy:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{
        rep.physicsBody.affectedByGravity=val;

}


-(void)setMasMy:(MTGhostRepresentationNode *)rep ToValue:(int)val{
    rep.massign=val;
    if (val==-1){
        rep.physicsBody.fieldBitMask=8;
    }else{
        rep.physicsBody.fieldBitMask=1;

    }
    
}

-(void)setGravitation:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{
    if(val)
        [rep startGravitating];
    else
        [rep stopGravitating];
}

-(void)setReversedGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{
    if(val)
        [rep startReverseGravitating];
    else
        [rep stopReverseGravitating];
}
-(void)setDynamics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked
{
    rep.physicsBody.dynamic = blocked;
}


@end
