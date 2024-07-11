//
//  MTRibbon.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 09.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTRibbon.h"
#import "MTMainScene.h"
#import "MTGUI.h"
#import "MTGhostsBarNode.h"

@implementation MTRibbon

-(id)init{
    self=[super initWithImageNamed:@"toggle.png"];
    if(self){
        
    }
    return self;
}

-(id)initR{
    self=[super initWithImageNamed:@"toggle2.png"];
    if(self){
        
    }
    return self;
}


-(void)redify{
    self.texture=[SKTexture textureWithImageNamed:@"toggle.png"];
}
-(void)orangify{
    self.texture=[SKTexture textureWithImageNamed:@"toggleo.png"];
    
}

-(void) swipe:(UISwipeGestureRecognizer *)g :(UIView *)v
{
    ////NSLog (@"Swipe na %@",self.name);
}

-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    ////NSLog (@"Hold na %@",self.name);
}/*


-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [self panGestureMain:g :v];
}

-(void) panGestureMain:(UIGestureRecognizer *)g :(UIView *)v
{
    SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
    
    static CGPoint StartPosition;
    if (g.state == UIGestureRecognizerStateBegan)
    {
        StartPosition = root.position;
    }
    
    [self moveRoot:(UIGestureRecognizer *)g v:(UIView *)v];
    
    float positionWhenOpened = WIDTH - GHOST_BAR_WIDTH;
    float pktGraniczny = (positionWhenOpened)/ 6 ;
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        SKAction *act;
        // jesli przeciaganie zaczyna sie w poblizu zera
        if(StartPosition.x <= 1)
        {
            if (root.position.x < pktGraniczny)
            {
                ///przesuniecie w kierunkiu 0 (zamykanie sceneArea)
                act = [SKAction moveByX: 0                  - root.position.x y:0.0 duration:0.2 ];
                [(MTMainScene *)self.scene prepareSimultaneousNone];
            }
            else
            {
                //przesuniecie w kierunkiu positionWhenOpened
                act = [SKAction moveByX: positionWhenOpened - root.position.x y:0.0 duration:0.2 ];
                [(MTMainScene *)self.scene prepareSimultaneousPinchRotate];
            }
        }
        else
        {
            if (root.position.x >= positionWhenOpened - pktGraniczny)
            {
                // przesuniecie w kierunkiu positionWhenOpened
                act = [SKAction moveByX: positionWhenOpened - root.position.x y:0.0 duration:0.2 ];
                [(MTMainScene *)self.scene prepareSimultaneousPinchRotate];
            }
            else
            {
                // przesuniecie w kierunkiu 0 (zamykanie sceneArea)
                act = [SKAction moveByX: 0 - root.position.x y:0.0 duration:0.2 ];
                [(MTMainScene *)self.scene prepareSimultaneousNone];
            }
        }
        [self.parent runAction: act];
    }
    
}

*/
- (void)moveRoot:(UIGestureRecognizer *)g v:(UIView *)v
{
    [((MTGhostsBarNode*)self.parent) moveRoot:g v:v];
}


@end
