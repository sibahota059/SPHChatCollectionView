//
//  SPHViewController.h
//  SPHChatCollectionView
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *sphBubbledata;
    
    BOOL isfromMe;
}

@property (weak, nonatomic) IBOutlet UICollectionView *sphChatTable;
@property (weak, nonatomic) IBOutlet UIView *msgInPutView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

- (IBAction)sendMessageNow:(id)sender;
@end
