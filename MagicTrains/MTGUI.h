//
//  MTGUI.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 10.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

/*Miejsce na stale uzywane w GUI*/


#define iPadPro ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [UIScreen mainScreen].bounds.size.height == 1366)

#define WIDTH [UIScreen mainScreen].bounds.size.width//1024
#define HEIGHT [UIScreen mainScreen].bounds.size.height//768

#define MAXFORX WIDTH/2
#define MAXFORY HEIGHT/2

#define CZY_ANIMACJA_ZAZNACZENIA true

#define GHOST_BAR_WIDTH 80
#define GHOST_ICON_WIDTH 75
#define GHOST_ICON_HEIGHT 75

#define CATEG_BAR_WIDTH 80
#define CODE_AREA_WIDTH (WIDTH - GHOST_BAR_WIDTH - CATEG_BAR_WIDTH)
#define CODE_AREA_MAX_HEIGHT HEIGHT * 4

#define BLOCK_WIDTH 100
#define BLOCK_HEIGHT 100

#define TRACK_WIDTH 100
#define TRACK_HEIGHT (BLOCK_WIDTH +5)

#define BLOCK_AREA_WIDTH 451
#define BLOCKS_AREA_NODE_WIDTH 451

#define TAB_HEIGHT 50

#define DEAD_ZONE_GESTURE 100

#define TIME_DIVISOR 10 /* dzielnik czasu dla wagonow - pomaga przy wartosci w kole (wartosc w kole [0..10] -> [0/TIME_DIVISOR .. 10/TIME_DIVISOR]*/


#define COLOR_DELIVER 8
#define CLONE_TAB 3 /*numer taba w CodeArea przeznaczony dla klonow - pociagi z tego taba wykonywane sa tylko przez klony uzytkownika*/

#define MAX_REAL_GHOST_REP 99999
#define MAX_CLONE_GHOST_REP 99999

#define ANIMATIONS 1 /*Czy efekty GUI maja byc wlaczone? np przyciemnianie ekranu MOZLIWE USTAWIENIA 0 lub 1*/
#define GHOST_EFFECT_NODE 1 /*Tymczasowa zmienna - zeby nie bylo zbyt brzydko na scenie ;) */

//wartosci min i max dla poszczegolnych wagonow = losowanie zmiennej "losowej", zakres wartosci

//wagony idz o jakas wartosc
#define MIN_GO_DISTANCE 0.0
#define MAX_GO_DISTANCE 100.0

//czas w wagonach
#define MIN_CART_TIME 0
#define MAX_CART_TIME 10

//katy
#define MIN_ANGLE_VALUE 0
#define MAX_ANGLE_VALUE 360
//powiekszenie
#define MIN_RESIZE_VALUE 0
#define MAX_RESIZE_VALUE 100

//GOXY cart
#define MIN_X_VALUE_GOXYCART -512
#define MAX_X_VALUE_GOXYCART 512

#define MIN_Y_VALUE_GOXYCART -384
#define MAX_Y_VALUE_GOXYCART 384

//petla loop
#define MIN_LOOP_VALUE 0
#define MAX_LOOP_VALUE 50

//warunek if
#define MIN_X_IF_VALUE -999
#define MAX_X_IF_VALUE 999

#define MIN_Y_IF_VALUE -999
#define MAX_Y_IF_VALUE 999

//pause
#define MIN_PAUSE_VALUE 0
#define MAX_PAUSE_VALUE 20

//wagony logiki zmiana wartosci zmiennej globalnej
#define MIN_GLOBAL_VALUE -999
#define MAX_GLOBAL_VALUE 999

//koniec bloku dla zakresow losowania zmiennych globalnych

//powiadomienia o stanie GUI

#define N_MTMainSceneDidInit @"MainScene did init"

//Ilość kategorii bloczków (pociągu, ruch itd...)
#define BLOCKS_CATEGORIES_COUNT 6


static CGFloat FRAME_TIME=0.01666666666667;



