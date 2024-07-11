//
//  MTGhostMenuView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 03.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTGhostMenuView.h"
#import "MTStorage.h"
#import <SpriteKit/SpriteKit.h>
#import "MTSceneAreaNode.h"
#import "MTGhostsBarNode.h"
#import "MTGhostInstance.h"
#import "MTBlockingBackground.h"
#import "MTWindowAlert.h"
#import "MTParamView.h"
#import "MTGUI.h"
#import "MTSceneAreaNode.h"
#import "MTHelpView.h"
#import "MTINMenuView.h"

@interface MTGhostMenuView()
@property MTGhost* myGhost;
@property NSString* myGhostCostumeName;
@property NSString* myGhostType;
@property UIImageView * ghostView;
@property UIImageView * spinnerCostumeCat;
@property NSMutableArray* spinnerCostumeCatImages;
@property NSMutableArray* spinnerCostumeColorImages;
@property UIImageView * spinnerCostumeColor;
@property (weak) id<MTGhostIconNodeProtocol> selectedIcon;
@property BOOL removed;
@property int old_help;

@property int ghostNumber;
@property int ghostColorNumber;
@property (weak) SKView* s;
@property CGRect properframe;
@property CGRect smallframe;
@property CGRect bigframe;

@property UIImageView * cloneOneButton ;
@property UIImageView * cloneMultiButton;
@property UIImageView * deleteButton;
@property MTParamView * HP_PARAM;
@property MTParamView * MASS_PARAM;

@property UISwitch* pcode_switch;
@property UISwitch* pproperties_switch;
@property UISwitch* pclone_switch;
@property UISwitch* pmove_switch;

@end
@implementation MTGhostMenuView{
     CGPoint start;
    CGPoint startpos;
    CGPoint touchstartpos;
    BOOL colors ;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@synthesize cloneOneButton ;
@synthesize cloneMultiButton;
@synthesize deleteButton;
@synthesize HP_PARAM;
@synthesize MASS_PARAM;
@synthesize removed;
@synthesize bigframe;
@synthesize properframe;
@synthesize smallframe;
@synthesize selectedIcon;
@synthesize myGhost;
@synthesize myGhostCostumeName;
@synthesize myGhostType;
@synthesize ghostView;

@synthesize ghostColorNumber;
@synthesize ghostNumber;

@synthesize spinnerCostumeCat;
@synthesize spinnerCostumeCatImages;
@synthesize spinnerCostumeColorImages;
@synthesize s;

@synthesize spinnerCostumeColor;

-(instancetype)initWithGhost:(MTGhost*)g :(MTGhostIconNode*)selectedIcon;{
    self = [self initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    if (self){
        self.bigframe=CGRectMake(-100,000,944,HEIGHT);
        if(HEIGHT==1024)//iPadPro
        {
            self.smallframe=CGRectMake(-630,000,944,HEIGHT);
        }else{
            self.smallframe=CGRectMake(-939,000,944,HEIGHT);
        }
        UIImageView * u = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"DBG.png"]];
        [u setFrame:CGRectMake(000,000,944,HEIGHT)];
        self.selectedIcon=selectedIcon;
        self.myGhost=g;
        //[self setClipsToBounds:YES];
        [self setFrame:CGRectMake(000,000,944,HEIGHT)];
        [self addSubview:u];
        self.alpha=0;
        self.userInteractionEnabled=YES;
        //UIPinchGestureRecognizer * gr = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromParent)];
        //UISwipeGestureRecognizer * swi = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromParent:)];
        //[swi setDirection:UISwipeGestureRecognizerDirectionRight];
        //self.gestureRecognizers=@[gr,swi];
        self.removed=NO;
    }
    return self;
}

