//
//  GameViewController.m
//  2048Game
//
//  Created by 李锐 on 2017/2/21.
//  Copyright © 2017年 lirui. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic,copy) NSMutableArray * colorArray; //存放颜色的数组
@property (nonatomic,copy) NSMutableArray * squareArray; //存放方块的数组

//上下左右滑动存放数据的数组
@property (nonatomic,copy) NSMutableArray * leftArray;
@property (nonatomic,copy) NSMutableArray * rightArray;
@property (nonatomic,copy) NSMutableArray * upArray;
@property (nonatomic,copy) NSMutableArray * downArray;

@property (nonatomic,strong) UILabel * label_2048;
@property (nonatomic,strong) UILabel * label_way;
@property (nonatomic,strong) UIButton * replay_game;

@property (nonatomic,strong) UILabel * label_score;
@property (nonatomic,strong) UILabel * label_maxScore;

@property (nonatomic,strong) UIView * groundView;
@property (nonatomic,strong) NSString * documentPath;

@property (nonatomic,assign) NSInteger score;
@property (nonatomic,assign) NSInteger maxScore;

@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,assign) CGFloat side;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:234/255.0 alpha:1];
    
    self.label_2048 = [[UILabel alloc]init];
    self.label_2048.translatesAutoresizingMaskIntoConstraints = false;
    self.label_2048.text = @"2048";
    self.label_2048.font = [UIFont boldSystemFontOfSize:72.0f];
    self.label_2048.textColor = [UIColor colorWithRed:60/255.0 green:58/255.0 blue:50/255.0 alpha:1];
    [self.view addSubview:self.label_2048];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label_2048(200)]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"label_2048":self.label_2048}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label_2048(100)]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"label_2048":self.label_2048}]];
    
    
    self.replay_game = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.replay_game.translatesAutoresizingMaskIntoConstraints = false;
    self.replay_game.backgroundColor = [UIColor orangeColor];
    [self.replay_game setTitle:@"新游戏" forState:UIControlStateNormal];
    [self.replay_game setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replay_game.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    self.replay_game.layer.masksToBounds = YES;
    self.replay_game.layer.cornerRadius = 5;
    [self.replay_game addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.replay_game];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label_2048]-20-[newGame]-20-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"label_2048":self.label_2048,@"newGame":self.replay_game}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[newGame(60)]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"newGame":self.replay_game}]];
    
    self.label_score = [[UILabel alloc]init];
    self.label_score.translatesAutoresizingMaskIntoConstraints = false;
    self.label_score.backgroundColor=[UIColor orangeColor];
    [self.label_score setText:@"当前分数：0"];
    [self.label_score setTextAlignment:NSTextAlignmentCenter];
    [self.label_score setTextColor:[UIColor whiteColor]];
    self.label_score.layer.masksToBounds = YES;
    self.label_score.layer.cornerRadius = 5;
    [self.view addSubview:self.label_score];

    CGFloat marge = 20;
    NSNumber * label_score_width = [NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width - marge * 3) / 2];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label_score(width)]" options:NSLayoutFormatDirectionLeftToRight metrics:@{@"width":label_score_width} views:@{@"label_score":self.label_score}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label_2048]-20-[label_score(40)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"label_2048":self.label_2048,@"label_score":self.label_score}]];
    
    
    //从本地获取到最高得分
    self.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [self.documentPath stringByAppendingString:@"RecordScore"];
    NSString *scoreMaxStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    self.label_maxScore = [[UILabel alloc]init];
    self.label_maxScore.backgroundColor = [UIColor orangeColor];
    self.label_maxScore.translatesAutoresizingMaskIntoConstraints = false;
    [self.label_maxScore setTextAlignment:NSTextAlignmentCenter];
    [self.label_maxScore setTextColor:[UIColor whiteColor]];
    self.label_maxScore.layer.masksToBounds = YES;
    self.label_maxScore.layer.cornerRadius = 5;
    if(scoreMaxStr == nil)
    {
        self.maxScore = 0;
        [self.label_maxScore setText:@"最高得分：0"];
    }
    else
    {
        self.maxScore = [scoreMaxStr integerValue];
        [self.label_maxScore setText:[NSString stringWithFormat:@"最高得分：%ld",self.maxScore]];
    }
    [self.view addSubview:self.label_maxScore];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label_maxScore(width)]-20-|" options:NSLayoutFormatDirectionLeftToRight metrics:@{@"width":label_score_width} views:@{@"label_maxScore":self.label_maxScore}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[replay_game]-40-[label_maxScore(40)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"replay_game":self.replay_game,@"label_maxScore":self.label_maxScore}]];
    
    NSNumber * groundViewWidth = [NSNumber numberWithInt:[UIScreen mainScreen].bounds.size.width - 20] ;
    
    self.gap = [groundViewWidth floatValue] * 4 / 300;
    self.side = [groundViewWidth floatValue] * 70 / 300;
    
    self.groundView = [[UIView alloc]init];
    self.groundView.translatesAutoresizingMaskIntoConstraints = false;
    self.groundView.layer.masksToBounds = YES;
    self.groundView.layer.cornerRadius = 12.5;
    [self.view addSubview:self.groundView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[groundView(groundViewWidth)]" options:NSLayoutFormatDirectionLeftToRight metrics:@{@"groundViewWidth":groundViewWidth} views:@{@"groundView":self.groundView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label_score]-20-[groundView(groundViewWidth)]" options:NSLayoutFormatDirectionLeftToRight metrics:@{@"groundViewWidth":groundViewWidth} views:@{@"label_score":self.label_score,@"groundView":self.groundView}]];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.groundView addSubview:imageView];
    [self.groundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"imageView":imageView}]];
    [self.groundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"imageView":imageView}]];
    
    imageView.image = [UIImage imageNamed:@"background.png"];
    
    [self make_colorArray];
    [self installGestureRecognizer];
    [self make_squareArray];
    [self randomGenerationNum];
    [self randomGenerationNum];
    [self make_Array];
}

