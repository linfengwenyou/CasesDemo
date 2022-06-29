//
//  KGPlayViewBackModeAlert.m
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "KGPlayViewBackModeAlert.h"
#import "UIView+Frame.h"
#import "KGPlayViewBackModeCell.h"
#import "KGPlayViewBackModeSwithchCell.h"
#import "KGPlayViewBackModel.h"

// 主视图信息
#define pMainViewHeight 255.f
#define pMainViewWidth 320.f

@interface KGPlayViewBackModeAlert ()<UITableViewDelegate, UITableViewDataSource>
// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;
// 容器视图
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UITableView *tableView;
/* 是否正在消失 */
@property (nonatomic,assign) BOOL isDismissing;

@property (nonatomic, strong) NSArray *dataSource;

/*当前选中的类型*/
@property (nonatomic, assign) KGPlayViewBackModelType currentType;
@end


@implementation KGPlayViewBackModeAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - 23 - pMainViewHeight);
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - pMainViewWidth) / 2.0f;
        
        self.normalFrame = CGRectMake(x , y , pMainViewWidth, pMainViewHeight);
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    // 创建一个子视图
    [self registerCell];
    
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.tableView];
    
    self.dataSource = [KGPlayViewBackModel getAllModeModels];
    self.currentType = KGPlayViewBackModelType_Rotate;
    
    [self.tableView reloadData];
//    self.mainView
}


#pragma mark - delegate & datasource

#pragma mark - register cell
- (void)registerCell {
    
    [self.tableView registerClass:KGPlayViewBackModeCell.class forCellReuseIdentifier:NSStringFromClass(KGPlayViewBackModeCell.class)];
    [self.tableView registerClass:KGPlayViewBackModeSwithchCell.class forCellReuseIdentifier:NSStringFromClass(KGPlayViewBackModeSwithchCell.class)];
}


#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;   // 最后一个是开关
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataSource.count) {
        KGPlayViewBackModeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KGPlayViewBackModeCell.class)];
        
        KGPlayViewBackModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.model = model;
        cell.currentSelect = model.tye == self.currentType;
        return cell;
    } else {
        KGPlayViewBackModeSwithchCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KGPlayViewBackModeSwithchCell.class)];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KGPlayViewBackModeCell cellHeight];
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击:%ld",indexPath.row);
    if (indexPath.row < self.dataSource.count) {
        KGPlayViewBackModel *model = [self.dataSource objectAtIndex:indexPath.row];
        self.currentType = model.tye;
        [self.tableView reloadData];
    }
}

#pragma mark - 显示隐藏动画效果
- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.shrinkedFrame = shrinkedFrame;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.center = shrinkedCenter;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
        self.mainView.center = normalCenter;
    }];
    
}


- (void)dismiss {
    if (self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformIdentity;
    self.mainView.center = normalCenter;
    NSLog(@"%@",[NSValue valueWithCGPoint:normalCenter]);
    [UIView animateWithDuration:0.5f animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
        self.mainView.center = shrinkedCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isDismissing = NO;
    }];
}

// 点击空白区域需要隐藏
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.mainView.frame, point)) {
        [self dismiss];
    }
}


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 15.0f;
        _mainView.clipsToBounds = YES;
        _mainView.backgroundColor = UIColor.blackColor;
    }
    return _mainView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.normalFrame.size.width, self.normalFrame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
@end
