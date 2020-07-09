import java.io.*;
import java.net.Socket;
import java.beans.XMLDecoder;
import com.thoughtworks.xstream.XStream;
import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import org.yaml.snakeyaml.constructor.SafeConstructor;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.Yaml;

public class A {
  public Object deserialize1(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    ObjectInputStream in = new ObjectInputStream(inputStream);
    return in.readObject(); // unsafe
  }

  public Object deserialize2(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    ObjectInputStream in = new ObjectInputStream(inputStream);
    return in.readUnshared(); // unsafe
  }

  public Object deserialize3(Socket sock) {
    InputStream inputStream = sock.getInputStream();
    XMLDecoder d = new XMLDecoder(inputStream);
    return d.readObject(); // unsafe
  }

  public Object deserialize4(Socket sock) {
    XStream xs = new XStream();
    InputStream inputStream = sock.getInputStream();
    Reader reader = new InputStreamReader(inputStream);
    return xs.fromXML(reader); // unsafe
  }

  public void deserialize5(Socket sock) {
    Kryo kryo = new Kryo();
    Input input = new Input(sock.getInputStream());
    A a1 = kryo.readObject(input, A.class); // unsafe
    A a2 = kryo.readObjectOrNull(input, A.class); // unsafe
    Object o = kryo.readClassAndObject(input); // unsafe
  }

  private Kryo getSafeKryo() {
    Kryo kryo = new Kryo();
    kryo.setRegistrationRequired(true);
    // ... kryo.register(A.class) ...
    return kryo;
  }

  public void deserialize6(Socket sock) {
    Kryo kryo = getSafeKryo();
    Input input = new Input(sock.getInputStream());
    Object o = kryo.readClassAndObject(input); // OK
  }

  public void deserializeSnakeYaml(Socket sock) {
    Yaml yaml = new Yaml();
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); //unsafe
    Object o2 = yaml.loadAll(input); //unsafe
    Object o3 = yaml.parse(new InputStreamReader(input)); //unsafe
    A o4 = yaml.loadAs(input, A.class); //unsafe
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); //unsafe
  }

  public void deserializeSnakeYaml2(Socket sock) {
    Yaml yaml = new Yaml(new Constructor());
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); //unsafe
    Object o2 = yaml.loadAll(input); //unsafe
    Object o3 = yaml.parse(new InputStreamReader(input)); //unsafe
    A o4 = yaml.loadAs(input, A.class); //unsafe
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); //unsafe
  }

  public void deserializeSnakeYaml3(Socket sock) {
    Yaml yaml = new Yaml(new SafeConstructor());
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); //OK
    Object o2 = yaml.loadAll(input); //OK
    Object o3 = yaml.parse(new InputStreamReader(input)); //OK
    A o4 = yaml.loadAs(input, A.class); //OK
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); //OK
  }

  public void deserializeSnakeYaml4(Socket sock) {
    Yaml yaml = new Yaml(new Constructor(A.class));
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); //OK
    Object o2 = yaml.loadAll(input); //OK
    Object o3 = yaml.parse(new InputStreamReader(input)); //OK
    A o4 = yaml.loadAs(input, A.class); //OK
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); //OK
  }
}
