import java.applet.*;
import java.awt.*;

/*
 * The Ball class implements a basic ball that moves with a pre-set speed. You will change the Ball class so that every time the ball is 
 * hit or the ball is out, it¡¯s speed (in x and y directions) should be randomized. Please note that the speed of the ball can be either
 * positive or negative. When the speed is positive, the ball will move from left to right; and when the speed is negative it will move
 * from right to left. You may assume that the ball will have a maximum absolute speed. The initial speed of the ball and its max speed 
 * will be read form the config file.
 * */
public class Ball
{
    /*Properties of the basic ball. These are initialized in the constructor using the values read from the config.xml file*/
	protected  int pos_x;			
	protected int pos_y; 				
	protected int radius;
	protected int first_x;			
	protected int first_y;					
	protected int x_speed;			
	protected int y_speed;			
	protected int maxspeed;
	Color color;
	
    GameWindow gameW;
	Player player;
	
	private int numHit;
	/*constructor*/
	public Ball (int radius, int initXpos, int initYpos, int speedX, int speedY, int maxBallSpeed, Color color, Player player,  GameWindow gameW)
	{	
		this.radius = radius;

		pos_x = initXpos;
		pos_y = initYpos;

		first_x = initXpos;
		first_y = initYpos;

		x_speed = speedX;
		y_speed = speedY;

		maxspeed = maxBallSpeed;

		this.color = color;

		this.player = player;
		this.gameW = gameW;

		numHit = 0;
	}

	/*update ball's location based on it's speed*/
	public void move ()
	{
		pos_x += x_speed;
		pos_y += y_speed;
		//isOut();
	}

	/*when the ball is hit, reset the ball location to its initial starting location*/
	public void ballWasHit ()
	{	
		resetBallPosition();
	}

	/*check whether the player hit the ball. If so, update the player score based on the current ball speed. */	
	public boolean userHit (int maus_x, int maus_y)
	{
		
		double x = maus_x - pos_x;
		double y = maus_y - pos_y;

		double distance = Math.sqrt ((x*x) + (y*y));
		
		if (Double.compare(distance-this.radius , player.scoreConstant + Math.abs(x_speed)) <= 0)  {
			
			player.addScore ((int)(player.scoreConstant * Math.abs(x_speed) + player.scoreConstant));
			
			double rand = 3 - Math.random() * 7;
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 3 - Math.random() * 7;
			}
			x_speed = (int) (rand);
			
			rand = 3 - Math.random() * 7;
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 3 - Math.random() * 7;
			}
			y_speed = (int) (rand);
			
			return true;
		}
		else return false;
	}

    /*reset the ball position to its initial starting location*/
	protected void resetBallPosition()
	{
		pos_x = first_x;
		pos_y = first_y;
	}
	
	/*check if the ball is out of the game borders. if so, game is over!*/ 
	protected boolean isOut ()
	{
		if ((pos_x < gameW.x_leftout) || (pos_x > gameW.x_rightout) || (pos_y < gameW.y_upout) || (pos_y > gameW.y_downout)) {	
			resetBallPosition();	
			//player.gameIsOver();
			
			double rand = 3 - Math.random() * 7;
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 3 - Math.random() * 7;
			}
			x_speed = (int) (rand);
			
			rand = 3 - Math.random() * 7;
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 3 - Math.random() * 7;
			}
			y_speed = (int) (rand);
			
			return true;
		}	
		else return false;
	}

	/*draw ball*/
	public void DrawBall (Graphics g)
	{
		g.setColor (color);
		g.fillOval (pos_x - radius, pos_y - radius, 2 * radius, 2 * radius);
	}
	
	public void addHit()
	{
		numHit++;
	}
	
	public int getHit()
	{
		return numHit;
	}

}
