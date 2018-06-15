import java.awt.*;

/*
 * BounceBall will bounce on the borders of the applet scene but it will be out after it bounces for a certain number of times. 
 * (The bounce count will be read from the config file.) The ball should maintain the magnitude of it¡¯s speed in each bounce. 
 * Please note that the direction (sign) of the speed will change due to the bounce. The other ball types won¡¯t bounce on borders.
 *  If the bounce ball goes out of the applet screen (after bouncing "bounce count" times), the user will lose a life. The 
 *  BounceBall will reappear at its initial starting location and will be assigned a random speed.
 * */

public class BounceBall extends Ball{

	private int m_bounceCount;
	private int m_initBounceCount;
	
	public BounceBall(int radius, int initXpos, int initYpos, int speedX, int speedY, int maxBallSpeed, Color color, Player player,  GameWindow gameW, int bounceCount)
	{
		super(radius,initXpos,initYpos,speedX,speedY,maxBallSpeed,color,player,gameW);
		m_bounceCount = bounceCount;
		m_initBounceCount = bounceCount;
	}
	
	
	public boolean userHit (int maus_x, int maus_y)
	{
		
		double x = maus_x - pos_x;
		double y = maus_y - pos_y;

		double distance = Math.sqrt ((x*x) + (y*y));
		
		if (Double.compare(distance-this.radius , player.scoreConstant + Math.abs(x_speed)) <= 0)  {
			
			player.addScore ((int)(player.scoreConstant * Math.abs(x_speed) + player.scoreConstant));
			
			return true;
		}
		else return false;
	}
	
	protected boolean isOut ()
	{
		if (m_bounceCount == 0 && ((pos_x <= gameW.x_leftout) || (pos_x >= gameW.x_rightout) || (pos_y <= gameW.y_upout) || (pos_y >= gameW.y_downout))){
			resetBallPosition();
			
			double rand = 5 - Math.random() * 11; // -3 to 3
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 5 - Math.random() * 11;
			}
			x_speed = (int) (rand);
			
			rand = 3 - Math.random() * 7;
			while((int)rand==0 || Math.abs(rand) > maxspeed)
			{
				rand = 3 - Math.random() * 7;
			}
			y_speed = (int) (rand);
			m_bounceCount = m_initBounceCount;
			return true;
		}	
		else if((pos_x <= gameW.x_leftout) || (pos_x >= gameW.x_rightout) || (pos_y <= gameW.y_upout) || (pos_y >= gameW.y_downout))
		{
			if((pos_x <= gameW.x_leftout) || (pos_x >= gameW.x_rightout))
			this.x_speed = - this.x_speed;
			
			if((pos_y <= gameW.y_upout) || (pos_y >= gameW.y_downout))
			this.y_speed = - this.y_speed;
			
			m_bounceCount--;
			return false;
		}
		else
		{
			return false;
		}
	}
}
