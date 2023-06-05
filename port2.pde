import processing.serial.*;

void setup() {
  String[] portNames = Serial.list();

  for (String portName : portNames) {
    try {
      Serial port = new Serial(this, portName, 9600);
      // Replace 9600 with the appropriate baud rate for your device

      // Send a command or request to the device and wait for a response
      port.write("PING"); // Replace with the appropriate command to communicate with your device

      // Wait for a short period to receive a response from the device
      delay(500); // Adjust the delay as needed

      // Check if there is any data available to read
      if (port.available() > 0) {
        // Read the response from the device
        String response = port.readString();
        
        // Check the response to confirm if the device is connected
        if (response != null && response.equals("PING")) {
          println("Device is connected to port: " + portName);
        } else {
          println("No device connected to port: " + portName);
        }
      } else {
        println("No device connected to port: " + portName);
      }

      // Close the port
      port.stop();
    } 
    catch (Exception e) {
      println("PORT BUSY: " + portName);
      e.printStackTrace();
    }
  }
}
