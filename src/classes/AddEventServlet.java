package classes;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddEventServlet
 */
@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddEventServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
	        String [] dataArray = decoded.split("~");
	        Map <String,String> map = new HashMap<String, String>();
			Event newEvent = new Event();
	        for (int i=0;i<dataArray.length;i++)
	        {
	        	String [] keyAndValue = dataArray[i].split("<");
	        	map.put(keyAndValue[0], keyAndValue[1]);
	        }
	       
 
			newEvent.color=map.get("color");
			newEvent.title=map.get("title");
			newEvent.discription=map.get("discription");
			newEvent.imgUrl=map.get("imgUrl");
			newEvent.startDate=map.get("startDate");
			newEvent.endDate=map.get("endDate");
			newEvent.addEvent(newEvent);
			response.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
			response.setCharacterEncoding("UTF-8"); // You want world domination, huh?
			response.getWriter().write("Done");  
	}
	
}
