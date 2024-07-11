//
//  MTDialogWindow.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTDialogWindow.h"
#import "MTGUI.h"
@interface MTDialogWindow ()

@property MTSpriteNode *background;

@end
@implementation MTDialogWindow

-(id)init
{
    if (self = [super init])
    {
        self.OKButton = [[MTButton alloc] initWithImageOnActiveNamed:@"accept.png"];
        self.CancelButton = [[MTButton alloc] initWithImageOnActiveNamed:@"cancel.png"];
        
        [self setColor: [UIColor blueColor]];

        [self setPosition:CGPointMake(512, 384)];
        [self setZPosition:2000];
        [self setSize: CGSizeMake(500, 500)];
        
        self.background = [MTSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(HEIGHT, WIDTH)];
        self.background.alpha = 0.7;
        [self.background setZPosition: - 1 ];
        
        [self.OKButton setPosition:CGPointMake(-200, -200)];
        [self.OKButton setSize: CGSizeMake(50, 50)];
        
        [self.CancelButton setPosition:CGPointMake(200, -200)];
        [self.CancelButton setSize: CGSizeMake(50, 50)];
        
        [self.OKButton setZPosition:1];
        [self.CancelButton setZPosition:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOKTap) name:N_ButtonTapped object:self.OKButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelTap) name:N_ButtonTapped object:self.CancelButton];
        
        [self addChild: self.OKButton];
        [self addChild: self.CancelButton];
        [self addChild: self.background];
    }
    return self;
}
-(id)initWithContent:(MTSpriteNode *)content
{
    self = [self init];
    self.content = content;
    
    [self.content fitSizeIntoSprite:self];
    
    [self addChild: content];
    [self.content setZPosition: self.zPosition +1];
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

-(void)onOKTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_DialogOKTapped
                                                        object: self];
    ////NSLog(@"tapped OK");
    //[self.background re];
}

-(void)onCancelTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_DialogOffTapped
                                                        object: self];
    ////NSLog(@"tapped Cancel");
    //[self.background removeBackground];

}
@end