//DLA PRZESUWANIA GÓRA DÓŁ DUSZKI
-(void)touchesBegan1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    touchstartpos = [touches.anyObject locationInView:self];
    if (touchstartpos.x>150 && touchstartpos.x<400){
        //colors
        colors=true;
    }else{
        colors=false;
    }
}
-(void)touchesMoved1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint cur =[touches.anyObject locationInView:self];
    if (cur.x>150 ){
    if (cur.x>150 && cur.x<650){
        
        CGPoint ch = CGPointMake(cur.x-touchstartpos.x, cur.y-touchstartpos.y);
        if(colors){
            for(UIImageView * ghost in spinnerCostumeColorImages){
                ghost.center = CGPointMake(ghost.center.x, ghost.center.y+ch.y);
            }
        }else{
            for(UIImageView * ghost in spinnerCostumeCatImages){
                ghost.center = CGPointMake(ghost.center.x, ghost.center.y+ch.y);
            }
        }
    }
    }else{
        [self touchesEnded1:touches withEvent:event];
    }
    touchstartpos = [touches.anyObject locationInView:self];
}
-(void)touchesEnded1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(colors){
        for(UIImageView * ghost in spinnerCostumeColorImages){
            if(ghost.center.y>HEIGHT/2-60 && ghost.center.y<HEIGHT/2+60){
                [self colorSetup:ghost];
                
            }
        }
    }else{
        
    
     for(UIImageView * ghost in spinnerCostumeCatImages){
        if(ghost.center.y>HEIGHT/2-60 && ghost.center.y<HEIGHT/2+60){
            [self costumeSetup:ghost];
            
        }
     }
    }
    
}
-(void)alignCostumes:(int)gn :(BOOL)animated{
    gn-=1;
    void (^setPosition)() = ^(){
        UIImageView*v=[self.spinnerCostumeCatImages objectAtIndex:gn];
        v.center=CGPointMake(v.center.x, HEIGHT/2);
        int j = 0;
        for(int i =gn-1;i>=0;i--){
            UIImageView*v=[self.spinnerCostumeCatImages objectAtIndex:i];
            j++;
            v.center=CGPointMake(v.center.x, HEIGHT/2-j*120);
        }
        j=0;
        for(int i =gn+1;i<=[[MTStorage getInstance]getGhostCount]-1;i++){
            UIImageView*v=[self.spinnerCostumeCatImages objectAtIndex:i];
            j++;
            v.center=CGPointMake(v.center.x, HEIGHT/2+j*120);
        }
    };
    if(animated) {
        [UIView animateWithDuration:0.2 animations:^{
            setPosition();
        }];
    }else{
        setPosition();
    }
    
}
-(void)alignCostumesColors:(int)gn :(BOOL)animated{
    gn-=1;
    
    void (^setPosition)() = ^(){
        
        UIImageView*v=[self.spinnerCostumeColorImages objectAtIndex:gn];
        v.center=CGPointMake(v.center.x, HEIGHT/2);
        int j = 0;
        for(int i =gn-1;i>=0;i--){
            UIImageView*v=[self.spinnerCostumeColorImages objectAtIndex:i];
            j++;
            v.center=CGPointMake(v.center.x, HEIGHT/2-j*120);
        }
        j=0;
        for(int i =gn+1;i<=8;i++){
            UIImageView*v=[self.spinnerCostumeColorImages objectAtIndex:i];
            j++;
            v.center=CGPointMake(v.center.x, HEIGHT/2+j*120);
        }
    };
    if(animated) {
        [UIView animateWithDuration:0.2 animations:^{
            setPosition();
        }];
    }else{
        setPosition();
    }
    
}


