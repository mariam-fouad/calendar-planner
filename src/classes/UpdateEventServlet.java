package classes;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdateEventServlet
 */
@WebServlet("/UpdateEventServlet")
public class UpdateEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateEventServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		InputStream is = request.getInputStream();
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        byte[] buf = new byte[32];
        int r=0;
        while( r >= 0 ) {
            r = is.read(buf);
            if( r >= 0 ) os.write(buf, 0, r);
        }
        String s = new String(os.toByteArray(), "UTF-8");
        String decoded = URLDecoder.decode(s, "UTF-8");
        decoded=decoded.substring(1, decoded.length()-1);
        String [] dataArray = decoded.split(">");
        Map <String,String> mapNew = new HashMap<String, String>();
        Map <String,String> mapOld = new HashMap<String, String>();
		Event newEvent = new Event();
		Event oldEvent = new Event();
        for (int i=0;i<dataArray.length;i++)
        {
        	String []inputParts=dataArray[i].split("~");

        	for (int j=0;j<inputParts.length;j++)
        	{
	        	String [] keyAndValue = inputParts[j].split("<");

	        	if(i==0)
	        	{
	        	 mapNew.put(keyAndValue[0], keyAndValue[1]);
	        	}
	        	else
	        	{
	           	 mapOld.put(keyAndValue[0], keyAndValue[1]);
	
	        	}
        	}
        }
       

		newEvent.color=mapNew.get("color");
		newEvent.title=mapNew.get("title");
		newEvent.discription=mapNew.get("discription");
		newEvent.imgUrl=mapNew.get("imgUrl");
		newEvent.startDate=mapNew.get("startDate");
		newEvent.endDate=mapNew.get("endDate");
		
		oldEvent.color=mapOld.get("color");
		oldEvent.title=mapOld.get("title");
		oldEvent.discription=mapOld.get("discription");
		oldEvent.imgUrl=mapOld.get("imgUrl");
		oldEvent.startDate=mapOld.get("startDate");
		oldEvent.endDate=mapOld.get("endDate");
				
		try {
			newEvent.editEvent(oldEvent, newEvent);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		response.setCharacterEncoding("UTF-8"); // You want world domination, huh?
		response.getWriter().write("Done");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
