//
//  MTWindowAlert.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTWindowAlert.h"
#import "MTLabelTextNode.h"
#import "MTUndoChangesNode.h"
#import "MTBlockNode.h"
#import "MTGUI.h"
#import "MTSceneAreaNode.h"
#import "MTBlockingBackground.h"
#import "MTRecieveSignalLocomotiv.h"
//#import "NSThread.h"

@implementation MTWindowAlert
@synthesize progressv;

void(^callback)(void);


-(id) initWithGhost: (MTGhost *)gt ghostBarNode : (MTGhostsBarNode *)gBar ghostRepresentationNode: (MTGhostRepresentationNode *) ghostRep{
    
    if ((self = [super initWithImageNamed:@"alertGhostBG0.png"]))
        /*Konieczne ustawienie kolejnych stanow alertGhostBG1 .. BG4.png*/
    {
        self.size = CGSizeMake(150, 150);
        
        self.name = @"MTWindowAlertGhost";
        self.zPosition=5000;
        //self.user
        self.position = ghostRep.position;

        

        //MTUndoChangesNode * undo = [[MTUndoChangesNode alloc] init];
        //undo.position = CGPointMake(0, 120);
        //[self addChild: undo];
        [self progressBar];
        //undo.userInteractionEnabled=true;
        self.flag = TRUE;
        
        self.gt = gt;
        self.gBar = gBar;
        self.ghostRep = ghostRep;

        [self startThread];
            self.userInteractionEnabled=true;
        
    }
    return self;
}
-(id) initWithNode: (MTBlockNode*)b CB:(void(^)(void))cb{
    if ((self = [super initWithImageNamed:@"alertGhostBG0.png"]))
    /*Konieczne ustawienie kolejnych stanow alertGhostBG1 .. BG4.png*/
    {
        self.size = CGSizeMake(150, 150);
        callback=cb;
        self.name = @"MTWindowCallback";
        self.zPosition=2000;
        
        
        ////NSLog(@"PPP %f %f",b.parent.position.x,b.parent.position.y);
        ////NSLog(@"CCC %f %f",b.position.x,b.position.y);
        
        self.position = CGPointMake(b.parent.frame.origin.x+b.position.x, b.parent.frame.origin.y+b.position.y);
        
        
        
        MTUndoChangesNode * undo = [[MTUndoChangesNode alloc] init];
        undo.position = CGPointMake(0, 120);
        [self addChild: undo];
        [self progressBar];
        
        self.flag = TRUE;
        
        
        [self startThread];
    }
    return self;
}


-(id) initWithNode: (MTBlockNode*)b inContainer:(SKNode*)cont CB:(void(^)(void))cb{
    if ((self = [super initWithImageNamed:@"alertGhostBG0.png"]))
    /*Konieczne ustawienie kolejnych stanow alertGhostBG1 .. BG4.png*/
    {
        self.size = CGSizeMake(150, 150);
        callback=cb;
        self.name = @"MTWindowCallback";
        self.zPosition=2000;
        
        
        ////NSLog(@"PPP %f %f",b.parent.position.x,b.parent.position.y);
        ////NSLog(@"CCC %f %f",b.position.x,b.position.y);
        
        self.position = CGPointMake(b.position.x, b.position.y);
        SKNode* par = b.parent;
        while(par != cont){
            
            self.position = CGPointMake(par.frame.origin.x+self.position.x, par.frame.origin.y+self.position.y);
            
            par= par.parent;
        }
        
       // self.position = CGPointMake(b.parent.frame.origin.x+b.position.x, b.parent.frame.origin.y+b.position.y);
        
        
        
        MTUndoChangesNode * undo = [[MTUndoChangesNode alloc] init];
        undo.position = CGPointMake(0, 120);
        [self addChild: undo];
        [self progressBar];
        
        self.flag = TRUE;
        
        
        [self startThread];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostIconNode StopAnimation"
                                                            object: self];
    }
    return self;
}


-(id) initWithBlock : (MTBlockNode *) block
{
    if ((self = [super initWithImageNamed:@"alertGhostBG0.png"]))
    /*Konieczne ustawienie kolejnych stanow alertGhostBG1 .. BG4.png*/
    {
        self.size = CGSizeMake(300, 300);
        self.anchorPoint = CGPointMake(0, 0);
        self.name = @"MTWindowAlertBlock";
        self.zPosition=2000;
        
        self.position = CGPointMake(WIDTH/2 - self.size.width/2-80, HEIGHT/2 - self.size.height/2);
        
        
        MTUndoChangesNode * undo = [[MTUndoChangesNode alloc] init];
        undo.position = CGPointMake(self.size.width-45, ((self.size.height/4)-30));
        [self addChild: undo];
        [self progressBar];
        
        self.flag = TRUE;
        
        self.block = block;
        
        [self startThread];
        
    }

    return self;
}