-(void)createAndShowCostumeColors:(int)ghostNumber :(int)ghostColorNumber{
    self.spinnerCostumeColorImages = [NSMutableArray array];
    
    
    if(self.spinnerCostumeColor){
        UIView* sc = self.spinnerCostumeColor;
        [UIView animateWithDuration:0.2 animations:^{
            [sc setFrame:CGRectMake(240, 0, 200,HEIGHT)];
            sc.alpha=0;
        } completion:^(BOOL y){
            [sc removeFromSuperview];
        }];
    }
    
    self.spinnerCostumeColor= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectimage.png"]];
    [self.spinnerCostumeColor setUserInteractionEnabled:YES];
    for(int i=1;i<=9;i++){
        NSString * n = [NSString stringWithFormat:@"D%d_C%d",ghostNumber,i];
        UIImageView* x=[[UIImageView alloc] initWithImage:[UIImage imageNamed:n]];
        [self.spinnerCostumeColorImages addObject:x];
        [self.spinnerCostumeColor addSubview:x];
        [x setFrame:CGRectMake(0, (i-1)*120+50, 100, 100)];
        [x setUserInteractionEnabled:YES];
        [x addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colorTap:)]];
    }
    [self alignCostumesColors:ghostColorNumber :NO];
    [self addSubview:self.spinnerCostumeColor];
    self.spinnerCostumeColor.alpha=0;
    [self.spinnerCostumeColor setFrame:CGRectMake(230, 0, 200,HEIGHT)];
    [UIView animateWithDuration:0.4 animations:^{
        [self.spinnerCostumeColor setFrame:CGRectMake(200, 0, 200,HEIGHT)];
        self.spinnerCostumeColor.alpha=1.0;
    } completion:^(BOOL y){
        
    }];
    
    
    
}

-(void)costumeTap:(UITapGestureRecognizer*)o{
    UIImageView* costumeView = (UIImageView*)o.view;
    [self costumeSetup:costumeView];
}
-(void)costumeSetup:(UIImageView*) costumeView{
    int x= [self.spinnerCostumeCatImages indexOfObject:costumeView];
    [self alignCostumes:x+1 :YES];
    self.ghostNumber=x+1;
    [self updateGhost];
    [self createAndShowCostumeColors:ghostNumber :ghostColorNumber];
    [self saveChanges];
}

-(void)colorTap:(UITapGestureRecognizer*)o{
    UIImageView* costumeView = (UIImageView*)o.view;
    [self colorSetup:costumeView];
}

-(void)colorSetup:(UIImageView*)costumeView{
    int x= [self.spinnerCostumeColorImages indexOfObject:costumeView];
    [self alignCostumesColors:x+1 :YES];
    self.ghostColorNumber=x+1;
    [self updateGhost];
    [self saveChanges];
}

-(void)saveChanges{
    NSString *selectedGhostVariant  = [NSString stringWithFormat:@"D%d_C%d",self.ghostNumber,self.ghostColorNumber];
    NSString *selectedGhostCat  = [NSString stringWithFormat:@"D%d_C1",self.ghostNumber];
    MTStorage *storage = [MTStorage getInstance];
    
    
    for(UIView* v in self.superview.subviews){
        if ([v isKindOfClass:[SKView class]]){
            s=(SKView* )v;
        }
    }

    //MTGhostIconNode *selectedIcon = [self findGhostIconForGhostMenuIcon:self.currentGhostIcon];
    MTGhost *selectedGhost = self.myGhost;
    
    
    //if([ghostCategory isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        // for(id key in storage.ghostCostumes)
        {
            //     if(key == ghostCategory.imgName)
            //        selectedGhost.costumeCat = key;
        }
        
        selectedGhost.costumeName =
        selectedGhostVariant;
        selectedGhost.costumeCat = selectedGhostCat;
        
        [selectedIcon repaintIcon:selectedGhostVariant];
        //[self.currentGhostIcon repaintIcon:selectedGhostVariant];
        
        MTSceneAreaNode *sceneAreaNode = (MTSceneAreaNode*)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"];
        
        for(int i = 0; i < selectedGhost.ghostInstances.count; i++){
            MTGhostInstance* mtgi = selectedGhost.ghostInstances[i];
            mtgi.costumeName=selectedGhostVariant;
            [sceneAreaNode refreshRepresentationNodeOfGhostInstance:mtgi];
        }
    }
    
    
}

