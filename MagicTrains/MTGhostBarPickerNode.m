 //
//  MTGhostBarPickerNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGhostBarPickerNode.h"
#import "MTGhostBarPickerCellNode.h"
#import "MTGhostIconNode.h"
#import "MTGUI.h"
#import "MTGhostsBarNode.h"
#import "MTCodeAreaNode.h"

@implementation MTGhostBarPickerNode
static float spaceY;
static float spaceX;
static float centerPosBlockade;
static float upPosBorder;

-(id) init
{
    self = [super init];
    self.icons = [[NSMutableArray alloc] init];
    //self.color = [UIColor redColor];
    self.size = CGSizeMake(GHOST_BAR_WIDTH, HEIGHT);
    self.anchorPoint = CGPointMake(0, 1);
    self.name = @"MTGhostBarPickerNode";
    //self.color =[UIColor redColor];
    self.sizeEl = 55;
    spaceY = 10;
    spaceX = (GHOST_BAR_WIDTH-self.sizeEl)/2;
    self.centerIndex = 0;
    self.nextSpace = spaceY;
    
    return self;
}

-(void) addNewElementToPicker:(MTGhostIconNode *) icon
{
    icon.anchorPoint = CGPointMake(0.5, 0.5);
    icon.size = CGSizeMake(self.sizeEl, self.sizeEl);
    
    if(self.icons.count > 0)
    {
        [self changeCellsPositionWithIndex:self.centerIndex];
        
        MTGhostIconNode *curentCenter = self.icons[self.centerIndex];
        icon.position = CGPointMake(icon.size.width/2+spaceX, curentCenter.position.y+self.sizeEl+spaceY);
    }
    else
        icon.position = CGPointMake(icon.size.width/2+spaceX, -icon.size.width/2);

    [self.icons insertObject:icon atIndex:self.centerIndex];
    [self addChild:icon];
    
    centerPosBlockade = HEIGHT/2 + self.sizeEl/2;
    upPosBorder = HEIGHT-170;

    [self updateAlpha];
}

-(void) changeCellsPositionWithIndex:(int) index
{
    for(int i = index; i < self.icons.count; i++)
    {
        MTSpriteNode *cell = (MTGhostBarPickerCellNode *)self.icons[i];
        cell.position = CGPointMake(cell.position.x, cell.position.y-self.sizeEl-spaceY);
    }
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    MTGhostsBarNode* b = ( MTGhostsBarNode*)self.parent;
   [b panGestureMain:g :v ];

    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)g;
    
    CGPoint velocity = [panGesture velocityInView:self.scene.view];
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    
    if(g.state == UIGestureRecognizerStateBegan)
        self.yBegan = self.position.y;
    
    if(isVerticalGesture && !self.vertical)
    {
        self.horizontal = true;
        
        if(!self.animationFlag)
        {
            if(g.state == UIGestureRecognizerStateBegan)
                self.yBegan = self.position.y;
            
            CGPoint newPos = [self newPositionVerticallyWithGesture:g inView:v inReferenceTo:self.parent];
            float height = [self calculateMyheight];
            
            if(newPos.y > HEIGHT/2 + self.sizeEl/2 && newPos.y < height)
                self.position = [self newPositionVerticallyWithGesture:g inView:v inReferenceTo:self.parent];
            
            [self updateAlpha];
            
            if(g.state == UIGestureRecognizerStateEnded)
                self.horizontal = false;
        }
    }
    else if(!self.horizontal)
    {
        self.vertical = true;
        MTGhostsBarNode *ghostBar = (MTGhostsBarNode *)self.parent;
        [ghostBar panGesture:g :v];
        
        if(g.state == UIGestureRecognizerStateEnded)
            self.vertical = false;
    }
    
    if(g.state == UIGestureRecognizerStateEnded)
        [self fitIcons];
}

-(int) getIconIndex:(MTGhostIconNode *) icon
{
    for(int i = 0; i < self.icons.count; i++)
        if(icon == self.icons[i])
            return i;
    
    return -1;
}



-(void) fitIcons
{
    if(!self.animationFlag)
    {
        MTGhostIconNode *lastCenterIcon = self.icons[self.centerIndex];
        MTGhostIconNode *currentCenterIcon;
        
        int diff = self.yBegan-self.position.y;
        float iconSize = (self.sizeEl+spaceY);
        int icons = -(diff/iconSize);
        float rest;
        
        rest = diff + icons*(self.sizeEl+spaceY);
        
        if(rest > self.sizeEl/2)
            icons--;
        
        else if(rest < -self.sizeEl/2)
            icons++;
        
        int index = self.centerIndex+icons;
        
        if(self.centerIndex+icons < 0)
            index = 0;
        
        else if(self.centerIndex+icons >= self.icons.count)
            index = self.icons.count-1;
        
        currentCenterIcon = self.icons[index];
        
        float d = abs(lastCenterIcon.position.y - currentCenterIcon.position.y);
        
        if(self.position.y > self.yBegan)
            d = self.yBegan+d;
        
        else
            d = self.yBegan-d;
        
        int currentIndex = [self getIconIndex:currentCenterIcon];
        self.animationFlag = true;
        
        SKAction *act = [SKAction moveTo:CGPointMake(self.position.x, d) duration:0.2];
        [self runAction:act completion:^{[self updateIndexesWithCurrentIndex:currentIndex];}];
    }
}

