//
//  MTButton.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTButton.h"
#import "MTLabelTextNode.h"
@interface MTButton ()

@property MTLabelTextNode *label;

@end


@implementation MTButton

@synthesize text;

-(id)init
{
    if (self = [super init])
    {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.label = [[MTLabelTextNode alloc] init];
        [self.label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    }
    return self;
}

-(id)initWithText:(NSString *)aText
{
    if (self.init)
    {
 //   self.label = [[MTLabelTextNode alloc] init];
        self.label = [[MTLabelTextNode alloc] init];
    [self.label setText:aText];
    [self addChild: self.label];
    }
    return self;
}
-(id)initWithImageOnActiveNamed:(NSString *)name
{
    if (self.init)
    {
        self.textureOnActive = [SKTexture textureWithImageNamed:name];
        self.texture = self.textureOnActive;
        
        self.textureOnUnactive = self.textureOnActive;
    }
    return self;
}
-(id)initWithImageOnActiveNamed:(NSString *) nameActive
           imageOnUnactiveNamed:(NSString *) nameUnactive
{
    if (self.init)
    {
        self.textureOnActive = [SKTexture textureWithImageNamed:nameActive];
        self.textureOnUnactive = [SKTexture textureWithImageNamed:nameUnactive];
        
        self.textureOnUnactive = self.textureOnActive;
    }
    return self;
}

-(void)setText:(NSString *)aText
{
    [self.label setText:aText];
}

-(NSString *)text
{
    return [self.label text];
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [[NSNotificationCenter defaultCenter] postNotificationName:N_ButtonTapped object:self];
}

-(void)hold:(UIGestureRecognizer *)g :(UIView *)v
{
    [[NSNotificationCenter defaultCenter] postNotificationName:N_ButtonHolded object:self];
}

@end