-(id) initRemoveAllClones
{
    if ((self = [super initWithImageNamed:@"alertGhostBG0.png"]))
    /*Konieczne ustawienie kolejnych stanow alertGhostBG1 .. BG4.png*/
    {
        self.size = CGSizeMake(150, 150);
        //self.anchorPoint = CGPointMake(0, 0);
        self.name = @"MTWindowAlertAllClones";
        
        self.position = self.scene.position;//CGPointMake(-self.size.width/2, -self.size.height/2);
        self.zPosition=2000;
        
        MTUndoChangesNode * undo = [[MTUndoChangesNode alloc] init];
        undo.position = CGPointMake(0, 120);
        [self addChild: undo];
        [self progressBar];
        
        self.flag = TRUE;
        
        [self startThread];
    }
    return self;
}



-(void)tapGesture:(UIGestureRecognizer *)g{
    [self cancel];
}

-(void)cancel{
    self.flag = FALSE;
    [self removeMe];
}
-(void) progressBar
{
    
    SKShapeNode * _maskShapeNode = [SKShapeNode node];
    _maskShapeNode.antialiased = NO;
    _maskShapeNode.lineWidth = 10.0;
    
    self.progress = _maskShapeNode;
    [self.progress runAction: [SKAction repeatAction:[SKAction sequence:@[
                        [SKAction waitForDuration:0.05],
                        [SKAction performSelector:@selector(addProgress) onTarget:self]
                        ]] count:80]];
    self.progress.strokeColor =[UIColor redColor];
    [self addChild:self.progress];
    self.progress.userInteractionEnabled=true;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ////NSLog(@"touch!!");
}

-(void) addProgress{
    progressv = progressv - 0.0125;
    
    CGFloat startAngle = M_PI / 2.0f;
    CGFloat endAngle = startAngle + (progressv * 2.0f * M_PI);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                        radius:60.0
                                                    startAngle:endAngle
                                                      endAngle:startAngle
                                                     clockwise:YES];
    self.progress.path = path.CGPath;
}
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    static CGFloat startSize;
    CGFloat changedSize;
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        startSize = ((UIPinchGestureRecognizer *)g).scale;
    }
    
    changedSize = ((UIPinchGestureRecognizer *)g).scale;
                     
    if (g.state == UIGestureRecognizerStateEnded)
    {
        if (startSize > changedSize )
        {
            self.flag = FALSE;
            [self del];
            //[self removeFromParent];
        
            
            //przerwanie watku i
            
        }
    }
}

-(void) startThread
{
    
    self.myThread = [[NSThread alloc] initWithTarget: self
                                            selector:@selector(myThreadFunction)
                                              object:nil];
    
    [self.myThread start];  // Actually create the thread
    
}

-(void) myThreadFunction
{

    CFTimeInterval startTime = CACurrentMediaTime();
    
    while (true) {
        
        CFTimeInterval nowTime = CACurrentMediaTime();
        
        self.timeLabel.text =  [NSString stringWithFormat:@"%i", (int)(5-(nowTime - startTime))];
        
        if(nowTime - startTime > 4) {
            
            if (self.flag == TRUE) {
                [self del];
            }
            break;
        }
    }
    [self runAction:[SKAction sequence:@[
                                         
          [SKAction fadeAlphaTo:0.0 duration:0.3],
          [SKAction removeFromParent]
                                         
                                         ]]];
    
}

-(void) del
{
    if ([self.name isEqual: @"MTWindowAlertGhost"])
    {
        // usuwam ikonke z bara i duszka ze Storage
        [self.gt removeGhostInstance:self.ghostRep.myGhostInstance];
        //usuniecie notyfikacji;
        [self.ghostRep.myFlags removeNotifications];
        [self.ghostRep removeFromParent];
        
        if(self.gt.ghostInstances.count == 0)
        {
            [self.gBar removeGhostIcon:self.ghostRep.myGhostIcon];
        }
    }
    else if ([self.name isEqual: @"MTWindowAlertBlock"])
    {
        [self.block.myCart.mySubTrain.myTrain.myGhost removeTrain:self.block.myCart.mySubTrain.myTrain];
        [self.ghost removeTrain: self.train];
    }
    else if ([self.name isEqual: @"MTWindowAlertAllClones"])
    {
        [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] deleteAllClones];
    }
    else if(callback != nil){
        ////NSLog(@"Running callback.");
        callback();
    }
    [self removeMe];
}

-(void) removeMe
{
    // usuwam swoja reprezentacje ze sceny
    [self runAction:[SKAction sequence:@[
                                         
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction removeFromParent]
                                         
                                         ]]];
    
    [self.background removeBackground];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostIconNode RunAnimation"
                                                        object: self];
    
}





@end
