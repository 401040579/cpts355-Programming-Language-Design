import java.awt.*;
/*
 * ShrinkBall: This is a larger ball which gets smaller by 30% each time the player hits it. The scores for each hit will be doubled as the ball shrinks. After each hit, 
 * the ball will be moved to its initial location and the ball will be assigned a random speed. When the ball size is less than or equal to 30% of the initial size the 
 * ball, the ball will be reset to it's original size and it will start from the middle of the screen with a random initial speed. As long as the ball is not out, the 
 * user won¡¯t lose any lives.
 * */
public class ShrinkBall extends Ball{
	
	public int initRad;
	private int m_shrinkRate;
	public ShrinkBall(int radius, int initXpos, int initYpos, int speedX, int speedY, int maxBallSpeed, Color color, Player player,  GameWindow gameW, int shrinkRate)
	{
		super(radius,initXpos,initYpos,speedX,speedY,maxBallSpeed,color,player,gameW);
		initRad = radius;
		m_shrinkRate = shrinkRate;;
	}
	
	public void ballWasHit() {
        int smallest = (int) (initRad*(m_shrinkRate/100.0));
        double rand = 3 - Math.random() * 7;
		while((int)rand == 0 || Math.abs(rand) > maxspeed)
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
		
        if(radius <= smallest) {
            radius = initRad;
            
            pos_x = gameW.x_rightout/2;
    		pos_y = gameW.y_downout/2;
        }
        else {
            radius = (int) (radius * (1-m_shrinkRate/100.0));
            resetBallPosition();
        }
    }
	
	public boolean userHit (int maus_x, int maus_y)
	{
		
		double x = maus_x - pos_x;
		double y = maus_y - pos_y;

		double distance = Math.sqrt ((x*x) + (y*y));
		
		if (Double.compare(distance-this.radius , player.scoreConstant + Math.abs(x_speed)) <= 0)  {
			
			player.addScore (2*(int)(player.scoreConstant * Math.abs(x_speed) + player.scoreConstant));
			
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
}
