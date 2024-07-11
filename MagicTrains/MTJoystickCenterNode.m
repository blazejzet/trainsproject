//
//  MTJoystickCenterNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 02.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTJoystickCenterNode.h"
#import "MTJoystickNotificationsNames.h"
@interface MTJoystickCenterNode()

@property CGPoint startupPosition;
@property CGPoint tstart;

@end


@implementation MTJoystickCenterNode
-(id) init {
    if ((self = [super initWithImageNamed:@"JOYSTICK2.png"]))
    {
        self.name = @"MTJoysitckCenterNode";
        self.zPosition=1222;
        self.startupPosition= self.position;
        [self setUserInteractionEnabled: YES];
    }
    return self;
}

-(void)hold:(UIGestureRecognizer *)g :(UIView *)v{
    
    
}

-(void)hold2:(UIGestureRecognizer *)g :(UIView *)v{
    if(g.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p = [g locationInView:v];
        p = CGPointMake(p.x-110, 768-p.y-110);
        self.position=p;
        self.force=CGPointMake(p.x-self.startupPosition.x, p.y-self.startupPosition.y);
    }
    if(g.state == UIGestureRecognizerStateEnded)
    {
        //self.force=CGPointMake(p.x-self.startupPosition.x, p.y-self.startupPosition.y);
        [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickLeftArrowDrop object:self];
        [self runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.1]];
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * g = touches.anyObject;
    _tstart= [g locationInView:self.scene.view];
 
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ////NSLog(@"XX"); 
    UITouch * g = touches.anyObject;
    CGPoint p = [g locationInView:self.scene.view];
   
    CGPoint cvec= CGPointMake(p.x-_tstart.x, p.y-_tstart.y);
    ////NSLog(@"[%f,%f]",cvec.x,cvec.y);
    CGFloat len = sqrtf(cvec.x*cvec.x+cvec.y*cvec.y);
    ////NSLog(@"[%f,%f] = %f",cvec.x,cvec.y,len);
    if(len>90){
        cvec = CGPointMake(90.0*cvec.x/len, 90.0*cvec.y/len);
    }
    self.position = CGPointMake(self.startupPosition.x+cvec.x, self.startupPosition.y-cvec.y);
        self.force=CGPointMake(self.position.x+self.startupPosition.x, self.position.y-self.startupPosition.y);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    return YES;
}


-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //self.force=CGPointMake(p.x-self.startupPosition.x, p.y-self.startupPosition.y);
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickLeftArrowDrop object:self];
    [self runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.1]];
    
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //self.force=CGPointMake(p.x-self.startupPosition.x, p.y-self.startupPosition.y);
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickLeftArrowDrop object:self];
    [self runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.1]];
    
}
@end