- (NSMutableArray *)colorArray{
    if (_colorArray == nil){
        _colorArray = [[NSMutableArray alloc]init];
    }
    return _colorArray;
}

- (NSMutableArray *)squareArray{
    if (_squareArray == nil) {
        _squareArray = [[NSMutableArray alloc]init];
    }
    return _squareArray;
}

- (NSMutableArray *)upArray{
    if (_upArray == nil) {
        _upArray = [[NSMutableArray alloc]init];
    }
    return _upArray;
}

- (NSMutableArray *)downArray{
    if (_downArray == nil) {
        _downArray = [[NSMutableArray alloc]init];
    }
    return _downArray;
}

- (NSMutableArray *)rightArray{
    if (_rightArray == nil) {
        _rightArray = [[NSMutableArray alloc]init];
    }
    return _rightArray;
}

-(void)make_colorArray    //设置划块的颜色
{
    [self.colorArray addObject:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self.colorArray addObject:[UIColor colorWithRed:51.0/255 green:204.0/255 blue:1 alpha:1]];   //2
    [self.colorArray addObject:[UIColor colorWithRed:0 green:153.0/255 blue:1 alpha:1]];   //4
    [self.colorArray addObject:[UIColor colorWithRed:0 green:238.0/255 blue:0 alpha:1]];   //8
    [self.colorArray addObject:[UIColor colorWithRed:0 green:185.0/255 blue:0 alpha:1]];   //16
    [self.colorArray addObject:[UIColor colorWithRed:1 green:145.0/255 blue:0 alpha:1]];   //32
    [self.colorArray addObject:[UIColor colorWithRed:1 green:127.0/255 blue:0 alpha:1]];   //64
    [self.colorArray addObject:[UIColor colorWithRed:1 green:215.0/255 blue:0 alpha:1]];   //128
    [self.colorArray addObject:[UIColor colorWithRed:218.0/255 green:165.0/255 blue:32.0/255 alpha:1]];   //256
    [self.colorArray addObject:[UIColor colorWithRed:1 green:0 blue:102.0/255 alpha:1]];   //512
    [self.colorArray addObject:[UIColor colorWithRed:1 green:51.0/255 blue:0 alpha:1]];    //1024
    [self.colorArray addObject:[UIColor colorWithRed:60.0/255 green:58.0/255 blue:50.0/255 alpha:1]];      //2048
}
     
-(void)make_squareArray   //设置方块的数组
{
    for(int i=0; i<16; i++)
    {
        CGFloat x = (i % 4) * (self.side + self.gap) + self.gap;
        CGFloat y = (i / 4) * (self.side + self.gap) + self.gap;
        CGFloat s = self.side;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, s, s)];
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:50];
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:12.5];//设置label的弧度
        
        [self.groundView addSubview:label];
        [self.squareArray addObject:label];
    }
}

-(void)refresh_a_page     //刷新label
{
    int i;
    NSInteger tag;
    int index;
    
    for(i = 0; i < 16; i++)
    {
        UILabel * label = self.squareArray[i];
        if(label.tag == 0)
        {
            label.text = @"";
            label.backgroundColor = self.colorArray[0];  //初始的label为透明色
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%li",(long)label.tag];
            tag = label.tag;
            for(index=0; tag != 1; index++)
            {
                tag = tag/2;
            }
            label.backgroundColor = self.colorArray[index];
            
        }
    }
    self.label_score.text = [NSString stringWithFormat:@"当前分数：%ld",self.score];
    
    if(self.maxScore < self.score)
    {
        self.maxScore = self.score;
        NSString *maxScoreString=[NSString stringWithFormat:@"%ld",self.maxScore];
        self.label_maxScore.text=[NSString stringWithFormat:@"最高得分：%@",maxScoreString];
        
        NSString *path = [self.documentPath stringByAppendingString:@"RecordScore"];
        [maxScoreString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)randomGenerationNum   //随机获得一个2或4的label
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for(int i = 0; i < 16; i++)
    {
        UILabel *label = self.squareArray[i];
        if(label.tag == 0)
        {
            [array addObject:label];
        }
    }
    if(array.count == 0)    //如果没有空的(tag == 0)方块
    {
        return;
    }
    int index = arc4random() % array.count;
    int num = arc4random() % 4;
    if(num == 0)
    {
        num = 4;
    }
    else
    {
        num = 2;
    }
    UILabel * label2 = array[index];
    label2.tag = num;
    [self refresh_a_page];
}

- (void)playGame{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"重新开始" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartGame];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)restartGame{
    self.score = 0;
    for(int i = 0; i < 16; i++)
    {
        UILabel * label = self.squareArray[i];
        label.tag = 0;
    }
    [self randomGenerationNum];
    [self randomGenerationNum];
    [self refresh_a_page];
}

