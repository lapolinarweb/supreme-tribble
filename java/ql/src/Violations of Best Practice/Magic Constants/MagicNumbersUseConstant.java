// Problem version
public class MagicConstants
{
	public static final String IP = "127.0.0.1";
	public static final int PORT = 8080;
	public static final String USERNAME = "test";
	public static final int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		int internalPort = 8080;  // AVOID: Magic number

		new MagicConstants().serve(IP, internalPort, USERNAME, TIMEOUT);
	}
}


// Fixed version
public class MagicConstants
{
	public static final String IP = "127.0.0.1";
	public static final int PORT = 8080;
	public static final String USERNAME = "test";
	public static final int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		new MagicConstants().serve(IP, PORT, USERNAME, TIMEOUT);  // Use 'PORT' constant
	}
}