//
//  VKTextField.h
//  BOA.IOS.MobileBranch
//
//  Created by Doruk Kaan Bolu on 12.06.2019.
//  Copyright © 2019 Vakıf Katılım. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VKTextFieldDelegate;


typedef NS_ENUM(NSInteger, VKTextFieldTextType) {
    VKTextFieldTextTypeDefault,
    VKTextFieldTextTypeInteger,
    VKTextFieldTextTypeDecimal,
    VKTextFieldTextTypeAlpha,
    VKTextFieldTextTypeMoneyNoDecimal,
    VKTextFieldTextTypeMoney,
  VKTextFieldTextTypePhone
};

IB_DESIGNABLE
@interface VKTextField : UIView<UITextFieldDelegate> {
    BOOL placeholderPosition; // 0: normal 1:top
    NSString *originalText;
}

@property (strong, nonatomic) id<VKTextFieldDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *contentView;

//ui controls
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *vUnderline;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIImageView *imgInfo;
@property (weak, nonatomic) IBOutlet UIView *vImgTapArea;

//constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPlaceholderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPlaceholderToUnderline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constErrorToUnderline;
@property (weak, nonatomic) IBOutlet UIImageView *arrowDownImage;


//members

@property (nullable, strong, nonatomic) NSString* text;
@property (nullable, strong, nonatomic) NSString* placeholderText;
@property (nullable, strong, nonatomic) NSString* errorText;
@property (nullable, strong, nonatomic) NSString* warningText;
@property (strong, nonatomic) UIColor* underlineColor;
@property (strong, nonatomic) UIColor* textColor;
@property (nullable,strong, nonatomic) UIColor* placeholderColor;
@property (strong, nonatomic) UIColor* errorTextColor;
@property (strong, nonatomic) NSString* fontName;
@property (strong, nonatomic) NSString* placeholderFontName;
@property (strong, nonatomic) NSString* errorFontName;
@property (nonatomic) BOOL secureTextEntry;
@property (nonatomic) VKTextFieldTextType textType;
@property (nonatomic) int maxCharacterLength;
@property (nonatomic) BOOL showInfoIcon;
@property (strong, nonatomic) NSString *fecCode;
-(void) setPlaceholderPosition:(int)position;
@end

@protocol VKTextFieldDelegate <NSObject>

-(BOOL)vkTextField:(VKTextField *)vkTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)vkTextField:(VKTextField*)vkTextField DidChange:(NSString*)text;
-(void)vkTextFieldInfoIconTapped:(VKTextField*)vkTextField;
-(void)vkTextField:(VKTextField*)vkTextField DidEndEditing:(NSString*)text;


@end

