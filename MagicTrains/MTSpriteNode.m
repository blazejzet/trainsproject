//
//  MTSpriteNode.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 19.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTGUI.h"

#import "MTMainScene.h"
#import "MTViewController.h"

@implementation MTSpriteNode
@synthesize selected;

-(id) init
{
    if (self = [super init])
    {
        //////NSLog(@"zawsze");
    }
    
    return self;
}

/* obsluga gestu */
-(void)animateTap{
    
}
-(void)tapGesture:(UIGestureRecognizer *)g
{
    //////NSLog (@"%@",self.name);
}

-(void) panGesture:(UIGestureRecognizer *) g :(UIView *) v 
{
    //////NSLog (@"Pan na %@",self.name);
}
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    //////NSLog (@"Pinch na %@",self.name);
}
-(void) rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Rotate na %@",self.name);
}

-(void) swipe:(UISwipeGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Swipe na %@",self.name);
}

-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Hold na %@",self.name);
}
-(void)holdGesture:(UIGestureRecognizer *)g  :(UIView *)v
{
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (CGPoint)newPositionWithGesture:(UIGestureRecognizer *)g
                           inView:(UIView *)v
                    inReferenceTo:(SKNode *)refPoint
{
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer * ) g;
    static CGPoint tmp;
    
    CGPoint r = self.position;
    
    //CGPoint point = [p locationInView:v];
    if ([p numberOfTouches] >0 && [p numberOfTouches] <4)
    {
        CGPoint point = [p locationOfTouch: 0 inView:v];
        
        point = CGPointMake(         point.x  - refPoint.position.x,
                           (HEIGHT - point.y) - refPoint.position.y);
        
        if(g.state == UIGestureRecognizerStateBegan)
        {
            tmp = CGPointMake(point.x - self.position.x,
                              point.y - self.position.y);
        }
        
        r.x =  point.x - tmp.x;
        r.y =  point.y - tmp.y;
    }
    
    return r;
}
- (CGPoint)newPositionVerticallyWithGesture:(UIGestureRecognizer *)g
                                     inView:(UIView *)v
                              inReferenceTo:(SKNode *)refPoint
{
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer * ) g;
    static CGPoint tmp;
    //CGPoint point = [p locationInView:v];
    CGPoint r = self.position;
    
    
    
    if ([p numberOfTouches] > 0 && [p numberOfTouches] < 4)
    {
        CGPoint point = [p locationOfTouch: 0 inView:v];
        
        point = CGPointMake( self.position.x, HEIGHT - point.y - self.parent.position.y);
        
        if(g.state == UIGestureRecognizerStateBegan)
        {
            tmp = CGPointMake(point.x , point.y - self.position.y);
        }
        
        r.y =  point.y - tmp.y;
    }
    
    return r;
}

- (CGPoint)newPositionHorizontallyWithGesture:(UIGestureRecognizer *)g
                                       inView:(UIView *)v
                                inReferenceTo:(SKNode *)refPoint
{
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer * ) g;
    static CGPoint tmp;
    //CGPoint point = [p locationInView:v];
    CGPoint r = self.position;
    
    if ([p numberOfTouches] >0 && [p numberOfTouches] <4)
    {
        CGPoint point = [p locationOfTouch: 0 inView:v];
        
        point = CGPointMake( point.x - self.parent.position.x,0 );
        
        if(g.state == UIGestureRecognizerStateBegan)
        {
            tmp = CGPointMake(point.x - self.position.x,0 );
        }
        
        r.x =  point.x - tmp.x;
    }
    
    return r;
}


-(void)rotateGesture1:(UIGestureRecognizer *)g inView:(UIView *)v inReferenceTo:(SKNode *)refPoint
{
    UIRotationGestureRecognizer*p = (UIRotationGestureRecognizer*)g;
    CGFloat angle = p.rotation;
    static CGPoint tmp;
    
    if(g.state == UIGestureRecognizerStateBegan)
    {
        tmp = CGPointMake(angle - refPoint.zRotation,0);
    }
    [self setZRotation: -angle - tmp.x];
    

    if (g.state == UIGestureRecognizerStateEnded)
    {
        [refPoint setZRotation:refPoint.zRotation];
    }
}

-(void) fitSizeIntoSprite:(SKSpriteNode *) sprite
{
    CGFloat aspect = 1;
    if (self.size.height > sprite.size.height)
    {
        aspect = sprite.size.height / self.size.height;
        self.size = CGSizeMake( self.size.width * aspect, self.size.height * aspect);
    }
    if (self.size.width > sprite.size.width)
    {
        aspect = sprite.size.width / self.size.width;
        self.size = CGSizeMake( self.size.width * aspect, self.size.height * aspect);
    }
}

/*-(void) runAction:(SKAction *)action
{
    if(self.lastAnimationFinished)
    {
        self.lastAnimationFinished = false;
        [super runAction:action completion:^{
            self.lastAnimationFinished = true;
        }];
    } else {
        self.lastAnimationFinished = false;
        self.positionBeforeAnimation = self.position;
        [super runAction:action completion:^{
            self.lastAnimationFinished = true;
        }];
    }
}

-(void) runAction:(SKAction *)action completion:(void (^)())block
{

    self.positionBeforeAnimation = self.position;
    
    if(self.lastAnimationFinished)
    {
        self.lastAnimationFinished = false;
        [super runAction:action completion:^{
            self.lastAnimationFinished = true;
        }];
    } else {
        self.lastAnimationFinished = false;
        self.position = self.positionBeforeAnimation;
        [super runAction:action completion:^{
            (void)block();
            self.lastAnimationFinished = true;
        }];
    }
}*/

/* TODO: dodac wiecej reakcji na gesty*/
@end
