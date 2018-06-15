import java.awt.*;
import java.util.*;
import java.applet.*;
import java.awt.event.MouseEvent;
import javax.swing.event.*;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.io.File;
import org.json.simple.JSONArray; 
import org.json.simple.JSONObject; 
import org.json.simple.parser.JSONParser; 
import org.json.simple.parser.ParseException; 
/*<applet code="Main" height=400 width=400></applet>*/


public class Main extends Applet implements Runnable
{

	/* Configuration arguments. These should be initialized with the values read from the config.JSON file*/					
	private int x_leftout;
	private int x_rightout;
	private int y_upout;
	private int y_downout;

	private int numLives;
	private int score2EarnLife;

	private int numBalls;

	private int current;
	/*end of config arguments*/

	private int refreshrate = 15;	           //Refresh rate for the applet screen. Do not change this value. 
	private boolean isStoped = true;		     
	Font f = new Font ("Arial", Font.BOLD, 18);

	private Player player;			           //Player instance.
	//	private Ball redball;                      //Ball instance. You need to replace this with an array of balls.     
	//	private Ball blueball;
	//	private Ball greenball;

	/*
	 * The skeleton code creates a single ball only. Your game should support an arbitrary number of balls (the number of 
	 * balls will be read from the config file). Your game should maintain the instances of the ball objects in an array 
	 * (or Arraylist).
	 * */
	public Ball[] balls;

	Thread th;						           //The applet thread. 

	Cursor c;				
	private GameWindow gwindow;                 // Defines the borders of the applet screen. A ball is considered "out" when it moves out of these borders.
	private Image dbImage;
	private Graphics dbg;

	//parse

	class HandleMouse extends MouseInputAdapter 
	{
		public HandleMouse() 
		{
			addMouseListener(this);
		}

		public void mouseClicked(MouseEvent e) 
		{
			if (!isStoped) {
				for(int i = 0; i < numBalls; i++)
				{
					if (balls[i].userHit (e.getX(), e.getY())) 
					{
						balls[i].ballWasHit ();
						balls[i].addHit();
						player.addSuccessClicks();
					}
				}
			}
			else if (isStoped && e.getClickCount() == 2) {
				isStoped = false;
				init ();
			}

			player.addClicks();

		}

		public void mouseReleased(MouseEvent e) 
		{

		}

		public void RegisterHandler() 
		{

		}
	}

