//
//  MCMCircleGradient.m
//  MCMTouchAnimation
//
//  Created by Mathias on 27/09/13.
//  Copyright (c) 2013 shoock. All rights reserved.
//

#import "MCMCircleGradient.h"
#import <QuartzCore/QuartzCore.h>

@interface MCMCircleGradient()

@property (nonatomic) UIImageView *escudo;

@end

@implementation MCMCircleGradient

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.contents = (__bridge id)([[self generateRadial]CGImage]);
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andEscudo:(BOOL)isEscudo
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (isEscudo)
        {
            // Creo la imagen y la agrego
            self.escudo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"escudo.png"]];
            [self addSubview:self.escudo];
        }
        else
            self.layer.contents = (__bridge id)([[self generateRadial]CGImage]);
        
    }
    return self;
}

-(UIImage*)generateRadial
{
    
    //Define the gradient ----------------------
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t locations_num = 5;
    CGFloat locations[5] = {0.0,0.4,0.5,0.6,1.0};
    CGFloat components[20] = {  1.0, 0.0, 0.0, 0.2,
        1.0, 0.0, 0.0, 1,
        1.0, 0.0, 0.0, 0.8,
        1.0, 0.0, 0.0, 0.4,
        1.0, 0.0, 0.0, 0.0
    };
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, locations_num);
    
    
    //Define Gradient Positions ---------------
    
    //We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    //Start point
    startPoint.x = self.frame.size.width/2;
    startPoint.y = self.frame.size.height/2;
    
    //End point
    endPoint.x = self.frame.size.width/2;
    endPoint.y = self.frame.size.height/2;
    
    //Generate the Image -----------------------
    //Begin an image context
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    //Use CG to draw the radial gradient into the image context
    CGContextDrawRadialGradient(imageContext, gradient, startPoint, 0, endPoint, self.frame.size.width/2, 0);
    //Get the image from the context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark -Animation
// Creo el efecto de esfumecido inicial y se lo asigno al layer, cuando esta funcion se llama, la animacion comienza
-(void)fadeIn
{
    
    // Defino la pripiedad con la que quiero trabajar
    CABasicAnimation *fadein = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    // Seteo los valores inicial y final
    fadein.fromValue = [NSNumber numberWithInt:0];
    fadein.toValue = [NSNumber numberWithInt:1];
    
    // Seteo la duracion de la animacion
    fadein.duration = 0.3;
    
    // Agrego la anomacion al layer, para la clave "fade"
    [self.layer addAnimation:fadein forKey:@"fade"];
}

// Creo el efecto final de esfumecido
-(void)fadeOut
{
    
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // Seteo las propiedades
    fadeout.delegate = self;
    fadeout.fromValue = [NSNumber numberWithInt:1.0];
    fadeout.toValue = [NSNumber numberWithInt:0];
    fadeout.duration = 0.2;
    // Para que no vuelva a aparecer cuando finalice la animacion
    fadeout.fillMode = kCAFillModeForwards;
    fadeout.removedOnCompletion = NO;
    // Agrego la animacion
    [self.layer addAnimation:fadeout forKey:@"fade"];
    
}

@end