-(void) updateGhost{
    NSString * postac = [NSString stringWithFormat:@"D%d_C%d.png",self.ghostNumber,self.ghostColorNumber];
    UIImage * postacimage =[UIImage imageNamed:postac];
    ((UIImageView*)[self.spinnerCostumeCatImages objectAtIndex:ghostNumber-1]).image= postacimage;
    
    self.ghostView.image=postacimage;
    
    NSString * mina = [NSString stringWithFormat:@"D%d_USMIECHNIETY_1.png",self.ghostNumber];
    UIImageView * minaimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:mina]];
    for (UIView* v in self.ghostView.subviews){
        [v removeFromSuperview];
    }
    [minaimage setFrame:CGRectMake(0, 0, 200, 200)];
    [self.ghostView addSubview:minaimage];
    
}

-(void)updaeZOrder{
    for(UIView * u in self.superview.subviews){
        if ([u isKindOfClass:[MTINMenuView class]]){
            [self.superview bringSubviewToFront:u];
        }
    }
}
-(void)showSmall{
    [self setFrame:CGRectMake(-944,000,944,HEIGHT)];
    [self updaeZOrder];
    UIImageView * y2= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toggle2.png"]];
    [self addSubview:y2];
    [y2 setFrame:CGRectMake(939, 0, y2.frame.size.width, y2.frame.size.height)];
    
    self.properframe=self.smallframe;
    
    
    self.alpha=0.;
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:self.properframe];
        self.alpha=1.;
    } completion:^(BOOL y){
        self.myGhostType = [myGhost.costumeName substringToIndex:[myGhost.costumeName rangeOfString:@"_"].location];
        self.ghostNumber = [[self.myGhostType substringFromIndex:1] intValue];
        NSString *gc = [myGhost.costumeName substringFromIndex:[myGhost.costumeName rangeOfString:@"_"].location];
        self.ghostColorNumber= [[[myGhost.costumeName substringFromIndex:[myGhost.costumeName rangeOfString:@"_"].location] substringFromIndex:2] intValue];
        
        self.myGhostCostumeName=myGhost.costumeName;
        
        self.ghostView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.myGhost.costumeName]];
        [self updateGhost];
        
        self.spinnerCostumeCatImages = [NSMutableArray array];
        self.spinnerCostumeCat= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectimage.png"]];
        self.spinnerCostumeCat.userInteractionEnabled=YES;
        for(int i=1;i<=[[MTStorage getInstance]getGhostCount];i++){
            NSString * n = [NSString stringWithFormat:@"D%d%@",i,gc];
            NSString * mina = [NSString stringWithFormat:@"D%d_USMIECHNIETY_1.png",i];
            UIImageView* x=[[UIImageView alloc] initWithImage:[UIImage imageNamed:n]];
            UIImageView* x2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:mina]];
            [x setUserInteractionEnabled:YES];
            [x addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(costumeTap:)]];
            [x addSubview:x2];
            x2.frame=CGRectMake(0, 0,100, 100);
            [self.spinnerCostumeCatImages addObject:x];
            [self.spinnerCostumeCat addSubview:x];
            [x setFrame:CGRectMake(0, (i-1)*120+50, 100, 100)];
        }
        [self alignCostumes:ghostNumber :NO];
        
        
        
        
        [self addSubview:self.ghostView];
        self.ghostView.alpha=0.0;
        [self.ghostView setFrame:CGRectMake(700, 284, 200, 200)];
        
        [self addSubview:self.spinnerCostumeCat];
        self.spinnerCostumeCat.alpha=0;
        [self.spinnerCostumeCat setFrame:CGRectMake(500, 0, 200,HEIGHT)];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.ghostView setFrame:CGRectMake(680, 284, 200, 200)];
            self.ghostView.alpha=1.0;
        } completion:^(BOOL y){
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.spinnerCostumeCat setFrame:CGRectMake(430, 0, 200,HEIGHT)];
                self.spinnerCostumeCat.alpha=1.0;
            } completion:^(BOOL y){
                [self createAndShowButtons];
                [self createAndShowCostumeColors:ghostNumber :ghostColorNumber ];
            }];
            
            
        }];
        
    }];
    
    
   // MTHelpView.helpScreen=hs_characters;
    

}
-(void)show{
     [self setFrame:CGRectMake(-900,000,44,HEIGHT)];
    [self updaeZOrder];
    UIImageView * y2= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toggle2.png"]];
    [self addSubview:y2];
    [y2 setFrame:CGRectMake(939, 0, y2.frame.size.width, y2.frame.size.height)];
    
    self.properframe=self.bigframe;
    
    self.alpha=0.;
    [UIView animateWithDuration:0.3 animations:^{
         [self setFrame:self.properframe];
        self.alpha=1.;
    } completion:^(BOOL y){
        self.myGhostType = [myGhost.costumeName substringToIndex:[myGhost.costumeName rangeOfString:@"_"].location];
        self.ghostNumber = [[self.myGhostType substringFromIndex:1] intValue];
        NSString *gc = [myGhost.costumeName substringFromIndex:[myGhost.costumeName rangeOfString:@"_"].location];
        self.ghostColorNumber= [[[myGhost.costumeName substringFromIndex:[myGhost.costumeName rangeOfString:@"_"].location] substringFromIndex:2] intValue];
        
        self.myGhostCostumeName=myGhost.costumeName;
        
        self.ghostView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.myGhost.costumeName]];
        [self updateGhost];
        
        self.spinnerCostumeCatImages = [NSMutableArray array];
        self.spinnerCostumeCat= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectimage.png"]];
        self.spinnerCostumeCat.userInteractionEnabled=YES;
        for(int i=1;i<=[[MTStorage getInstance]getGhostCount];i++){
            NSString * n = [NSString stringWithFormat:@"D%d%@",i,gc];
            NSString * mina = [NSString stringWithFormat:@"D%d_USMIECHNIETY_1.png",i];
            UIImageView* x=[[UIImageView alloc] initWithImage:[UIImage imageNamed:n]];
            UIImageView* x2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:mina]];
            [x setUserInteractionEnabled:YES];
            [x addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(costumeTap:)]];
            [x addSubview:x2];
            x2.frame=CGRectMake(0, 0,100, 100);
            [self.spinnerCostumeCatImages addObject:x];
            [self.spinnerCostumeCat addSubview:x];
            [x setFrame:CGRectMake(0, (i-1)*120+50, 100, 100)];
        }
        [self alignCostumes:ghostNumber :NO];
        
        
        
        
        [self addSubview:self.ghostView];
        self.ghostView.alpha=0.0;
        [self.ghostView setFrame:CGRectMake(700, 284, 200, 200)];
        
        [self addSubview:self.spinnerCostumeCat];
        self.spinnerCostumeCat.alpha=0;
        [self.spinnerCostumeCat setFrame:CGRectMake(500, 0, 200,HEIGHT)];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.ghostView setFrame:CGRectMake(680, 284, 200, 200)];
            self.ghostView.alpha=1.0;
        } completion:^(BOOL y){
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.spinnerCostumeCat setFrame:CGRectMake(430, 0, 200,HEIGHT)];
                self.spinnerCostumeCat.alpha=1.0;
            } completion:^(BOOL y){
                [self createAndShowButtons];
                [self createAndShowCostumeColors:ghostNumber :ghostColorNumber ];
            }];
            
            
        }];
        
    }];
    
    
    MTHelpView.helpScreen=hs_characters;
    
}


