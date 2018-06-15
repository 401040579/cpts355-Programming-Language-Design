/*
 * In the given skeleton code, the game terminates when the ball is out. You need to update the Player class and have the player
 *  start the game with a given number of lives. The player will lose a life when a ball is out and will earn additional lives
 *   for every X points he/she earns.
 * */
public class Player
{
	private int numLives;
	private int score2EarnLife;
	private int score;			   //player score
	private int current;
	private boolean gameover=false;	
	private int totalClicks;
	private int successClicks;
	
	public int scoreConstant = 10; //This constant value is used in score calculation. You don't need to change this. 		
	
	
	public int getSuccessClicks(){
		return successClicks;
	}

	public void addSuccessClicks(){
		successClicks += 1;
	}
	
	public int getTotalClicks(){
		return totalClicks;
	}

	public void addClicks(){
		totalClicks += 1;
	}
	
	public Player(int a, int b)
	{
		numLives = a;
		score = 0; //initialize the score to 0
		score2EarnLife = b;
	}

	
	public Player()
	{
		numLives = 5;
		score = 0; //initialize the score to 0
		score2EarnLife = 50;
	}

	/* get player score*/
	public int getScore ()
	{
		return score;
	}

	/*check if the game is over*/
	public boolean isGameOver ()
	{
		return gameover;
	}

	/*update player score*/
	public void addScore (int plus)
	{
		score += plus;
		current += plus;
	}

	/*update "game over" status*/
	public void gameIsOver ()
	{
		gameover = true;
	}

	public void lostLives()
	{
		numLives--;
	}
	
	public void gainLives()
	{
		numLives++;
		current -= score2EarnLife;
	}
	
	public int getLives() 
	{
		// TODO Auto-generated method stub
		return numLives;
	}
	public void setCurrent(int x)
	{
		current = x;
	}
	public int getCurrent()
	{
		return current;
	}
	public void addCureent(int x)
	{
		current += x;
	}
}