	HandleMouse hm = new HandleMouse();
	//JSONReader parser = new JSONObject();
	//JSON reader; you need to complete this function
	/*
	 * Parse the config.JSON file: In the provided skeleton code, most of the arguments to configure the 
	 * game are hard coded. You need to read these configuration values from a JSON file and initialize the
	 *  classes using these values. A sample config.JSON file is available in the skeleton code archive file.
	 * */
	public void JSONReader()
	{
		//Object obj = parser.parse(new FileReader("config.JSON"));
		//JSONObject jsonObject = (JSONObject) obj;
		//int x_left_out = Integer.parseInt(((JSONObject)jsonObject.get("GameWindow")).get("x_leftout"));
		try {
			FileReader reader = new FileReader("config.JSON");
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(reader);

			//GameWindow
			JSONObject structure = (JSONObject) jsonObject.get("GameWindow");
			x_leftout =Integer.parseInt((String)structure.get("x_leftout")) ;
			x_rightout = Integer.parseInt((String)structure.get("x_rightout"));
			y_upout =Integer.parseInt((String) structure.get("y_upout"));
			y_downout = Integer.parseInt((String) structure.get("y_downout"));
			System.out.println("x_leftout="+x_leftout+"\n"+
					"x_rightout="+x_rightout+"\n"+
					"y_upout="+y_upout+"\n"+
					"y_downout="+y_downout);
			gwindow = new GameWindow(x_leftout,x_rightout,y_upout,y_downout);
			
			//Player
			structure = (JSONObject) jsonObject.get("Player");
			numLives = Integer.parseInt((String)structure.get("numLives"));
			score2EarnLife = Integer.parseInt((String)structure.get("score2EarnLife"));
			System.out.println("numLives="+numLives+"\n"+
					"score2EarnLife="+score2EarnLife);
			player = new Player (numLives, score2EarnLife);
			//numBalls
			numBalls = Integer.parseInt((String)jsonObject.get("numBalls"));
			System.out.println("numBalls="+numBalls);
			balls = new Ball[numBalls];
			
			//Balls
			JSONArray ballArray = (JSONArray) jsonObject.get("Ball");
			for(int i = 0;i<ballArray.size();i++)
			{
				System.out.println("The " + i + " element of the array: "+ballArray.get(i));
			}
			
			Iterator i = ballArray.iterator();
			
			while(i.hasNext())
			{
				JSONObject innerObj = (JSONObject) i.next();
				String type = (String)innerObj.get("type");
				System.out.println(type);

				int id;
				int radius;
				int initXpos;
				int initYpos;
				int speedX;
				int speedY;
				int maxBallSpeed;
				Color color = null;
				int bounceCount;
				int shrinkRate;

				if(type.compareTo("basicball")==0)
				{
					id = Integer.parseInt((String)innerObj.get("id"));
					radius = Integer.parseInt((String)innerObj.get("radius"));
					initXpos = Integer.parseInt((String)innerObj.get("initXpos"));
					initYpos = Integer.parseInt((String)innerObj.get("initYpos"));
					speedX = Integer.parseInt((String)innerObj.get("speedX"));
					speedY = Integer.parseInt((String)innerObj.get("speedY"));
					maxBallSpeed = Integer.parseInt((String)innerObj.get("maxBallSpeed"));
					JSONArray colorArray = (JSONArray) innerObj.get("color");
					System.out.print("color: ");
					int[] rgb = new int[3];
					for(int j = 0;j<colorArray.size();j++)
					{
						rgb[j]=Integer.parseInt((String)colorArray.get(j));
						System.out.print(rgb[j]+" ");
					}
					color = new Color(rgb[0],rgb[1],rgb[2]);
					System.out.println();
					balls[id-1]=new Ball(radius,initXpos,initYpos,speedX,speedY,maxBallSpeed,color,player,gwindow);
				}
				else if(type.compareTo("bounceball")==0)
				{
					id = Integer.parseInt((String)innerObj.get("id"));
					radius = Integer.parseInt((String)innerObj.get("radius"));
					initXpos = Integer.parseInt((String)innerObj.get("initXpos"));
					initYpos = Integer.parseInt((String)innerObj.get("initYpos"));
					speedX = Integer.parseInt((String)innerObj.get("speedX"));
					speedY = Integer.parseInt((String)innerObj.get("speedY"));
					maxBallSpeed = Integer.parseInt((String)innerObj.get("maxBallSpeed"));
					JSONArray colorArray = (JSONArray) innerObj.get("color");
					System.out.print("color: ");
					int[] rgb = new int[3];
					for(int j = 0;j<colorArray.size();j++)
					{
						rgb[j]=Integer.parseInt((String)colorArray.get(j));
						System.out.print(rgb[j]+" ");
					}
					color = new Color(rgb[0],rgb[1],rgb[2]);
					System.out.println();
					bounceCount = Integer.parseInt((String)innerObj.get("bounceCount"));
					
					balls[id-1]=new BounceBall(radius,initXpos,initYpos,speedX,speedY,maxBallSpeed,color,player,gwindow,bounceCount);
					
				}
				else
				{
					id = Integer.parseInt((String)innerObj.get("id"));
					radius = Integer.parseInt((String)innerObj.get("radius"));
					initXpos = Integer.parseInt((String)innerObj.get("initXpos"));
					initYpos = Integer.parseInt((String)innerObj.get("initYpos"));
					speedX = Integer.parseInt((String)innerObj.get("speedX"));
					speedY = Integer.parseInt((String)innerObj.get("speedY"));
					maxBallSpeed = Integer.parseInt((String)innerObj.get("maxBallSpeed"));
					JSONArray colorArray = (JSONArray) innerObj.get("color");
					System.out.print("color: ");
					int[] rgb = new int[3];
					for(int j = 0;j<colorArray.size();j++)
					{
						rgb[j]=Integer.parseInt((String)colorArray.get(j));
						System.out.print(rgb[j]+" ");
					}
					color = new Color(rgb[0],rgb[1],rgb[2]);
					System.out.println();
					shrinkRate = Integer.parseInt((String)innerObj.get("shrinkRate"));
					balls[id-1]=new ShrinkBall(radius,initXpos,initYpos,speedX,speedY,maxBallSpeed,color,player,gwindow,shrinkRate);
				}
			}


		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


	}

	/*initialize the game*/
	public void init ()
	{	
		//reads info from JSON doc
		this.JSONReader();
		c = new Cursor (Cursor.CROSSHAIR_CURSOR);
		this.setCursor (c);	

		setBackground (Color.black);
		setFont (f);

		if (getParameter ("refreshrate") != null) {
			refreshrate = Integer.parseInt(getParameter("refreshrate"));
		}
		else refreshrate = 15;

		//player = new Player ();
		/* The parameters for the GameWindow constructor (x_leftout, x_rightout, y_upout, y_downout) 
		should be initialized with the values read from the config.JSON file*/	
		//gwindow = new GameWindow(0,800,0,1000);
		this.setSize(gwindow.x_rightout, gwindow.y_downout); //set the size of the applet window.

		/*The skeleton code creates a single basic ball. Your game should support arbitrary number of balls. 
		 * The number of balls and the types of those balls are specified in the config.JSON file.
		 * The ball instances will be stores in an Array or Arraylist.  */
		/* The parameters for the Ball constructor (radius, initXpos, initYpos, speedX, speedY, maxBallSpeed, color) 
		should be initialized with the values read from the config.JSON file. Note that the "color" need to be initialized using the RGB values provided in the config.JSON file*/
		
	}

	/*start the applet thread and start animating*/
	public void start ()
	{		
		if (th==null){
			th = new Thread (this);
		}
		th.start ();
	}

	/*stop the thread*/
	public void stop ()
	{
		th=null;
	}

	public void run ()
	{	
		/*Lower this thread's priority so it won't interfere with other processing going on*/
		Thread.currentThread().setPriority(Thread.MIN_PRIORITY);

		/*This is the animation loop. It continues until the user stops or closes the applet*/
		while (true) {
			if (!isStoped) 
			{
				for(int i = 0;i<numBalls;i++)
				{
					if(balls[i].isOut())
					{
						player.lostLives();
					}
					
					if(player.getCurrent() >= score2EarnLife)
					{
						player.gainLives();
					}
					
					balls[i].move();
					
					if(player.getLives() == 0)
					{
						player.gameIsOver();
					}
				}
			}
			
			/*Display it*/
			repaint();

			try {

				Thread.sleep (refreshrate);
			}
			catch (InterruptedException ex) {
				
			}			
		}
	}

	public void paint (Graphics g)
	{
		/*if the game is still active draw the ball and display the player's score. If the game is active but stopped, ask player to double click to start the game*/ 
		if (!player.isGameOver()) {
			g.setColor (Color.yellow);

			g.drawString ("Score: " + player.getScore(), 10, 40);
			g.drawString("Lives:" + player.getLives(), 10, 70); // The player lives need to be displayed
			
			for(int i = 0;i<numBalls;i++)
			{
				balls[i].DrawBall(g);
			}
			//redball.DrawBall(g);

			if (isStoped) {
				g.setColor (Color.yellow);
				g.drawString ("Doubleclick on Applet to start Game!", 40, 200);
			}
		}
		/*if the game is over (i.e., the ball is out) display player's score*/
		else {
			g.setColor (Color.yellow);

			/*
			 * You will collect statistics about the player¡¯s performance and store them in the Player class. Those should be displayed on the screen at the end of the game.
			 * */
			
			g.drawString ("Game over!", 130, 100);
			g.drawString ("You scored " + player.getScore() + " Points!", 90, 140);
			g.drawString("Statistics: ", 400, 160);
			g.drawString("Number of Clicks: " + player.getTotalClicks(), 400, 180); // The number of clicks need to be displayed
			g.drawString("% of Successful Clicks: " + 1.0*player.getSuccessClicks()/player.getTotalClicks()*100.0 +"%",400,200); // The % of successful clicks need to be displayed

			Ball maxBall = balls[0];
			
			for(int i = 0;i<numBalls-1;i++)
			{
				maxBall = balls[i];
				if(balls[i].getHit()<balls[i+1].getHit())
				{
					maxBall = balls[i+1];
				}
			}

			g.drawString("Ball most hit: "+ maxBall.getClass().getName(), 400, 240); // The nball that was hit the most need to be displayed

			g.drawString ("Doubleclick on the Applet, to play again!", 20, 220);

			isStoped = true;
		}
	}


	public void update (Graphics g)
	{

		if (dbImage == null)
		{
			dbImage = createImage (this.getSize().width, this.getSize().height);
			dbg = dbImage.getGraphics ();
		}


		dbg.setColor (getBackground ());
		dbg.fillRect (0, 0, this.getSize().width, this.getSize().height);


		dbg.setColor (getForeground());
		paint (dbg);


		g.drawImage (dbImage, 0, 0, this);
	}
}