-(void)updateClone:(bool) allowed{
    //[self.myGhost setAllowedCoding:[_pcode_switch isOn]];
    if(allowed){
        self.cloneOneButton.alpha=1;
        self.cloneOneButton.userInteractionEnabled=true;
        self.cloneMultiButton.alpha=1;
        self.cloneMultiButton.userInteractionEnabled=true;
    }else{
        self.cloneOneButton.alpha=0.3;
        self.cloneOneButton.userInteractionEnabled=false;
        self.cloneMultiButton.alpha=0.3;
        self.cloneMultiButton.userInteractionEnabled=false;
    }
    
}
-(void)updateProperties:(bool) allowed{
    if(allowed){
        self.HP_PARAM.alpha=1;
        self.HP_PARAM.userInteractionEnabled=true;
        
        self.MASS_PARAM.alpha=1;
        self.MASS_PARAM.userInteractionEnabled=true;
        
        
        self.deleteButton.alpha=1;
        self.deleteButton.userInteractionEnabled=true;
        
    }else{
        self.MASS_PARAM.alpha=0.3;
        self.MASS_PARAM.userInteractionEnabled=false;
        self.HP_PARAM.alpha=0.3;
        self.HP_PARAM.userInteractionEnabled=false;
        
        self.deleteButton.alpha=0.3;
        self.deleteButton.userInteractionEnabled=false;
    }
}

