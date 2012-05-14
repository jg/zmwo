package aspects;
import java.io.FileWriter;
import java.io.IOException;

public class MyFileWriter extends FileWriter {
	public MyFileWriter(String s, boolean b) throws IOException {
		super(s,b);
	}
	public void println(String s) throws IOException {
		this.write(s + "\n");
	}
}
