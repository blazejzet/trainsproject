//
//  MTStateOfEditingGhostRepresentationNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStateOfEditingGhostRepresentationNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostsBarNode.h"
#import "MTTrashNode.h"
#import "MTGhost.h"
#import "MTGUI.h"
//#import "MTGhostRepresentationEffectNode.h"
#import "MTViewController.h"
@implementation MTStateOfEditingGhostRepresentationNode

- (void)moveRep:(UIGestureRecognizer *)g :(UIView *)v
  WithGhostRep:(MTGhostRepresentationNode *)rep
{
    float width  = (WIDTH - rep.size.width ) / 2;
    float height = (HEIGHT - rep.size.height) / 2;
    
    CGPoint r;
    r = [rep newPositionWithGesture:g inView:v inReferenceTo:rep.parent];
    if(
       r.x < width   &&
       r.y < height  &&
       r.x > -width  &&
       r.y > -height
       ){
       [rep setPos:r ];
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *) v
        WithGhostRep:(MTGhostRepresentationNode *)rep
{
    MTSceneAreaNode * sceneArea = ((MTSceneAreaNode *)[(SKNode *)rep.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]);
    MTGhostsBarNode * ghostBar = ((MTGhostsBarNode *)[(SKNode *)rep.scene.children[0] childNodeWithName:@"MTGhostsBarNode"]);
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        
        if (ghostBar.ghostIconQuota > 1 ||
            rep.myGhostIcon.myGhost.ghostInstances.count > 1)
        {
            [sceneArea addBinForGhostRep:rep];
        }
    }
    
    if ([rep getSelectedRepresentationNode] != rep)
    {
        [rep makeMeSelected];
    }
    
    [self moveRep:g :v WithGhostRep:rep];
    
    if(g.state == UIGestureRecognizerStateEnded)
    {
        [rep.myGhostInstance setPosition:rep.position];
        //[rep makeMeUnselected];
        
        // Usuwanie duszka
        if (rep.position.x <= - WIDTH / 2 + sceneArea.bin.size.width + (rep.size.width/4) &&
            rep.position.y <= - HEIGHT / 2 + sceneArea.bin.size.height + (rep.size.height/4))
        {
            [sceneArea.bin ghostRepDrop:rep];
        }
        [sceneArea removeBin];
    }

}

-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep
{
    if ([MTGhostRepresentationNode getSelectedRepresentationNode] != rep)
    {
        [rep makeMeSelected];
        [rep animateTap];
        
    } else {
        
        [rep makeMeUnselected];
    }
}

-(void) scaleRep:(MTGhostRepresentationNode *) rep
     WithGesture:(UIGestureRecognizer *)g
{
    static CGPoint tmp;
    UIPinchGestureRecognizer *p = (UIPinchGestureRecognizer*)g;
    if(g.state == UIGestureRecognizerStateBegan)
    {
        tmp = CGPointMake
        (p.scale / rep.xScale, p.scale / rep.yScale);
    }
    CGFloat scale = p.scale / tmp.x;
    if (scale <= 2.0 && scale >= 0.5)
    {
        [rep setScale:scale];
        [rep.myGhostInstance.node setScale:scale];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep
{
    bool menuMode = ((MTSceneAreaNode *)[(SKNode *)rep.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]).menuMode;
    if(!menuMode && [MTGhostRepresentationNode getSelectedRepresentationNode] == rep)
    {
        [self scaleRep:rep WithGesture:g];
        
        if (g.state == UIGestureRecognizerStateEnded)
        {
            [rep.myGhostInstance.node setZRotation:rep.zRotation];
            [rep physicBodyForGhostRep: rep width:rep.size.width height:rep.size.height scale:rep.xScale];
        }
    }
    
}

-(void) rotateRep:(MTGhostRepresentationNode *)rep
      WithGesture:(UIGestureRecognizer*)g
{
    static float poczatek;
    UIRotationGestureRecognizer*p = (UIRotationGestureRecognizer*)g;
    CGFloat angle = p.rotation;
    if(g.state == UIGestureRecognizerStateBegan)
    {
        poczatek = p.rotation - rep.zRotation;
    }
    [rep setZRotation:-angle - poczatek];
}

-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep;
{
    bool menuMode = ((MTSceneAreaNode *)[(SKNode *)rep.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]).menuMode;
    if(!menuMode && [MTGhostRepresentationNode getSelectedRepresentationNode] == rep)
    {
        [self rotateRep:rep WithGesture:g];
        //@try{
        //MTGhostRepresentationEffectNode * meff= [MTGhostRepresentationEffectNode getCurrentEffectNode];
        //    [meff rotateGesture:g :v];
        //}@catch(NSException* e){
        //
       // }
        if (g.state == UIGestureRecognizerStateEnded)
        {
            [rep.myGhostInstance.node setZRotation:rep.zRotation];
            
        }
    }
}
-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep
{
    ////NSLog(@"PRzytrzymany długo więc kasujemy");
    //PRZYTRZYMALEM, wiec sie kasujemy
    [self tapGesture:g WithGhostRep:rep];
    [rep animateTap];
    [rep remove];
    
}
-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt
{
    rep.position = pt;
}

-(void) setPositionOfAllReps
{
    
}
@end
