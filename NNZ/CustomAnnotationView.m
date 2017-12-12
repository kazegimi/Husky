//
//  CustomAnnotationView.m
//  NNZ
//
//  Created by Eiichi Hayashi on 2017/12/12.
//  Copyright © 2017年 skyElements. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _annotationView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:_annotationView];
    }
    return self;
}

@end
