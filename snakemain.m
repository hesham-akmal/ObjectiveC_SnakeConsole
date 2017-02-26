#import <Foundation/Foundation.h>
#import <conio.h>

@interface snake: NSObject {
	int x, y;
}
@property int x,y; 

typedef NS_ENUM(NSInteger, direction_enum) {
	left,
	right,
	up,
	down
};
direction_enum snakedir;

@property (nonatomic, readonly, assign) direction_enum snakedir;
- (void) dealloc;
- (void) updateDirRight;
- (void) updateDirLeft;
- (void) updateDirUp;
- (void) updateDirDown;
@end


@implementation snake
@synthesize x,y;
- (id) initWithName : (int) width : (int) height {
	self = [super init];
	if (self != nil) {
		x = width / 2;
		y = height / 2;
		snakedir = right;
	}
	return self;
}
- (void)dealloc {
	[super dealloc];
}
- (void) updateDirRight {
	snakedir = right;
}
- (void) updateDirLeft {
	snakedir = left;
}
- (void) updateDirUp {
	snakedir = up;
}
- (void) updateDirDown {
	snakedir = down;
}
- (direction_enum) snakedir { return snakedir;}
@end



@interface game: NSObject {
	BOOL gameover;
	int width ;
	int height;
	int fruitx, fruity, score;
	int tailx[1000], taily[1000];
	snake *snakePlayer;
}
@property BOOL gameover;
-(void) Setup;
-(void) Draw;
-(void) Input;
-(void) Logic;
-(void) dealloc;
@end

@implementation game
@synthesize gameover;
-(void) Setup{
	width = 20;
	height = 20;
	snakePlayer = [[snake alloc] initWithName : width : height];
	gameover = false;
	fruitx = rand()% width;
	fruity = 0;
	score = 3;
}

-(void) Draw{
	
	system("cls");
	for (int i =0; i < width +2; i++)
	printf("#");
	printf("\n");
	
	for (int i =0; i < height; i++)
	{
		for (int j =0; j < width; j++)
		{
			if(j==0)
			printf("#");
			
			if( [snakePlayer x] ==j && [snakePlayer y] ==i)
			printf("O");
			else if ( fruitx==j && fruity==i)
			printf("*");
			else
			{
				BOOL tailPrinted = false;
				for(int a = 0; a<score ;a++)
				if( tailx[a] == j && taily[a] == i)
				{
					printf("o");
					tailPrinted = true;
				}
				
				if(!tailPrinted)
				printf(" ");
			}
			
			
			if(j == width -1)
			printf("#");
		}
		printf("\n");
	}
	
	for (int i =0; i < width+2; i++)
	printf("#");
	printf("\n");
	printf("Score = %i",score-3);
	printf("\n");
}

-(void) Input{
	if(_kbhit())
	{
		switch(_getche())
		{
		case 'a':
			if([snakePlayer snakedir]==right) break;
			[snakePlayer updateDirLeft];
			break;
			
		case 'd':
			if([snakePlayer snakedir]==left) break;
			[snakePlayer updateDirRight];
			break;
			
		case 'w':
			if([snakePlayer snakedir]==down) break;
			[snakePlayer updateDirUp];
			break;
			
		case 's':
			if([snakePlayer snakedir]==up) break;
			[snakePlayer updateDirDown];
			break;
			
		case 'x':
			gameover = true;
			break;
		}
	}
}

-(void) Logic{
	
	int prevX = tailx[0];
	int prevY = taily[0];
	int prev2X, prev2Y;
	tailx[0] = [snakePlayer x];
	taily[0] = [snakePlayer y];
	
	fruity++;
	if(fruity>height)
	{
		fruitx = rand()% width;
		fruity = 0;
	}
	
	for(int i = 1; i < score ; i++)
	{
		if([snakePlayer x] == tailx[i] && [snakePlayer y] == taily[i])
		{
			gameover=true;
			printf("ATE YOURSELF, ");
			break;
		}
		
		prev2X = tailx[i];
		prev2Y = taily[i];
		tailx[i] = prevX;
		taily[i] = prevY;
		prevX = prev2X;
		prevY = prev2Y;
	}
	
	switch (snakedir)
	{
	case left:
		snakePlayer.x--;
		break;
		
	case right:
		snakePlayer.x++;
		break;
		
	case up:
		snakePlayer.y--;
		break;
		
	case down:
		snakePlayer.y++;
		break;
		
	default:
		break;
	}

	if(snakePlayer.x >= width)
	snakePlayer.x=0;
	else if (snakePlayer.x<0) 
	snakePlayer.x = width -1;

	if(snakePlayer.y >= height)
	snakePlayer.y=0;
	else if (snakePlayer.y<0) 
	snakePlayer.y = width -1;

	if(snakePlayer.x==fruitx && snakePlayer.y==fruity
	|| snakePlayer.x==fruitx && snakePlayer.y-1 ==fruity )
	{
		score++;
		fruitx = rand()% width;
		fruity = 0;
	}
}
- (void)dealloc {
	[snakePlayer release];
	[super dealloc];
}
@end

int main (int argc, const char * argv[]){
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	game *gameobj = [[game alloc] init];
	[ gameobj Setup ];
	
	while(! [gameobj gameover])
	{
		[ gameobj Draw ];
		[ gameobj Input ];
		[ gameobj Logic ];
		[NSThread sleepForTimeInterval:0.1f];
	}
	printf("GAME OVER\n");
	[NSThread sleepForTimeInterval:2.0f];
	[gameobj release];
	[pool drain];
	return 0;
}