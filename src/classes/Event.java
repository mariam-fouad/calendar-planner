package classes;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;

public class Event {
	public String title;
	public String color;
	public String discription;
	public String imgUrl;
	public String startDate;
	public String endDate;
	public String filePath = "Resource/EventFile.txt";
	
	public void makeSureFileExist()
	{
		File f = new File("Resource");
		if (!f.exists() || !f.isDirectory()) {
			f.mkdir();
		}


	}
	public void addEvent(Event newEvent) throws IOException 
	{
		makeSureFileExist();
		String filename= filePath;
	    FileWriter fw = new FileWriter(filename,true); //the true will append the new data
	    fw.write(newEvent.title+"~"+newEvent.color+"~"+newEvent.discription+"~"+newEvent.imgUrl+"~"+newEvent.startDate+"~"+newEvent.endDate+"\n");//appends the string to the file
	    fw.close();
	}
	public void editEvent(Event oldEvent , Event updatedEvent) throws IOException, ParseException
	{
		
		ArrayList<Event>allEvents= getAllEvents();
		PrintWriter writer = new PrintWriter(filePath, "UTF-8");
		for (int i=0;i<allEvents.size();i++)
		{


			if ((allEvents.get(i).title.equals(oldEvent.title))&&(allEvents.get(i).color.equals(oldEvent.color))&&
					(allEvents.get(i).startDate.equals(oldEvent.startDate))&&(allEvents.get(i).endDate.equals(oldEvent.endDate))&&
					(allEvents.get(i).discription.equals(oldEvent.discription))&&(allEvents.get(i).imgUrl.equals(oldEvent.imgUrl)))
			{

				writer.println(updatedEvent.title+"~"+updatedEvent.color+"~"+updatedEvent.discription+"~"+updatedEvent.imgUrl+"~"+updatedEvent.startDate+"~"+updatedEvent.endDate);
			}
			else
			{
				 writer.println(allEvents.get(i).title+"~"+allEvents.get(i).color+"~"+allEvents.get(i).discription+"~"+allEvents.get(i).imgUrl+"~"+allEvents.get(i).startDate+"~"+allEvents.get(i).endDate);

			}
		}
		writer.close();
	}
	public void deleteEvent (Event deletedEvent) throws FileNotFoundException, UnsupportedEncodingException, ParseException
	{
		ArrayList<Event>allEvents= getAllEvents();
		PrintWriter writer = new PrintWriter(filePath, "UTF-8");
		for (int i=0;i<allEvents.size();i++)
		{


			if ((allEvents.get(i).title.equals(deletedEvent.title))&&(allEvents.get(i).color.equals(deletedEvent.color))&&
					(allEvents.get(i).startDate.equals(deletedEvent.startDate))&&(allEvents.get(i).endDate.equals(deletedEvent.endDate))&&
					(allEvents.get(i).discription.equals(deletedEvent.discription))&&(allEvents.get(i).imgUrl.equals(deletedEvent.imgUrl)))
			{
				continue;

			}
			else
			{
				 writer.println(allEvents.get(i).title+"~"+allEvents.get(i).color+"~"+allEvents.get(i).discription+"~"+allEvents.get(i).imgUrl+"~"+allEvents.get(i).startDate+"~"+allEvents.get(i).endDate);

			}
		}
		writer.close();
			
	}
	public ArrayList<Event> getAllEvents () throws FileNotFoundException, ParseException
	{
		ArrayList <Event> allEvents = new ArrayList<>();
		File file =new File(filePath);
	    Scanner sc = new Scanner(file); 
		while (sc.hasNextLine())
		{
		  String newLine = sc.nextLine();
		  String [] lineParts=newLine.split("~");
		  Event e = new Event ();
		  e.title=lineParts[0];
		  e.color=lineParts[1];
		  e.discription=lineParts[2];
		  e.imgUrl=lineParts[3];
          e.startDate=lineParts[4];
          e.endDate=lineParts[5];
          allEvents.add(e);
		}
		return allEvents;
	}

}