-(void)changePCode:(id) sender{
    [self.myGhost setAllowedCoding:[_pcode_switch isOn]];
    [self saveChanges];
    }
-(void)changePMove:(id) sender{
    [self.myGhost setAllowedTouching:[_pmove_switch isOn]];
    [self saveChanges];
}
-(void)changePClone:(id) sender{
    [self.myGhost setAllowedClonning:[_pclone_switch isOn]];
    [self updateClone:[_pclone_switch isOn]];
    [self saveChanges];

}
-(void)changePProperties:(id) sender{
    [self.myGhost setAllowedOptions:[_pproperties_switch isOn]];
    [self updateProperties:[_pproperties_switch isOn]];
    [self saveChanges];

}

-(void)createAndShowButtons{
    
    //NOWE PRZYCZISK
    
    UIImageView * pclone = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"property_clone.png"]];
    UIImageView * pcode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"property_code.png"]];
    UIImageView * pproperties = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"property_properties.png"]];
    UIImageView * pmove = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"property_move.png"]];
    
    [pcode setCenter:CGPointMake(740, 100)];
    [pclone setCenter:CGPointMake(740, 150)];
    [pproperties setCenter:CGPointMake(740, 200)];
    [pmove setCenter:CGPointMake(740, 250)];
    
    
    [self addSubview:pcode];
    [self addSubview:pclone];
    [self addSubview:pproperties];
    [self addSubview:pmove];
    
    
    _pcode_switch = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
    _pcode_switch.center = CGPointMake(pcode.center.x+100, pcode.center.y);
    [_pcode_switch setOnTintColor:[UIColor redColor]];
    [_pcode_switch.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self addSubview:_pcode_switch];
     [_pcode_switch addTarget:self action:@selector(changePCode:) forControlEvents:UIControlEventValueChanged];
    
    _pclone_switch = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
    _pclone_switch.center = CGPointMake(pclone.center.x+100, pclone.center.y);
    [_pclone_switch setOnTintColor:[UIColor redColor]];
    [_pclone_switch.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self addSubview:_pclone_switch];
    [_pclone_switch addTarget:self action:@selector(changePClone:) forControlEvents:UIControlEventValueChanged];
   
    
    _pproperties_switch = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
    _pproperties_switch.center = CGPointMake(pproperties.center.x+100, pproperties.center.y);
    [_pproperties_switch setOnTintColor:[UIColor redColor]];
    [_pproperties_switch.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self addSubview:_pproperties_switch];
    [_pproperties_switch addTarget:self action:@selector(changePProperties:) forControlEvents:UIControlEventValueChanged];
    
    _pmove_switch = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
    _pmove_switch.center = CGPointMake(pmove.center.x+100, pmove.center.y);
    [_pmove_switch setOnTintColor:[UIColor redColor]];
    [_pmove_switch.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self addSubview:_pmove_switch];
    [_pmove_switch addTarget:self action:@selector(changePMove:) forControlEvents:UIControlEventValueChanged];
    
    
   
    
    
    ///
 cloneOneButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BTT_CLONE.png"]];
    cloneMultiButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BTT_MULTICLONE.png"]];
    deleteButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BTT_DELETEALL.png"]];
    
    
    

    HP_PARAM = [[MTParamView alloc]init:1];
    MASS_PARAM = [[MTParamView alloc]init:0];
    
    [HP_PARAM setTarget:self withSelector:@selector(setHPValue:)];
    [MASS_PARAM setTarget:self withSelector:@selector(setMASSValue:)];
    
    
    [deleteButton setFrame:CGRectMake(728, 204, 103, 39)];
    [cloneOneButton setFrame:CGRectMake(648, 504, 103, 39)];
    [cloneMultiButton setFrame:CGRectMake(788, 504, 103, 39)];

    HP_PARAM.center= CGPointMake(deleteButton.center.x+10, deleteButton.center.y+170);
    MASS_PARAM.center= CGPointMake(deleteButton.center.x+10, deleteButton.center.y+230);
    
    [self addSubview:cloneMultiButton];
    [self addSubview:cloneOneButton];
    [self addSubview:deleteButton];
    
    [self addSubview:HP_PARAM];
    [self addSubview:MASS_PARAM];
    
    
    [deleteButton setUserInteractionEnabled:YES];
    [cloneOneButton setUserInteractionEnabled:YES];
    [cloneMultiButton setUserInteractionEnabled:YES];
    
    [deleteButton setAlpha:0.];
    [cloneOneButton  setAlpha:0.];
    [cloneMultiButton  setAlpha:0.];
    
    [HP_PARAM  setAlpha:0.];
    [MASS_PARAM  setAlpha:0.];
    
    [HP_PARAM setV:[self.myGhost getIntHP]];
    [MASS_PARAM setV:self.myGhost.mass];
    
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [deleteButton setCenter:CGPointMake(_pcode_switch.center.x-50, _pcode_switch.center.y-50)];
        [cloneOneButton setFrame:CGRectMake(648, 524, 103, 39)];
        [cloneMultiButton setFrame:CGRectMake(788, 524, 103, 39)];
        [deleteButton setAlpha:1.];
        [cloneOneButton  setAlpha:1.];
        [cloneMultiButton  setAlpha:1.];
        [HP_PARAM  setAlpha:1.];
        [MASS_PARAM  setAlpha:1.];
        
        HP_PARAM.center= CGPointMake(HP_PARAM.center.x, HP_PARAM.center.y+230);
        MASS_PARAM.center= CGPointMake(MASS_PARAM.center.x, MASS_PARAM.center.y+230);
        [_pcode_switch setOn:[self.myGhost getAllowedCoding]];
        [_pmove_switch setOn:[self.myGhost getAllowedTouching]];
        [_pproperties_switch setOn:[self.myGhost getAllowedOptions]];
        [_pclone_switch setOn:[self.myGhost getAllowedClonning]];
        
        [self updateClone:[self.myGhost getAllowedClonning]];
        [self updateProperties:[self.myGhost getAllowedOptions]];
    }];
    [cloneOneButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addOneInstance)]];
    [cloneMultiButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMultiInstace)]];
    [deleteButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAllInstances:)]];
    
    
    
    
    
    
    
    
}

