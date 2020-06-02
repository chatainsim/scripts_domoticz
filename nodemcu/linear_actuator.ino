
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266HTTPClient.h>

int ENA = 4; //4;
int IN1 = 0; //0;
int IN2 = 2; //2;
int BUTTON_PIN = D1;
int buttonState;
int lastButtonState = LOW;
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers
int statedoor = 1;
#ifndef STASSID
#define STASSID "WIFI_SSID"
#define STAPSK  "WIFI_PASSWORD"
#endif

const char* ssid     = STASSID;
const char* password = STAPSK;

ESP8266WiFiMulti WiFiMulti;
ESP8266WebServer server(80);
void handleRoot() {

Serial.println("Got a Request");
if (server.arg(0)[0] == '1') {
  opendoor();
  urlopen();
  statedoor = 1;
//relayState = !relayState;
}
if (server.arg(0)[0] == '2') {
  closedoor();
  urlclose();
  statedoor = 0;
//relayState2 = !relayState2;
}
String msg = "";
msg += "<html><body>\n";
msg += "<h1>Relay Remote</h1>";
msg += "<h2><a href='?a=1'/>Open</a></h2>";
msg += "<h2><a href='?a=2'/>Close</a></h2>";
msg += "</body></html>";
server.send(200, "text/html", msg);
}
void setup() {
  HTTPClient http;
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);     // Initialize the LED_BUILTIN pin as an output
  pinMode(ENA, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(ssid, password);
  Serial.print("Wait for WiFi... ");
  while (WiFiMulti.run() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  delay(500);
  server.on("/", handleRoot);
  server.begin();
  Serial.println("HTTP server started");
}

// this function will run the motors in both directions at a fixed speed

void testOne() {
delay(5000); // now turn off motors
digitalWrite(IN1, LOW);
digitalWrite(IN2, LOW);
}
void opendoor() {
  digitalWrite(ENA, HIGH);  // set speed to 200 out of possible range 0~255
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
}
void closedoor() {
  digitalWrite(ENA, HIGH);
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
}
void urlopen() {
  HTTPClient http;
  http.begin("http://192.168.1.248:8080/json.htm?type=command&param=switchlight&idx=475&switchcmd=On");
  int httpCode = http.GET();
  http.end();
}
void urlclose() {
  HTTPClient http;
  http.begin("http://192.168.1.248:8080/json.htm?type=command&param=switchlight&idx=475&switchcmd=Off");
  int httpCode = http.GET();
  http.end();
}
void loop() {
  HTTPClient http;
  server.handleClient();
  int reading = digitalRead(BUTTON_PIN);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
   if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState == LOW) {
        Serial.println("Button Low");
        if (statedoor == 1) {
          closedoor();
          urlclose();
          Serial.println("Close door");
          statedoor = 0;
        } else {
          opendoor();
          urlopen();
          Serial.println("Open door");
          statedoor = 1;
        }
      }
    }
  }
  //testOne();   
 lastButtonState = reading;
}
