//
//  MTButtonList.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 30.07.2015.
//  Copyright © 2015 UMK. All rights reserved.
//
#define MAX(a,b) ( ((a) > (b)) ? (a) : (b) )
#import "MTButtonList.h"
#import "MTGUI.h"

@interface MTButtonList (){
    CGPoint start;
    CGFloat offset;
}
@property NSMutableArray* list;
@property NSMutableArray* buttons;
@property (strong) void(^askformore)(MTButtonList*,int);
@property int lastdisplayed;
@property int page;
@property BOOL enabled;
@property int asked;
@property NSMutableArray* tmp_buttons;

@end


@implementation MTButtonList
@synthesize tmp_buttons;
@synthesize page;
@synthesize enabled;
@synthesize asked;
@synthesize delegate;
@synthesize askformore;
@synthesize showDownloadAll;
@synthesize lastdisplayed;

-(void)clear{
    //NSLog(@"there is %@ list", _buttons);
    //NSLog(@"there is %lu buttons out there", (unsigned long)[_buttons  count]);
}
-(void)invalidate{
    for (NSMutableDictionary * scene_dictionary in _list){
        //NSLog(@"Scene_dictionary has button: %@", scene_dictionary[@"delegate"]);
        if(scene_dictionary[@"delegate"]!=nil){
        scene_dictionary[@"delegate"]=nil;
        }
    }
    
    //NSLog(@"there is %@ list", _buttons);
    //NSLog(@"USUWANIE LISTY");
    for (MTNewSceneButton * b in _buttons){
        
        //NSLog(@"there is %@ list", _buttons);
        //NSLog(@"Removing utton: %@",b);
        //NSLog(@"there LEFT %lu buttons out there", (unsigned long)[b.superview.subviews count]);
        [b prepareToRemove];
        [b removeFromSuperview];
        [b invalidate];
        //[_buttons removeObject:b];
        

    }
    [_buttons removeAllObjects];
    _buttons = nil;
}


-(void)showList{
    [self showListWithDelegate:self.delegate];
}

-(void)showListWithDelegate:(id) delegat
{
    self.delegate = delegat;
    ////NSLog(@"Showing : %d from button list",_list.count);
    for (int i = lastdisplayed;i<_list.count;i++){
        if ([((NSDictionary*)_list[i]) count]>0){
        
        MTNewSceneButton* b = [[MTNewSceneButton alloc]initWithScene:_list[i]];
        [_buttons addObject:b];
        b.delegate=self;
        b.buttonsdelegate = delegat;
        [b showButtons];
        if(self.enabled){[b setEnabled];}else{[b setDisabled];}
        //b.alpha=0;
        [self addSubview:b];
        lastdisplayed++;
        }
        
    }
    self.alpha=1;
    [self position:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    }];
    [self setUserInteractionEnabled:YES];
    
    if(showDownloadAll){
        UIImageView* u =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downloadall"]];
        [self addSubview:u];
        u.center=CGPointMake(-25, 25);
        [u setUserInteractionEnabled:YES];
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    start = [[touches anyObject] locationInView:self];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint current  = [[touches anyObject] locationInView:self];
    CGFloat dif= current.x - start.x;
    start = [[touches anyObject] locationInView:self];

    offset-=dif;
    if(offset<0){
        offset=offset/2;
    }
    [self position];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self align];
}

-(void)align{
    offset = floor( (offset+100)/100)*100;
    [UIView animateWithDuration:0.3 animations:^{
        [self position];
    }];
}
-(void)position{
    [self position:YES];
}
-(void)position:(BOOL)animated{
    int i =0;
    
    for (  MTNewSceneButton* b in _buttons){
        int x = 0;
        
        [b setNewPosition:CGPointMake(161+100*(i++)-offset,20) animated:animated];
        
        if(i==_buttons.count && 161+100*(i)-offset < 1000 && asked!=1+page){
            //popros o nastepny fragment listy...
            if(askformore!=nil){
                asked = page+1;
                [self performSelector:@selector(incPage) withObject:nil afterDelay:1.0];
                askformore(self,asked);
            }
        }
    }
    
}
-(void)incPage{
    ++page;
}
-(void)updateList:(NSArray*)list{
    ////NSLog(@"Adding %d new elements (%d total)",list.count,_list.count+list.count);
    [_list addObjectsFromArray:list];
    [self showList];
}

-(void)removeButton:(NSMutableDictionary*)tdg{
    MTNewSceneButton* b  = tdg[@"delegate"];
    for (NSDictionary* e in self.list){
        if ([e[@"file"] isEqual:tdg[@"file"]]){
            [self.list removeObject:e];
            break;
        }
    }
    [self.list removeObject:tdg];
    [self.buttons removeObject:b];
    [UIView animateWithDuration:0.3 animations:^{
    [self updateList:[NSArray array]];
    }];
}

-(id)initWithList:(NSArray*)list{
    self = [self initWithList:list andAFM:nil];
    asked = 0;
    showDownloadAll=FALSE;
    return self;
}
-(id)initWithList:(NSArray*)list andAFM:(void(^)(MTButtonList*,int))afm{
    self = [super initWithFrame:CGRectMake(0, 80, WIDTH, HEIGHT)];
    showDownloadAll=FALSE;
    self.enabled=true;

    self.askformore=afm;
    _list=[NSMutableArray arrayWithArray:list];
    _buttons= [NSMutableArray array];
    //[self showList];
    lastdisplayed=0;
    page=0;
    
    
    
    UITapGestureRecognizer* tg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tg.numberOfTapsRequired=3;
    [self addGestureRecognizer:tg];
    
    return self;
}
-(void)tapped{
    
}
-(void)tapped:(UIGestureRecognizer*)g{
    
    [UIView animateWithDuration:0.1 animations:^{
        g.view.center=CGPointMake(-125, 25);
    }];
    void(^cb)(void) = ^{
        if(tmp_buttons.count>0){
            MTNewSceneButton* b = [tmp_buttons firstObject];
            [tmp_buttons removeObjectAtIndex:0];
            [b downloadWithCallback:^{
                [self tapped:g];
            }] ;
        }
    };
    
    //////NSLog(@"tripple tap!!!!!!");
    if (tmp_buttons == nil){
        tmp_buttons =[NSMutableArray arrayWithArray:_buttons];
        cb();//start downloadning
    }else{
        if ([tmp_buttons count]==0){
            //koniec
            tmp_buttons=nil;
        }else{
            cb();
        }
    }
    
    

   // cb();

}

-(void)resetButtons{
    
    for (  MTNewSceneButton* b in _buttons){
        [b reset];
    }
}


-(void)setEnabled{
    self.enabled=true;
    for (  MTNewSceneButton* b in _buttons){
        [b setEnabled];
    }
}
-(void)setDisabled{
    self.enabled=false;
    for (  MTNewSceneButton* b in _buttons){
        [b setDisabled];
    }
}

-(void)resetButtons:(CGFloat)point{
    if(point>440){
        offset+=(point-450);
    }else if(point<100){
        offset+=(point-250);
    }
       [self align];
}
@end
