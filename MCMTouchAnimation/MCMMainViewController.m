//
//  MCMMainViewController.m
//  MCMTouchAnimation
//
//  Created by Mathias on 27/09/13.
//  Copyright (c) 2013 shoock. All rights reserved.
//

#import "MCMMainViewController.h"
#import "MCMCircleGradient.h"

@interface MCMMainViewController ()

@property (nonatomic) MCMCircleGradient* gradientView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedControlImagen;

- (IBAction)ActionCambiarImagen:(id)sender;

@end

@implementation MCMMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Agrego el circulo
    CGFloat x = (self.view.frame.size.width / 2) - 100;
    CGFloat y = (self.view.frame.size.height / 2) - 100;
    self.gradientView = [[MCMCircleGradient alloc]initWithFrame:CGRectMake(x, y, 200, 200)];
    //self.gradientView = [[MCMCircleGradient alloc]initWithFrame:CGRectMake(0, 0, 128, 128) andEscudo:YES];
    
    [self.view addSubview:self.gradientView];
    
    // Agrego el gesto de toque
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(screenPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Gesture
// Maneja el desplazamiento
- (void)screenPan:(UIGestureRecognizer *)gesture
{
    
    //Get the location of the touch
    CGPoint point = [gesture locationInView:self.view];
    
    // Muevo el centro del circulo si el gesto es Comienzo(Bega) o Cambio(Changed)
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        self.gradientView.center = point;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        // Lanzo el fadeOut si el gesto es final
        [self.gradientView fadeOut];
    }
    
}

// Manega el primer toque
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // Obtengo cualquier toque y de este la posicion en pantalla para centrar el circulo
    UITouch *touch = [touches anyObject];
    CGPoint drawPoint = [touch locationInView:self.view];
    
    //Change gradientView center and launch fadeIn animation
    self.gradientView.center = drawPoint;
    
    // Comienzo la animacion del circulo
    [self.gradientView fadeIn];
}

// Maneja el ultimo toque
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Comienzo la animacion de ocultar el circulo
    [self.gradientView fadeOut];
}

- (IBAction)ActionCambiarImagen:(id)sender
{
    // Obtengo el UISegmentedControl
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    NSString *seleccionado = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    
    // Elimino el actual, recorro si pertenece a la clase del circulo,
    // remuevo la subview del padre, osea de esta view
    for (UIView *subView in self.view.subviews)
        if ([subView isKindOfClass:[MCMCircleGradient class]])
            [subView removeFromSuperview];
    
    // Creo la nueva vista, dependiendo de si es circulo a escudo lo seleccionado
    if ([seleccionado isEqualToString:@"Circulo"])
    {
        CGFloat x = (self.view.frame.size.width / 2) - 100;
        CGFloat y = (self.view.frame.size.height / 2) - 100;
        self.gradientView = [[MCMCircleGradient alloc]initWithFrame:CGRectMake(x, y, 200, 200)];
    }
    else
    {
        CGFloat x = (self.view.frame.size.width / 2) - 64;
        CGFloat y = (self.view.frame.size.height / 2) - 64;
        self.gradientView = [[MCMCircleGradient alloc]initWithFrame:CGRectMake(x, y, 128, 128) andEscudo:YES];
    }
    
    // Agrego nuevamente la vista
    [self.view addSubview:self.gradientView];

}

@end
