
// TODO: Make this protocol general since we'll need it for images selection too.
@protocol CopyLabelDelegate <NSObject>

-(void) didStartSelect;
-(void) didEndSelect;

@end

@interface CopyLabel : UILabel

@property (nonatomic, assign) id delegate;

@end
