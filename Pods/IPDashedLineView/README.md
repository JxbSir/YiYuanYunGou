# IPDashedLineView

IPDashedLineView provides a simple interface for creating dashed lines.  It can be instantiated in code with `-initWithFrame:` or in a nib.

![Screenshot](http://i.imgur.com/ROnEND9.png?1)

## Example Usage

    // Forced Horizontal
    IPDashedLineView *dash1 = [[IPDashedLineView alloc] initWithFrame:CGRectMake(20, 60, 200, 1)];
    dash1.direction = IPDashedLineViewDirectionHorizontalFromRight;
    dash1.lineColor = [UIColor blackColor];
    dash1.lengthPattern = @[@1, @1];
    [self.view addSubview:dash1];

    // Vertical
    IPDashedLineView *dash2 = [[IPDashedLineView alloc] initWithFrame:CGRectMake(20, 100, 4, 200)];
    dash2.lengthPattern = @[@4, @4];
    dash2.lineColor = [UIColor orangeColor];
    [self.view addSubview:dash2];
    
    // Horizontal
    IPDashedLineView *dash3 = [[IPDashedLineView alloc] initWithFrame:CGRectMake(40, 100, 200, 4)];
    dash3.lengthPattern = @[@2, @4];
    dash3.lineColor = [UIColor greenColor];
    [self.view addSubview:dash3];

    // Forced Vertical
    IPDashedLineView *dash4 = [[IPDashedLineView alloc] initWithFrame:CGRectMake(40, 300, 6, 200)];
    dash4.lengthPattern = @[@1, @1, @10, @1, @1, @6,];
    dash4.phase = 7;
    dash4.lineColor = [UIColor redColor];
    dash4.backgroundColor = [UIColor blueColor];
    dash4.direction = IPDashedLineViewDirectionVerticalFromBottom;
    [self.view addSubview:dash4];
    
    // Forced Vertical (looks like a bunch of horizontal lines)
    IPDashedLineView *dash5 = [[IPDashedLineView alloc] initWithFrame:CGRectMake(60, 300, 200, 20)];
    dash5.lengthPattern = @[@1, @1];
    dash5.lineColor = [UIColor purpleColor];
    dash5.direction = IPDashedLineViewDirectionVerticalFromTop;
    [self.view addSubview:dash5];
    
    // Bordered View
    IPDashedBorderedView *borderedView1 = [[IPDashedBorderedView alloc] initWithFrame:CGRectMake(60, 140, 200, 100)];
    borderedView1.borderWidth = 5;
    borderedView1.lineColor = [UIColor orangeColor];
    borderedView1.lengthPattern = @[@5, @5];
    borderedView1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:borderedView1];
    
    // Bordered View
    IPDashedBorderedView *borderedView2 = [[IPDashedBorderedView alloc] initWithFrame:CGRectMake(120, 180, 40, 40)];
    borderedView2.borderWidth = 1;
    borderedView2.lineColor = [UIColor whiteColor];
    borderedView2.lengthPattern = @[@1, @1];
    borderedView2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:borderedView2];
    
    // Bordered View
    IPDashedBorderedView *borderedView3 = [[IPDashedBorderedView alloc] initWithFrame:CGRectMake(180, 180, 40, 40)];
    borderedView3.borderWidth = 1;
    borderedView3.lineColor = [UIColor lightGrayColor];
    borderedView3.lengthPattern = @[@1, @3];
    borderedView3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:borderedView3];