//添加手势
- (void)installGestureRecognizer
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    //定义的手势只支持向右轻划
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    swipe.numberOfTouchesRequired =1;
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    //定义的手势只支持向左轻划
    swipe2.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe2.numberOfTouchesRequired =1;
    
    UISwipeGestureRecognizer *swipe3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    //定义的手势只支持向上轻划
    swipe3.direction = UISwipeGestureRecognizerDirectionUp;
    swipe3.numberOfTouchesRequired =1;
    
    UISwipeGestureRecognizer *swipe4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    //定义的手势只支持向下轻划
    swipe4.direction = UISwipeGestureRecognizerDirectionDown;
    swipe4.numberOfTouchesRequired =1;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:swipe2];
    [self.view addGestureRecognizer:swipe3];
    [self.view addGestureRecognizer:swipe4];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)uisgr
{
    if (uisgr.direction & UISwipeGestureRecognizerDirectionUp ) {
        [self change_label_swipeGesture:self.upArray];
    }
    else if (uisgr.direction & UISwipeGestureRecognizerDirectionDown) {
        [self change_label_swipeGesture:self.downArray];
    }
    else if (uisgr.direction & UISwipeGestureRecognizerDirectionLeft) {
        [self change_label_swipeGesture:self.leftArray];
    }
    else if(uisgr.direction & UISwipeGestureRecognizerDirectionRight) {
        [self change_label_swipeGesture:self.rightArray];
    }
    else
    {
        NSLog(@"滑动出错");
    }
}

-(void)make_Array   //上下左右滑动ARRAY
{
    self.leftArray = self.squareArray;
    
    int i = 0;
    int j = 0;
    for(i = 3; i >= 0; i--)
    {
        for(j = 0; j < 13; j += 4)
        {
            [self.upArray addObject:self.squareArray[i+j]];
        }
    }
    
    for(i = 15; i >= 0; i--)
    {
        [self.rightArray addObject:self.squareArray[i]];
        [self.downArray addObject:self.upArray[i]];
    }
}

-(void)change_label_swipeGesture:(NSArray *)array   // 游戏算法
{
    int i = 0;
    int j = 0;
    BOOL flag = NO;  //标记本次滑动是否有改变
    for(i = 0; i < 16; i++)
    {
        UILabel *label1 = array[i];
        //label1 不为零 或 label1和label2在一行
        for(j = 1; label1.tag != 0 && (j+i)/4 == i/4; j++)
        {
            UILabel * label2 = array[j+i];
            if(label2.tag == 0)
            continue;
            if(label1.tag == label2.tag)
            {
                label1.tag *= 2;
                label2.tag = 0;
                flag = YES;
                self.score += label1.tag;        //计算分数
            }
            break;
        }
    }
    for(i = 0; i < 16; i++)
    {
        UILabel * label1 = array[i];
        
        //label1 是0 或 label2 和label1在一行
        for(j = 1; label1.tag == 0 && (j+i)/4 == i/4;j++)
        {
            UILabel * label2 = array[j+i];
            if(label2.tag == 0)
            continue;
            else
            {
                label1.tag = label2.tag;
                label2.tag = 0;
                flag = YES;  // 有变化
            }
            break;
        }
    }
    if(flag == YES)  //滑动有改变
    {
        [self randomGenerationNum];
        [self refresh_a_page];
        [self game_over];
        [self you_win];
    }
}

-(void)game_over
{
    int i;
    for(i = 0; i < 16; i++)
    {
        UILabel * label1 = self.squareArray[i];
        if(label1.tag == 0)         //还有空的label
        {
            return;
        }
        if(i%4 != 3)      //i%4=3 每行的最后一个label
        {
            UILabel * label2 = self.squareArray[i + 1];   //保证i 和i+1在同一行
            if(label1.tag == label2.tag)        //如果可加则有一不会结束
            return;
        }
        if(i < 12)
        {
            UILabel * label3 = self.squareArray[i + 4];     //如果同一列可加
            if(label1.tag == label3.tag)
            return;
        }
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否重新开始游戏" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartGame];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)you_win    //当label.tag中出现2048字样，判定win
{
    int i;
    for(i = 0; i < 16; i++)
    {
        UILabel * label = self.squareArray[i];
        if(label.tag == 2014)
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你赢了" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self restartGame];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