-(void) fitIconsPPQ
{
    if(!self.animationFlag)
    {
        MTGhostIconNode *lastCenterIcon = self.icons[self.centerIndex];
        MTGhostIconNode *currentCenterIcon;

        if(lastCenterIcon)
            currentCenterIcon = lastCenterIcon;
        else
            currentCenterIcon = self.icons[self.icons.count - 1];
        
        int currentIndex = [self getIconIndex:currentCenterIcon];
        self.animationFlag = true;
        
        [self updateIndexesWithCurrentIndex:currentIndex];
    }
}

-(void) removeIconFromPicker:(MTGhostIconNode *)icon
{
    int deleteIndex = [self.icons indexOfObject:icon];
    
    [self.icons removeObject:icon];

    if(deleteIndex == self.icons.count)
    {
        SKAction *act = [SKAction moveTo:CGPointMake(self.position.x, self.position.y-self.sizeEl-spaceY) duration:0.2];
        [self runAction:act];
        
        self.centerIndex--;
    }
    else if(deleteIndex == 0 && self.centerIndex == self.icons.count)
    {
        SKAction *act = [SKAction moveTo:CGPointMake(self.position.x, self.position.y-self.sizeEl-spaceY) duration:0.2];
        [self runAction:act];
        
        self.centerIndex--;
    }
    
    for(int i = deleteIndex; i < self.icons.count; i++)
    {
        MTGhostIconNode *icon = self.icons[i];
        SKAction *act = [SKAction moveTo:CGPointMake(icon.position.x, icon.position.y+self.sizeEl+spaceY) duration:0.2];
        [icon runAction:act];
    }
    
    [self calculateMyheight];
    [self updateAlpha];
}

-(CGFloat) calculateMyheight
{
    return (HEIGHT/2)+(self.icons.count*(self.sizeEl+spaceY))-self.sizeEl/2;
}

-(void) staticMoveWithDist:(CGFloat) dist
{
    SKAction *alphaAction;
    for(int i = 0; i < self.icons.count; i++)
    {
        MTGhostIconNode *icon = (MTGhostIconNode *)self.icons[i];
        
        float scale = [self getScaleForIcon:icon WithNewDiff:dist];
        
#if DEBUG_NSLog
        ////NSLog(@"SCALE: %f", scale);
#endif
        
        //alphaAction = [SKAction fadeAlphaTo:scale duration:0.2];
        [icon runAction:alphaAction];
        
        //alphaAction = [SKAction scaleTo:scale duration:0.2];
        //[icon runAction:alphaAction];
    }
    
    self.animationFlag = true;
}

-(NSMutableArray *) getAlphasWithDist:(CGFloat) dist
{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.icons.count; i++)
    {
        MTGhostIconNode *icon = (MTGhostIconNode *)self.icons[i];
        float scale = [self getScaleForIcon:icon WithNewDiff:dist];
        [a addObject:[NSNumber numberWithFloat:scale]];
    }
    
    return a;
}

-(void) tapGesture:(UIGestureRecognizer *)g WithIcon:(MTGhostIconNode *)icon
{
    if(!self.animationFlag)
    {
        int index = [self.icons indexOfObject:icon];
        float dist = abs(index-self.centerIndex)*(self.sizeEl+spaceY);
        
        if(self.centerIndex > index)
            dist = -dist;
        
        [self staticMoveWithDist:dist];
        
        SKAction *tapAction = [SKAction moveByX:0 y:dist duration:0.2];
        [self runAction:tapAction completion:^{[self updateIndexesWithCurrentIndex:index];}];
        
    }
}

-(void) removeAnimFlag
{
    self.animationFlag = false;
}

-(void) updateIndexesWithCurrentIndex:(int)index
{
    self.centerIndex = index;
    self.animationFlag = false;
    
    MTGhostIconNode *centerIcon = self.icons[index];
    [centerIcon makeMeSelected];
    //[(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] selectFirstTab];
    
    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] categoryBarInit];
    
    if(self.hold)
    {
        [self updateAlpha];
        self.hold = false;
    }
}

-(CGFloat) getScaleForIcon:(MTGhostIconNode *)icon WithNewDiff:(float )diffY
{
    CGPoint p = CGPointMake(icon.position.x, icon.position.y+diffY);
    CGPoint newPoint = [self convertPoint:p toNode:self.parent];

    float diff = 0;
    
    if(newPoint.y > centerPosBlockade)
        diff = upPosBorder-newPoint.y;
    else
        diff = centerPosBlockade - newPoint.y;
    
    if (diff < 0)
        diff = diff*(-1);
    
    float alpha = ((1/(diff*0.2))/2)+0.5;
    
    alpha = alpha > 1 ? 1 : alpha;
    
    return alpha;
    
    /*
    float alpha = (diff)/((HEIGHT/2));
    
    return alpha*alpha;*/
}

-(void) updateAlpha
{
    for(int i = 0; i < self.icons.count; i++)
    {
        MTGhostIconNode *icon = (MTGhostIconNode *)self.icons[i];
        
        float scale = [self getScaleForIcon:icon WithNewDiff:0];
        
        //icon.xScale = scale;
        //icon.yScale = scale;
        icon.alpha = scale;
    }
}

@end
