//
//  CustomAnnotationView.h
//  NNZ
//
//  Created by Eiichi Hayashi on 2017/12/12.
//  Copyright © 2017年 skyElements. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "AnnotationView.h"

@interface CustomAnnotationView : MKAnnotationView

@property (nonatomic) AnnotationView *annotationView;

- (void)changeTextColorWithColor:(UIColor *)color;

@end
