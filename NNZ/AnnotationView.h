//
//  AnnotationView.h
//  NNZ
//
//  Created by Eiichi Hayashi on 2017/12/12.
//  Copyright © 2017年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