-(void)setHPValue:(MTParamView*)pv{
    ////NSLog(@"setting HP: %d",pv.getV);
    [self.myGhost setIntHP:pv.getV];
//    *(self.myGhost.hp)=pv.getV;
}
-(void)setMASSValue:(MTParamView*)pv{
    ////NSLog(@"setting MASS: %d",pv.getV);
    for(UIView* v in self.superview.subviews){
        if ([v isKindOfClass:[SKView class]]){
            s=(SKView* )v;
        }
    }
    MTSceneAreaNode *sceneAreaNode = (MTSceneAreaNode*)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"];
    
    self.myGhost.mass = pv.getV;

    for(int i = 0; i < self.myGhost.ghostInstances.count; i++){
        MTGhostInstance* mtgi = self.myGhost.ghostInstances[i];
        [sceneAreaNode refreshMassNodeOfGhostInstance:mtgi andMass:self.myGhost.mass];
    }
}

-(void)hide{
  
    
    @try {
        [self removeFromSuperview];
        [MTHelpView revert];
    }
    @catch (NSException * e) {
        ////NSLog(@"Exception: %@", e);
    }
    @finally {
      
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesBegan1:touches withEvent:event];
    CGPoint  dotyk = [(UITouch*)[touches anyObject] locationInView:self.superview];
    start = dotyk;
    startpos = self.frame.origin;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved1:touches withEvent:event];
        CGPoint  dotyk = [(UITouch*)[touches anyObject] locationInView:self.superview];
        float r = dotyk.x-start.x;
    ////NSLog(@"DSDS>>START:(%f), r: %f",startpos.x,r);//)if(r>0){
    //if(startpos.x+r>startpos.x){
        //self.center=CGPointMake(startpos.x+r/2,startpos.y);
        //[self setClipsToBounds:YES];
    if(startpos.x+r/2<0){
    self.frame=CGRectMake(startpos.x+r/2,self.frame.origin.y,944,self.frame.size.height);
    }
    //}else{
     //   start = dotyk;
     //   startpos = self.frame.origin;
    //}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded1:touches withEvent:event];
        CGPoint  dotyk = [(UITouch*)[touches anyObject] locationInView:self.superview];
    float r = dotyk.x-start.x;
    if(r<-100){
            if(self.frame.origin.x>-630){
                self.properframe=self.smallframe;
                [self updatePosition];
            }else{
                [self updatePosition];
                //[self removeFromParent ];
            }
        
    }else{
        if(r>100){
            self.properframe=self.bigframe;
            [self updatePosition];
        }else{
            [self updatePosition];
        }
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded1:touches withEvent:event];
    [self updatePosition];
}
-(void)removeFromParent:(UISwipeGestureRecognizer*)g{
    ////NSLog(@"STATE: %ld", g.state);
    if(g.state==UIGestureRecognizerStateEnded){
        [self removeFromParent];
    }
}
-(BOOL)isShown{
    if(self.frame.origin.x>-101){
        return true;
    }
    return false;
}
-(void)removeFromParent{
    if (!self.removed){
        self.removed=YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(-955,000,43,HEIGHT)];
            //[self setClipsToBounds:YES];
            self.alpha=0.0;
            
        } completion:^(BOOL b){
            [self hide];
        }];
    }
}

