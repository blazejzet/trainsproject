//
//  MTWelcomeDialog.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 25.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTWelcomeDialog.h"
#import "MTMainScene.h"
#import "MTStorage.h"
#import "MTArchiver.h"
#import "MTFloatingSelector.h"
@interface MTWelcomeDialog ()

@property MTFloatingSelector *selector;
@property NSMutableArray *numberButtons;

@end

@implementation MTWelcomeDialog

-(id)init
{
    if (self = [super init])
    {
            CGSize buttonSize = CGSizeMake(100, 100);
        SKTexture* newButtonTex = [SKTexture textureWithImageNamed:@"locomotiveWhile.png"];
        SKTexture* reloadButtonTex = [SKTexture textureWithImageNamed:@"locomotiveClone.png"];
        
        self.selector = [[MTFloatingSelector alloc] initWithImageNamed:@"chmura.png"];
        [self.selector setSize:CGSizeMake(120, 120)];

        self.numberButtons = [[NSMutableArray alloc] init];
        for (int i=0; i<10 ;i++)
        {
            NSString *name = [NSString stringWithFormat:@"Numbers-%d-icon.png",i];
            MTButton *NB = [[MTButton alloc]initWithImageOnActiveNamed:name];
            [self.numberButtons addObject: NB];
            NB.position = CGPointMake((i%4)*100, (i/4)*100);
            NB.zPosition = 1.0;
            NB.size = CGSizeMake(100,100);
            NSString *minatureImageName = [[MTArchiver getInstance] getMiniatureWithNr:i];
            if (minatureImageName)
            {
                NB.texture = [SKTexture textureWithImageNamed: minatureImageName];
            }
            [self addChild:NB];
        }
        [self prepareNumberButtonsPositions];
        
        self.selector.nodes = self.numberButtons;
        [self.selector prepareActions];
        [self addChild: self.selector];
        
        [self setSize: CGSizeMake(1024, 768)];
        self.texture = [SKTexture textureWithImageNamed:@"startup@x2.png"];
    
        self.OKButton.texture = reloadButtonTex;
        self.OKButton.size = buttonSize;
        self.OKButton.position = CGPointMake(-512 + buttonSize.width , - 384 + buttonSize.height);
    
        self.CancelButton.texture = newButtonTex;
        self.CancelButton.size = buttonSize;
        self.CancelButton.position = CGPointMake(512 - buttonSize.width , - 384 + buttonSize.height);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onOKTapped)
                                                     name:N_DialogOKTapped
                                                   object:self];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onCancelTapped)
                                                     name:N_DialogOffTapped
                                                   object:self];
        for (MTButton* button in self.numberButtons)
        {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNumberTapped:)
                                                     name:N_ButtonTapped object:button];
        }
        
    }
    return self;
}
-(void)prepareNumberButtonsPositions
{
    NSMutableArray * NBs = self.numberButtons;
    ((MTButton *) NBs[0]).position = CGPointMake(-400, -170);
    
    ((MTButton *) NBs[1]).position = CGPointMake(-350,  -50);
    
    ((MTButton *) NBs[2]).position = CGPointMake(-410,   70);
    
    ((MTButton *) NBs[3]).position = CGPointMake(-320,  190);
    
    ((MTButton *) NBs[4]).position = CGPointMake(-440,  310);
    
    ((MTButton *) NBs[9]).position = CGPointMake( 400, -170);
    
    ((MTButton *) NBs[8]).position = CGPointMake( 350,  -50);
    
    ((MTButton *) NBs[7]).position = CGPointMake( 410,   70);
    
    ((MTButton *) NBs[6]).position = CGPointMake( 320,  190);
    
    ((MTButton *) NBs[5]).position = CGPointMake( 440,  310);
    
    self.selector.position = ((MTButton *) NBs[0]).position;
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
}
-(void)onOKTapped
{
    NSString *filename = [NSString stringWithFormat:@"SessionData%lu.mtd",(unsigned long) self.selector.indexOfSelectedNode];
    [[MTArchiver getInstance] setFilename: filename];
    
    [[MTArchiver getInstance] decodeStorage];
    [(MTMainScene *) self.scene prepareGUI];
    [self removeFromParent];
}
-(void)onCancelTapped
{
    NSString *filename = [NSString stringWithFormat:@"SessionData%lu.mtd",(unsigned long) self.selector.indexOfSelectedNode];
    [[MTArchiver getInstance] setFilename: filename];
    
    [[MTStorage alloc] initSingleton];
    [(MTMainScene *) self.scene prepareGUI];
    [self removeFromParent];
}

-(void)onNumberTapped:(NSNotification *)notify
{
    NSUInteger index = [self.numberButtons indexOfObject: notify.object];
    self.selector.indexOfSelectedNode = index;
}
@end
