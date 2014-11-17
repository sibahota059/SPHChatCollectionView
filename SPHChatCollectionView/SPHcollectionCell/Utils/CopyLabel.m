#import "CopyLabel.h"

@implementation CopyLabel

#pragma mark Initialization

- (void) attachTapHandler
{
    [self setUserInteractionEnabled:YES];
    UIGestureRecognizer *touchy = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:touchy];
    //[touchy release];
}

- (id) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame:frame])
    {
        [self attachTapHandler];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

#pragma mark Clipboard

- (void) copy: (id) sender
{
    if (self.text.length)
    {
        UIPasteboard.generalPasteboard.string = self.text;
    }
    
    //NSLog(@"Copy handler, label: “%@”.", self.text);
}

-(void)didHideMenu
{
    if ([self.delegate respondsToSelector:@selector(didEndSelect)])
    {
        [self.delegate didEndSelect];
    }
    
	//remove the observer from the NSNotificationCenter, we only want to call didHideMenu once
	[NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIMenuControllerDidHideMenuNotification
                                                object:nil];
    

}

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    return (action == @selector(copy:));
}

- (void) handleLongPress: (UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didStartSelect)])
    {
        [self.delegate didStartSelect];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didHideMenu)
                                               name:UIMenuControllerDidHideMenuNotification
                                             object:nil];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