-(void)updatePosition{
//    if (!self.removed){
  //      self.removed=YES;
        
        [UIView animateWithDuration:0.1 animations:^{
            [self setFrame:self.properframe];
             //self.alpha=0.0;
            
        } ];
    //}
}

-(void) addOneInstance
{
    
    for(UIView* v in self.superview.subviews){
        if ([v isKindOfClass:[SKView class]]){
            s=(SKView* )v;
        }
    }

    [(MTGhostsBarNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] hideBar];
    [(MTSceneAreaNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] addOneCloneModeOn];
    
    if(HEIGHT==1024)//ipadpro
    {
        self.properframe=self.smallframe;
        [self updatePosition];
    }else{
        [self removeFromParent];
    }
}

-(void) addMultiInstace
{
    
    for(UIView* v in self.superview.subviews){
        if ([v isKindOfClass:[SKView class]]){
            s=(SKView* )v;
        }
    }

    [(MTGhostsBarNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] hideBar];
    //[(MTSceneAreaNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    [(MTSceneAreaNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] addMultiCloneModeOn];
    if(HEIGHT==1024)//ipadpro
    {
        self.properframe=self.smallframe;
        [self updatePosition];
    }else{
        [self removeFromParent];
    }
}

-(void) deleteAllInstances:(UITapGestureRecognizer*)sender
{
    [sender.view removeFromSuperview];
    for(UIView* v in self.superview.subviews){
        if ([v isKindOfClass:[SKView class]]){
            s=(SKView* )v;
        }
    }

    [(MTSceneAreaNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    
    //okienko usuwania
    MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.3 andWaitTime:0.0];
    MTWindowAlert *alert = [[MTWindowAlert alloc] initRemoveAllClones];
    alert.background = background;
    [((MTSceneAreaNode *)[[s.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]) addChild:alert];
    
    if(HEIGHT==1024)//ipadpro
    {
        self.properframe=self.smallframe;
        [self updatePosition];
    }else{
        [self removeFromParent];
    }
}
@end
